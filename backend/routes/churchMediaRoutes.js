const express  = require("express");
const router   = express.Router();
const multer   = require("multer");
const path     = require("path");
const fs       = require("fs");
const { v4: uuidv4 } = require("uuid");

const ChurchMedia = require("../models/ChurchMedia");
const Church      = require("../models/Church");
const User        = require("../models/User");
const protect     = require("../middleware/authMiddleware");

// ── Upload directory ──────────────────────────────────────────────────────────

const uploadDir = path.join(__dirname, "../uploads");
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (_, __, cb) => cb(null, uploadDir),
  filename: (_, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `${uuidv4()}${ext}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 20 * 1024 * 1024 }, // 20 MB max
  fileFilter: (_, file, cb) => {
    const allowed = [
      "application/pdf",
      "image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp",
      "application/vnd.ms-powerpoint",
      "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    ];
    if (allowed.includes(file.mimetype)) cb(null, true);
    else cb(new Error("Only PDF, images, and PowerPoint files are allowed"));
  },
});

// ── Worship roles that can upload ─────────────────────────────────────────────
const WORSHIP_ROLES = ["worship_leader", "media_team", "choir", "secretary"];

async function getChurchAndRole(churchId, userId) {
  const church = await Church.findById(churchId);
  if (!church) return { church: null, role: null };

  const isPastor = church.pastor.toString() === userId;
  if (isPastor) return { church, role: "pastor" };

  const isMember = church.members.some(m => m.toString() === userId);
  if (!isMember) return { church, role: null };

  const roleEntry = church.memberRoles.find(r => r.user.toString() === userId);
  return { church, role: roleEntry?.role || "member" };
}

function detectFileType(mimetype) {
  if (mimetype === "application/pdf") return "pdf";
  if (mimetype.startsWith("image/")) return "image";
  if (mimetype.includes("powerpoint") || mimetype.includes("presentation")) return "ppt";
  return "other";
}

// ── POST /api/church-media/:churchId — upload a file ─────────────────────────
router.post("/:churchId", protect, upload.single("file"), async (req, res) => {
  try {
    const { church, role } = await getChurchAndRole(req.params.churchId, req.user.id);
    if (!church) return res.status(404).json({ message: "Church not found" });

    const canUpload = role === "pastor" || WORSHIP_ROLES.includes(role);
    if (!canUpload) return res.status(403).json({ message: "Only worship team members can upload" });

    if (!req.file) return res.status(400).json({ message: "No file uploaded" });

    const user = await User.findById(req.user.id).select("name");
    const title = req.body.title?.trim() || req.file.originalname;
    const fileUrl = `/uploads/${req.file.filename}`;

    // Client can override fileType (e.g. user explicitly selected PDF/image/ppt)
    const clientType = req.body.fileType;
    const allowedTypes = ["pdf", "image", "ppt", "other"];
    const resolvedType = allowedTypes.includes(clientType)
      ? clientType
      : detectFileType(req.file.mimetype);

    const media = await ChurchMedia.create({
      church: req.params.churchId,
      uploadedBy: req.user.id,
      uploaderName: user?.name || "Member",
      uploaderRole: role,
      title,
      fileName: req.file.originalname,
      fileUrl,
      fileType: resolvedType,
      fileSize: req.file.size,
    });

    res.status(201).json(media);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/church-media/:churchId — list files ──────────────────────────────
router.get("/:churchId", protect, async (req, res) => {
  try {
    const { church, role } = await getChurchAndRole(req.params.churchId, req.user.id);
    if (!church) return res.status(404).json({ message: "Church not found" });

    const canView = role === "pastor" || WORSHIP_ROLES.includes(role);
    if (!canView) return res.status(403).json({ message: "Access restricted to worship team" });

    const files = await ChurchMedia.find({ church: req.params.churchId }).sort({ createdAt: -1 });
    res.json(files);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── PATCH /api/church-media/:churchId/:mediaId/lyrics — toggle isLyrics ───────
router.patch("/:churchId/:mediaId/lyrics", protect, async (req, res) => {
  try {
    const { church, role } = await getChurchAndRole(req.params.churchId, req.user.id);
    if (!church) return res.status(404).json({ message: "Church not found" });

    const canToggle = role === "pastor" || role === "worship_leader";
    if (!canToggle) return res.status(403).json({ message: "Only worship leaders can manage the Lyrics tab" });

    const media = await ChurchMedia.findById(req.params.mediaId);
    if (!media) return res.status(404).json({ message: "File not found" });

    media.isLyrics = !media.isLyrics;
    await media.save();
    res.json(media);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── DELETE /api/church-media/:churchId/:mediaId ───────────────────────────────
router.delete("/:churchId/:mediaId", protect, async (req, res) => {
  try {
    const { church, role } = await getChurchAndRole(req.params.churchId, req.user.id);
    if (!church) return res.status(404).json({ message: "Church not found" });

    const media = await ChurchMedia.findById(req.params.mediaId);
    if (!media) return res.status(404).json({ message: "File not found" });

    const isOwner = media.uploadedBy.toString() === req.user.id;
    const isPastor = role === "pastor";
    if (!isOwner && !isPastor) return res.status(403).json({ message: "Not authorized" });

    // Remove file from disk
    const filePath = path.join(uploadDir, path.basename(media.fileUrl));
    if (fs.existsSync(filePath)) fs.unlinkSync(filePath);

    await ChurchMedia.findByIdAndDelete(req.params.mediaId);
    res.json({ message: "File deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
