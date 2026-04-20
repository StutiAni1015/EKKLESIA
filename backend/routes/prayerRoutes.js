const express = require("express");
const router = express.Router();

const Prayer = require("../models/Prayer");
const protect = require("../middleware/authMiddleware");
const Notification = require("../models/Notification");

// ── POST /api/prayer — create a prayer ───────────────────────────────────────
router.post("/", protect, async (req, res) => {
  try {
    const { title, content, category, isAnonymous, scope } = req.body;

    if (!content) {
      return res.status(400).json({ message: "Content is required" });
    }

    const prayer = await Prayer.create({
      user: req.user.id,
      title: title || "",
      content,
      category: category || "Other",
      isAnonymous: !!isAnonymous,
      scope: scope || "personal",
    });

    res.status(201).json(prayer);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/prayer — community prayers (church or global scope) ──────────────
router.get("/", protect, async (req, res) => {
  try {
    const { scope } = req.query;
    const filter = scope ? { scope } : { scope: { $in: ["church", "global"] } };

    const prayers = await Prayer.find(filter)
      .populate("user", "name")
      .populate("comments.user", "name")
      .sort({ createdAt: -1 });

    res.json(prayers);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/prayer/my — current user's own prayers ──────────────────────────
router.get("/my", protect, async (req, res) => {
  try {
    const prayers = await Prayer.find({ user: req.user.id })
      .populate("comments.user", "name")
      .sort({ createdAt: -1 });

    res.json(prayers);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/prayer/:id — single prayer ──────────────────────────────────────
router.get("/:id", protect, async (req, res) => {
  try {
    const prayer = await Prayer.findById(req.params.id)
      .populate("user", "name")
      .populate("comments.user", "name");

    if (!prayer) return res.status(404).json({ message: "Prayer not found" });
    res.json(prayer);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── PATCH /api/prayer/:id/answered — mark a prayer as answered ───────────────
router.patch("/:id/answered", protect, async (req, res) => {
  try {
    const prayer = await Prayer.findById(req.params.id);
    if (!prayer) return res.status(404).json({ message: "Prayer not found" });

    if (prayer.user.toString() !== req.user.id) {
      return res.status(403).json({ message: "Not authorised" });
    }

    prayer.isAnswered = true;
    await prayer.save();
    res.json(prayer);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── DELETE /api/prayer/:id — delete a prayer ─────────────────────────────────
router.delete("/:id", protect, async (req, res) => {
  try {
    const prayer = await Prayer.findById(req.params.id);
    if (!prayer) return res.status(404).json({ message: "Prayer not found" });

    if (prayer.user.toString() !== req.user.id) {
      return res.status(403).json({ message: "Not authorised" });
    }

    await prayer.deleteOne();
    res.json({ message: "Prayer deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── POST /api/prayer/:id/like — toggle like ──────────────────────────────────
router.post("/:id/like", protect, async (req, res) => {
  try {
    const prayer = await Prayer.findById(req.params.id);
    if (!prayer) return res.status(404).json({ message: "Prayer not found" });

    const alreadyLiked = prayer.likes.includes(req.user.id);

    if (alreadyLiked) {
      prayer.likes = prayer.likes.filter((id) => id.toString() !== req.user.id);
      await prayer.save();
      return res.json({ message: "Unliked", likeCount: prayer.likes.length });
    }

    prayer.likes.push(req.user.id);
    await prayer.save();

    if (prayer.user.toString() !== req.user.id) {
      await Notification.create({
        user: prayer.user,
        fromUser: req.user.id,
        type: "like",
        prayer: prayer._id,
        message: `${req.user.name} liked your prayer ❤️`,
      });

      const io = req.app.get("io");
      const users = req.app.get("users");
      const receiverSocket = users[prayer.user.toString()];
      if (receiverSocket) {
        io.to(receiverSocket).emit("newNotification", {
          message: `${req.user.name} liked your prayer ❤️`,
        });
      }
    }

    res.json({ message: "Liked", likeCount: prayer.likes.length });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── POST /api/prayer/:id/comment — add a comment ─────────────────────────────
router.post("/:id/comment", protect, async (req, res) => {
  try {
    const { text } = req.body;
    if (!text) return res.status(400).json({ message: "Comment text is required" });

    const prayer = await Prayer.findById(req.params.id);
    if (!prayer) return res.status(404).json({ message: "Prayer not found" });

    prayer.comments.push({ user: req.user.id, text });
    await prayer.save();

    if (prayer.user.toString() !== req.user.id) {
      await Notification.create({
        user: prayer.user,
        fromUser: req.user.id,
        type: "comment",
        prayer: prayer._id,
        message: `${req.user.name} commented: "${text}" 💬`,
      });

      const io = req.app.get("io");
      const users = req.app.get("users");
      const receiverSocket = users[prayer.user.toString()];
      if (receiverSocket) {
        io.to(receiverSocket).emit("newNotification", {
          message: `${req.user.name} commented: "${text}" 💬`,
        });
      }
    }

    const newComment = prayer.comments[prayer.comments.length - 1];
    res.status(201).json(newComment);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── DELETE /api/prayer/:prayerId/comment/:commentId — delete a comment ────────
router.delete("/:prayerId/comment/:commentId", protect, async (req, res) => {
  try {
    const prayer = await Prayer.findById(req.params.prayerId);
    if (!prayer) return res.status(404).json({ message: "Prayer not found" });

    const comment = prayer.comments.id(req.params.commentId);
    if (!comment) return res.status(404).json({ message: "Comment not found" });

    if (comment.user.toString() !== req.user.id) {
      return res.status(403).json({ message: "Not authorised" });
    }

    comment.deleteOne();
    await prayer.save();
    res.json({ message: "Comment deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
