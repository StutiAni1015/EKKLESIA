const express = require("express");
const router = express.Router();

const ChurchPost = require("../models/ChurchPost");
const Church = require("../models/Church");
const protect = require("../middleware/authMiddleware");

// Helper: is the caller the church's pastor?
async function isPastor(churchId, userId) {
  const church = await Church.findById(churchId).select("pastor");
  return church && church.pastor.toString() === userId;
}

// ── POST /api/church-posts — submit a post to a church ───────────────────────
// Body: { churchId, content }
router.post("/", protect, async (req, res) => {
  try {
    const { churchId, content } = req.body;
    if (!churchId || !content?.trim())
      return res.status(400).json({ message: "churchId and content are required" });

    const church = await Church.findById(churchId).select("members pastor name");
    if (!church) return res.status(404).json({ message: "Church not found" });

    // Must be a member or the pastor to post
    const isMember = church.members.some(m => m.toString() === req.user.id);
    const pastorId = church.pastor.toString() === req.user.id;
    if (!isMember && !pastorId)
      return res.status(403).json({ message: "You must be a church member to post" });

    const User = require("../models/User");
    const user = await User.findById(req.user.id).select("name");

    const post = await ChurchPost.create({
      church: churchId,
      author: req.user.id,
      authorName: user?.name || "Member",
      content: content.trim(),
      status: pastorId ? "approved" : "pending", // pastor's own posts auto-approved
    });

    res.status(201).json(post);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/church-posts/:churchId — list posts ─────────────────────────────
// Pastor sees all; members only see approved
router.get("/:churchId", protect, async (req, res) => {
  try {
    const church = await Church.findById(req.params.churchId).select("pastor members");
    if (!church) return res.status(404).json({ message: "Church not found" });

    const pastorId = church.pastor.toString() === req.user.id;
    const filter = { church: req.params.churchId };
    if (!pastorId) filter.status = "approved"; // non-pastor only sees approved

    const posts = await ChurchPost.find(filter)
      .sort({ createdAt: -1 })
      .limit(100);

    res.json(posts);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── PATCH /api/church-posts/:postId/approve — pastor approves ────────────────
router.patch("/:postId/approve", protect, async (req, res) => {
  try {
    const post = await ChurchPost.findById(req.params.postId).populate("church", "pastor");
    if (!post) return res.status(404).json({ message: "Post not found" });

    if (post.church.pastor.toString() !== req.user.id)
      return res.status(403).json({ message: "Not authorized" });

    post.status = "approved";
    await post.save();
    res.json(post);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── PATCH /api/church-posts/:postId/reject — pastor rejects (removes) ────────
router.patch("/:postId/reject", protect, async (req, res) => {
  try {
    const post = await ChurchPost.findById(req.params.postId).populate("church", "pastor");
    if (!post) return res.status(404).json({ message: "Post not found" });

    if (post.church.pastor.toString() !== req.user.id)
      return res.status(403).json({ message: "Not authorized" });

    // Hard delete on rejection — removed from the church entirely
    await ChurchPost.findByIdAndDelete(req.params.postId);
    res.json({ message: "Post removed" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── DELETE /api/church-posts/:postId — delete a post ────────────────────────
router.delete("/:postId", protect, async (req, res) => {
  try {
    const post = await ChurchPost.findById(req.params.postId).populate("church", "pastor");
    if (!post) return res.status(404).json({ message: "Post not found" });

    const isAuthor = post.author.toString() === req.user.id;
    const pastorOfChurch = post.church.pastor.toString() === req.user.id;
    if (!isAuthor && !pastorOfChurch)
      return res.status(403).json({ message: "Not authorized" });

    await ChurchPost.findByIdAndDelete(req.params.postId);
    res.json({ message: "Post deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
