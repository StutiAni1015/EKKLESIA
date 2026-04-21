const express  = require("express");
const router   = express.Router();
const protect  = require("../middleware/authMiddleware");
const Church   = require("../models/Church");
const User     = require("../models/User");
const ChurchLyrics = require("../models/ChurchLyrics");
const ChurchMedia  = require("../models/ChurchMedia");

const WORSHIP_ROLES = ["worship_leader", "media_team", "choir", "secretary"];

// ── helpers ───────────────────────────────────────────────────────────────────

async function getRole(churchId, userId) {
  const church = await Church.findById(churchId);
  if (!church) return null;
  if (church.pastor.toString() === userId) return "pastor";
  if (!church.members.some(m => m.toString() === userId)) return null;
  const entry = church.memberRoles.find(r => r.user.toString() === userId);
  return entry?.role || "member";
}

function canManage(role) {
  return role === "pastor" || role === "worship_leader";
}

// ── GET /api/church-lyrics/:churchId
//    Public: approved only.  Worship leader / pastor: all.
router.get("/:churchId", protect, async (req, res) => {
  try {
    const role = await getRole(req.params.churchId, req.user.id);
    if (!role) return res.status(403).json({ message: "Not a member" });

    const filter = { church: req.params.churchId };
    if (!canManage(role)) filter.isApproved = true;

    const lyrics = await ChurchLyrics.find(filter).sort({ createdAt: -1 });
    res.json(lyrics);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── POST /api/church-lyrics/:churchId  — submit text lyrics
router.post("/:churchId", protect, async (req, res) => {
  try {
    const role = await getRole(req.params.churchId, req.user.id);
    if (!role) return res.status(403).json({ message: "Not a member" });

    const { title, artist, textContent } = req.body;
    if (!title || !textContent) {
      return res.status(400).json({ message: "title and textContent are required" });
    }

    const user = await User.findById(req.user.id).select("name");
    const isAutoApproved = canManage(role); // worship leaders auto-approve their own

    const doc = await ChurchLyrics.create({
      church:        req.params.churchId,
      submittedBy:   req.user.id,
      submitterName: user?.name || "",
      submitterRole: role,
      title:         title.trim(),
      artist:        (artist || "").trim(),
      contentType:   "text",
      textContent:   textContent,
      isApproved:    isAutoApproved,
      approvedBy:    isAutoApproved ? req.user.id : null,
    });

    res.status(201).json(doc);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── POST /api/church-lyrics/:churchId/from-media/:mediaId
//    Promote a ChurchMedia file to the Lyrics tab
router.post("/:churchId/from-media/:mediaId", protect, async (req, res) => {
  try {
    const role = await getRole(req.params.churchId, req.user.id);
    if (!canManage(role)) return res.status(403).json({ message: "Only worship leaders can add lyrics" });

    const media = await ChurchMedia.findById(req.params.mediaId);
    if (!media) return res.status(404).json({ message: "Media not found" });

    const { title, artist } = req.body;
    const user = await User.findById(req.user.id).select("name");

    const doc = await ChurchLyrics.create({
      church:        req.params.churchId,
      submittedBy:   req.user.id,
      submitterName: user?.name || "",
      submitterRole: role,
      title:         title || media.title,
      artist:        artist || "",
      contentType:   "file",
      mediaRef:      media._id,
      mediaFileUrl:  media.fileUrl,
      mediaFileType: media.fileType,
      isApproved:    true,
      approvedBy:    req.user.id,
    });

    res.status(201).json(doc);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── PATCH /api/church-lyrics/:churchId/:lyricsId/approve
router.patch("/:churchId/:lyricsId/approve", protect, async (req, res) => {
  try {
    const role = await getRole(req.params.churchId, req.user.id);
    if (!canManage(role)) return res.status(403).json({ message: "Only worship leaders can approve lyrics" });

    const doc = await ChurchLyrics.findByIdAndUpdate(
      req.params.lyricsId,
      { isApproved: true, approvedBy: req.user.id },
      { new: true }
    );
    if (!doc) return res.status(404).json({ message: "Not found" });
    res.json(doc);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── PATCH /api/church-lyrics/:churchId/:lyricsId/reject
router.patch("/:churchId/:lyricsId/reject", protect, async (req, res) => {
  try {
    const role = await getRole(req.params.churchId, req.user.id);
    if (!canManage(role)) return res.status(403).json({ message: "Only worship leaders can reject lyrics" });

    await ChurchLyrics.findByIdAndDelete(req.params.lyricsId);
    res.json({ message: "Lyrics removed" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── PUT /api/church-lyrics/:churchId/:lyricsId  — edit text lyrics
router.put("/:churchId/:lyricsId", protect, async (req, res) => {
  try {
    const role = await getRole(req.params.churchId, req.user.id);
    const doc = await ChurchLyrics.findById(req.params.lyricsId);
    if (!doc) return res.status(404).json({ message: "Not found" });

    const isOwner = doc.submittedBy.toString() === req.user.id;
    if (!isOwner && !canManage(role)) return res.status(403).json({ message: "Not authorized" });

    const { title, artist, textContent } = req.body;
    if (title)       doc.title       = title.trim();
    if (artist !== undefined) doc.artist = (artist || "").trim();
    if (textContent) doc.textContent  = textContent;

    await doc.save();
    res.json(doc);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── DELETE /api/church-lyrics/:churchId/:lyricsId
router.delete("/:churchId/:lyricsId", protect, async (req, res) => {
  try {
    const role = await getRole(req.params.churchId, req.user.id);
    const doc = await ChurchLyrics.findById(req.params.lyricsId);
    if (!doc) return res.status(404).json({ message: "Not found" });

    const isOwner = doc.submittedBy.toString() === req.user.id;
    if (!isOwner && !canManage(role)) return res.status(403).json({ message: "Not authorized" });

    await ChurchLyrics.findByIdAndDelete(req.params.lyricsId);
    res.json({ message: "Deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
