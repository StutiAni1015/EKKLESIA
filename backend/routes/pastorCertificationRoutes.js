const express  = require("express");
const router   = express.Router();
const multer   = require("multer");
const path     = require("path");
const fs       = require("fs");
const { v4: uuidv4 } = require("uuid");

const User    = require("../models/User");
const protect = require("../middleware/authMiddleware");

// ── Upload directory ──────────────────────────────────────────────────────────
const uploadDir = path.join(__dirname, "../uploads/certifications");
if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });

const storage = multer.diskStorage({
  destination: (_, __, cb) => cb(null, uploadDir),
  filename: (_, file, cb) => {
    const ext = path.extname(file.originalname);
    cb(null, `cert_${uuidv4()}${ext}`);
  },
});

const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024 }, // 10 MB max
  fileFilter: (_, file, cb) => {
    const allowed = [
      "application/pdf",
      "image/jpeg", "image/jpg", "image/png", "image/webp",
    ];
    if (allowed.includes(file.mimetype)) cb(null, true);
    else cb(new Error("Only PDF and image files are allowed for certification"));
  },
});

// ── POST /api/pastor/certification ───────────────────────────────────────────
// Upload pastoral certification document + optional institute name
router.post("/certification", protect, upload.single("certificate"), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: "No file uploaded" });
    }

    const institute = (req.body.institute || "").trim();
    const fileUrl   = `/uploads/certifications/${req.file.filename}`;

    await User.findByIdAndUpdate(req.user.id, {
      certificationUrl:       fileUrl,
      certificationInstitute: institute,
      certificationStatus:    "pending",  // admin reviews before marking 'verified'
    });

    res.json({
      message:   "Certification uploaded successfully. It will be reviewed shortly.",
      fileUrl,
      institute,
      status:    "pending",
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/pastor/certification ─────────────────────────────────────────────
// Fetch the current user's certification status
router.get("/certification", protect, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).select(
      "certificationUrl certificationInstitute certificationStatus"
    );
    if (!user) return res.status(404).json({ message: "User not found" });

    res.json({
      certificationUrl:       user.certificationUrl,
      certificationInstitute: user.certificationInstitute,
      certificationStatus:    user.certificationStatus || "none",
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
