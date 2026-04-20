const express = require("express");
const router = express.Router();

const Giving = require("../models/Giving");
const protect = require("../middleware/authMiddleware");

// ── POST /api/giving — record a new giving ────────────────────────────────────
router.post("/", protect, async (req, res) => {
  try {
    const { title, amount, currency, currencySymbol, category, note, church, givenAt } =
      req.body;

    if (!title || amount == null) {
      return res.status(400).json({ message: "Title and amount are required" });
    }

    const record = await Giving.create({
      user: req.user.id,
      church: church || null,
      title,
      amount,
      currency: currency || "USD",
      currencySymbol: currencySymbol || "$",
      category: category || "other",
      note: note || "",
      givenAt: givenAt ? new Date(givenAt) : new Date(),
    });

    res.status(201).json(record);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/giving — get current user's giving history ──────────────────────
router.get("/", protect, async (req, res) => {
  try {
    const records = await Giving.find({ user: req.user.id })
      .populate("church", "name")
      .sort({ givenAt: -1 });

    res.json(records);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/giving/stats — total given by currency for the current user ──────
router.get("/stats", protect, async (req, res) => {
  try {
    const stats = await Giving.aggregate([
      { $match: { user: require("mongoose").Types.ObjectId.createFromHexString(req.user.id) } },
      {
        $group: {
          _id: "$currency",
          total: { $sum: "$amount" },
          count: { $sum: 1 },
          currencySymbol: { $first: "$currencySymbol" },
        },
      },
    ]);

    res.json(stats);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── DELETE /api/giving/:id — delete a giving record ──────────────────────────
router.delete("/:id", protect, async (req, res) => {
  try {
    const record = await Giving.findOneAndDelete({
      _id: req.params.id,
      user: req.user.id,
    });
    if (!record) return res.status(404).json({ message: "Record not found" });
    res.json({ message: "Giving record deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
