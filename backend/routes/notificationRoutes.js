const express = require("express");
const router = express.Router();

const Notification = require("../models/Notification");
const protect = require("../middleware/authMiddleware");

// 📥 Get notifications
router.get("/", protect, async (req, res) => {
  const notifications = await Notification.find({ user: req.user.id })
    .populate("fromUser", "name email")
    .sort({ createdAt: -1 });

  res.json(notifications);
});
router.get("/unread/count", protect, async (req, res) => {
  const count = await Notification.countDocuments({
    user: req.user.id,
    read: false
  });

  res.json({ unreadCount: count });
});
router.put("/:id/read", protect, async (req, res) => {
  const notification = await Notification.findById(req.params.id);

  if (!notification) {
    return res.status(404).json({ message: "Notification not found" });
  }

  // 🔐 Make sure user owns it
  if (notification.user.toString() !== req.user.id) {
    return res.status(401).json({ message: "Not authorized" });
  }

  notification.read = true;
  await notification.save();

  res.json({ message: "Notification marked as read" });
});

module.exports = router;
