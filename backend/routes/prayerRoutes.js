const express = require("express");
const router = express.Router();

const Prayer = require("../models/Prayer");
const Notification = require("../models/Notification");
const protect = require("../middleware/authMiddleware");


// =====================================
// 🙏 CREATE PRAYER
// =====================================
router.post("/", protect, async (req, res) => {
  const { title, content } = req.body;

  if (!title || !content) {
    return res.status(400).json({ message: "Title and content required" });
  }

  const prayer = await Prayer.create({
    user: req.user.id,
    title,
    content
  });

  res.status(201).json(prayer);
});


// =====================================
// 📥 GET ALL PRAYERS
// =====================================
router.get("/", protect, async (req, res) => {
  const prayers = await Prayer.find()
    .populate("user", "name email")
    .populate("comments.user", "name email")
    .sort({ createdAt: -1 });

  res.json(prayers);
});


// =====================================
// ❤️ LIKE / UNLIKE PRAYER
// =====================================
router.post("/:id/like", protect, async (req, res) => {
  const prayer = await Prayer.findById(req.params.id);

  if (!prayer) {
    return res.status(404).json({ message: "Prayer not found" });
  }

  const alreadyLiked = prayer.likes.includes(req.user.id);

  // 🔴 UNLIKE
  if (alreadyLiked) {
    prayer.likes = prayer.likes.filter(
      (id) => id.toString() !== req.user.id
    );

    await prayer.save();

    return res.json({
      message: "Prayer unliked",
      likesCount: prayer.likes.length
    });
  }

  // 🟢 LIKE
  prayer.likes.push(req.user.id);
  await prayer.save();

  // 🔔 Notification
  if (prayer.user.toString() !== req.user.id) {
    await Notification.create({
      user: prayer.user,
      fromUser: req.user.id,
      type: "like",
      prayer: prayer._id,
      message: `${req.user.name} liked your prayer ❤️`
    });
  }

  res.json({
    message: "Prayer liked",
    likesCount: prayer.likes.length
  });
});

// =====================================
// 💬 ADD COMMENT
// =====================================
router.post("/:id/comment", protect, async (req, res) => {
  const { text } = req.body;

  if (!text) {
    return res.status(400).json({ message: "Text is required" });
  }

  const prayer = await Prayer.findById(req.params.id);

  if (!prayer) {
    return res.status(404).json({ message: "Prayer not found" });
  }

  const comment = {
    user: req.user.id,
    text
  };

  prayer.comments.push(comment);
  await prayer.save();

// 🔔 Notification (COMMENT)
if (prayer.user.toString() !== req.user.id) {
  await Notification.create({
    user: prayer.user,
    fromUser: req.user.id,
    type: "comment",
    prayer: prayer._id,
    message: `${req.user.name} commented: "${text}" 💬`
  });
}

  const updatedPrayer = await Prayer.findById(req.params.id)
    .populate("comments.user", "name email");

  res.json({
    message: "Comment added",
    comments: updatedPrayer.comments
  });
});


// =====================================
// ❌ DELETE COMMENT
// =====================================
router.delete("/:prayerId/comment/:commentId", protect, async (req, res) => {
  const prayer = await Prayer.findById(req.params.prayerId);

  if (!prayer) {
    return res.status(404).json({ message: "Prayer not found" });
  }

  const initialLength = prayer.comments.length;

  // ✅ delete comment
  prayer.comments = prayer.comments.filter(
    (comment) => comment._id.toString() !== req.params.commentId
  );

  if (prayer.comments.length === initialLength) {
    return res.status(404).json({ message: "Comment not found" });
  }

  await prayer.save();

  const updatedPrayer = await Prayer.findById(req.params.prayerId)
    .populate("comments.user", "name email");

  res.json({
    message: "Comment deleted",
    comments: updatedPrayer.comments
  });
});


module.exports = router;
