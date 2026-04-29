const express   = require("express");
const router    = express.Router();
const multer    = require("multer");
const path      = require("path");
const fs        = require("fs");
const Anthropic = require("@anthropic-ai/sdk");

const _anthropic  = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });
const _quizCache  = new Map(); // date string → questions array
const { v4: uuidv4 } = require("uuid");

const protect             = require("../middleware/authMiddleware");
const ChildProfile        = require("../models/ChildProfile");
const ParentIDVerification = require("../models/ParentIDVerification");

// ── Upload storage for parent IDs ─────────────────────────────────────────────
const idUploadDir = path.join(__dirname, "../uploads/parent-ids");
if (!fs.existsSync(idUploadDir)) fs.mkdirSync(idUploadDir, { recursive: true });

const idStorage = multer.diskStorage({
  destination: (_, __, cb) => cb(null, idUploadDir),
  filename:    (_, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `id_${uuidv4()}${ext}`);
  },
});

const idUpload = multer({
  storage: idStorage,
  limits: { fileSize: 15 * 1024 * 1024 }, // 15 MB
  fileFilter: (_, file, cb) => {
    const allowed = ["image/jpeg", "image/jpg", "image/png", "image/webp", "application/pdf"];
    if (allowed.includes(file.mimetype)) cb(null, true);
    else cb(new Error("Only images (JPG, PNG, WEBP) and PDF are accepted for ID verification"));
  },
});

// ── helpers ───────────────────────────────────────────────────────────────────
function ageGroup(age) {
  if (age <= 6)  return "5-6";
  if (age <= 10) return "7-10";
  if (age <= 14) return "11-14";
  return "15-18";
}

// ─────────────────────────────────────────────────────────────────────────────
// PARENT ID VERIFICATION
// ─────────────────────────────────────────────────────────────────────────────

// POST /api/kids/verify-parent
router.post("/verify-parent", protect, idUpload.single("idDocument"), async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ message: "No ID document uploaded" });

    const fileUrl = `/uploads/parent-ids/${req.file.filename}`;

    const existing = await ParentIDVerification.findOne({ parent: req.user.id });
    if (existing) {
      // Allow re-upload if previously rejected
      if (existing.status === "verified") {
        return res.json({ message: "Your ID is already verified", status: "verified" });
      }
      existing.idFileUrl = fileUrl;
      existing.status    = "pending";
      existing.rejectionReason = null;
      await existing.save();
      return res.json({ message: "ID re-uploaded for review", status: "pending" });
    }

    await ParentIDVerification.create({ parent: req.user.id, idFileUrl: fileUrl });
    res.status(201).json({ message: "ID submitted for verification", status: "pending" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// GET /api/kids/verify-parent/status
router.get("/verify-parent/status", protect, async (req, res) => {
  try {
    const record = await ParentIDVerification.findOne({ parent: req.user.id });
    if (!record) return res.json({ status: "none" });
    res.json({
      status:          record.status,
      verifiedAt:      record.verifiedAt,
      rejectionReason: record.rejectionReason,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// CHILD PROFILES
// ─────────────────────────────────────────────────────────────────────────────

// POST /api/kids/profiles
router.post("/profiles", protect, async (req, res) => {
  try {
    const { name, age, avatarEmoji, avatarColor } = req.body;

    if (!name || !age) return res.status(400).json({ message: "Name and age are required" });
    if (age < 5 || age > 18) return res.status(400).json({ message: "Child must be between 5 and 18 years old" });

    const child = await ChildProfile.create({
      parent:      req.user.id,
      name:        name.trim(),
      age:         Number(age),
      avatarEmoji: avatarEmoji || "🧒",
      avatarColor: avatarColor || "#FF7947",
    });

    res.status(201).json({ ...child.toObject(), ageGroup: ageGroup(child.age) });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// GET /api/kids/profiles
router.get("/profiles", protect, async (req, res) => {
  try {
    const children = await ChildProfile.find({ parent: req.user.id, isActive: true })
      .sort({ createdAt: 1 });

    res.json(children.map(c => ({ ...c.toObject(), ageGroup: ageGroup(c.age) })));
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// PATCH /api/kids/profiles/:id
router.patch("/profiles/:id", protect, async (req, res) => {
  try {
    const child = await ChildProfile.findOne({ _id: req.params.id, parent: req.user.id });
    if (!child) return res.status(404).json({ message: "Child profile not found" });

    const { name, age, avatarEmoji, avatarColor, gamesEnabled } = req.body;
    if (name)         child.name         = name.trim();
    if (age !== undefined) {
      if (age < 5 || age > 18) return res.status(400).json({ message: "Age must be between 5 and 18" });
      child.age = Number(age);
    }
    if (avatarEmoji !== undefined) child.avatarEmoji  = avatarEmoji;
    if (avatarColor !== undefined) child.avatarColor  = avatarColor;
    if (gamesEnabled !== undefined) child.gamesEnabled = gamesEnabled;

    await child.save();
    res.json({ ...child.toObject(), ageGroup: ageGroup(child.age) });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// DELETE /api/kids/profiles/:id  (soft delete)
router.delete("/profiles/:id", protect, async (req, res) => {
  try {
    const child = await ChildProfile.findOne({ _id: req.params.id, parent: req.user.id });
    if (!child) return res.status(404).json({ message: "Child profile not found" });

    child.isActive = false;
    await child.save();
    res.json({ message: "Profile removed" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// AI DAILY QUIZ
// ─────────────────────────────────────────────────────────────────────────────

// GET /api/kids/daily-quiz
router.get("/daily-quiz", protect, async (req, res) => {
  const today = new Date().toISOString().split("T")[0]; // YYYY-MM-DD

  if (_quizCache.has(today)) {
    return res.json({ questions: _quizCache.get(today), cached: true });
  }

  try {
    const response = await _anthropic.messages.create({
      model: "claude-haiku-4-5-20251001",
      max_tokens: 1200,
      messages: [{
        role: "user",
        content: `Generate exactly 5 fun Bible quiz questions for children aged 5-12.
Return ONLY a valid JSON array — no explanation, no markdown, just the raw JSON.
Each item must follow this exact structure:
{"question":"...","options":[{"label":"...","emoji":"..."},{"label":"...","emoji":"..."},{"label":"...","emoji":"..."},{"label":"...","emoji":"..."}],"correctIndex":0}
Rules:
- Each question has exactly 4 options.
- correctIndex is 0-3 (the index of the correct option).
- Use fun kid-friendly emojis for each option.
- Cover different Bible stories and characters.
- Vary difficulty from easy to medium.`
      }]
    });

    const text = response.content[0].text.trim();
    const questions = JSON.parse(text);

    if (!Array.isArray(questions) || questions.length < 5) {
      return res.status(500).json({ message: "Invalid AI response format" });
    }

    _quizCache.set(today, questions);
    res.json({ questions });
  } catch (err) {
    res.status(500).json({ message: "Failed to generate quiz", error: err.message });
  }
});

module.exports = router;
