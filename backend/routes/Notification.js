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

module.exports = router;
