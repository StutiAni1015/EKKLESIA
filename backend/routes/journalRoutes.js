const express = require("express");
const router = express.Router();

const Journal = require("../models/Journal");
const protect = require("../middleware/authMiddleware");

// ── POST /api/journal — create an entry ──────────────────────────────────────
router.post("/", protect, async (req, res) => {
  try {
    const { title, content } = req.body;

    if (!content) {
      return res.status(400).json({ message: "Content is required" });
    }

    const journal = await Journal.create({
      user: req.user.id,
      title: title || "",
      content,
    });

    res.status(201).json(journal);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/journal — all entries for the current user ──────────────────────
router.get("/", protect, async (req, res) => {
  try {
    const journals = await Journal.find({ user: req.user.id }).sort({
      createdAt: -1,
    });
    res.json(journals);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/journal/:id — single entry ──────────────────────────────────────
router.get("/:id", protect, async (req, res) => {
  try {
    const journal = await Journal.findOne({
      _id: req.params.id,
      user: req.user.id,
    });
    if (!journal) return res.status(404).json({ message: "Journal entry not found" });
    res.json(journal);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── PUT /api/journal/:id — update an entry ────────────────────────────────────
router.put("/:id", protect, async (req, res) => {
  try {
    const { title, content } = req.body;

    const journal = await Journal.findOneAndUpdate(
      { _id: req.params.id, user: req.user.id },
      { title, content },
      { new: true, runValidators: true }
    );

    if (!journal) return res.status(404).json({ message: "Journal entry not found" });
    res.json(journal);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── DELETE /api/journal/:id — delete an entry ────────────────────────────────
router.delete("/:id", protect, async (req, res) => {
  try {
    const journal = await Journal.findOneAndDelete({
      _id: req.params.id,
      user: req.user.id,
    });
    if (!journal) return res.status(404).json({ message: "Journal entry not found" });
    res.json({ message: "Journal entry deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
