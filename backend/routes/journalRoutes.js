const express = require("express");
const router = express.Router();

const Journal = require("../models/Journal");
const protect = require("../middleware/authMiddleware");

// ➕ Create journal
router.post("/", protect, async (req, res) => {
  const { title, content } = req.body;

  const journal = await Journal.create({
    user: req.user.id,
    title,
    content
  });

  res.json(journal);
});

// 📥 Get all journals
router.get("/", protect, async (req, res) => {
  const journals = await Journal.find({ user: req.user.id });

  res.json(journals);
});

module.exports = router; // 🔥 VERY IMPORTANT
