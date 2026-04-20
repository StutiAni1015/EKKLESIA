const express = require("express");
const router = express.Router();

const GlobalPrayer = require("../models/GlobalPrayer");
const protect = require("../middleware/authMiddleware");

// ── POST /api/global-prayer — submit a prayer to the global map ───────────────
router.post("/", protect, async (req, res) => {
  try {
    const { title, body, category, location, countryIso, countryName, isAnonymous } =
      req.body;

    if (!title || !body) {
      return res.status(400).json({ message: "Title and body are required" });
    }

    const prayer = await GlobalPrayer.create({
      user: isAnonymous ? null : req.user.id,
      title,
      body,
      category: category || "Other",
      location: location || "",
      countryIso: countryIso || "",
      countryName: countryName || "",
      isAnonymous: !!isAnonymous,
    });

    res.status(201).json(prayer);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/global-prayer — recent global prayers (public, no auth required) ──
router.get("/", async (req, res) => {
  try {
    const limit = parseInt(req.query.limit) || 20;
    const prayers = await GlobalPrayer.find()
      .sort({ createdAt: -1 })
      .limit(limit)
      .populate("user", "name");

    res.json(prayers);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/global-prayer/stats — aggregate counts ──────────────────────────
router.get("/stats", async (req, res) => {
  try {
    const totalPrayers = await GlobalPrayer.countDocuments();
    // Count distinct countries that have at least 1 prayer
    const countries = await GlobalPrayer.distinct("countryIso");

    res.json({
      totalPrayers,
      totalCountries: countries.length,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/global-prayer/map — country-level prayer counts (for the map) ────
router.get("/map", async (req, res) => {
  try {
    const counts = await GlobalPrayer.aggregate([
      { $match: { countryIso: { $ne: "" } } },
      { $group: { _id: "$countryIso", count: { $sum: 1 } } },
      { $project: { _id: 0, countryIso: "$_id", count: 1 } },
    ]);

    res.json(counts);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── POST /api/global-prayer/:id/pray — toggle "prayed" on a global prayer ────
router.post("/:id/pray", protect, async (req, res) => {
  try {
    const prayer = await GlobalPrayer.findById(req.params.id);
    if (!prayer) return res.status(404).json({ message: "Prayer not found" });

    const alreadyPrayed = prayer.prayedBy.includes(req.user.id);
    if (alreadyPrayed) {
      prayer.prayedBy = prayer.prayedBy.filter(
        (uid) => uid.toString() !== req.user.id
      );
      await prayer.save();
      return res.json({ message: "Unprayed", prayCount: prayer.prayedBy.length });
    }

    prayer.prayedBy.push(req.user.id);
    await prayer.save();
    res.json({ message: "Prayed", prayCount: prayer.prayedBy.length });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── DELETE /api/global-prayer/:id — author can remove their own prayer ────────
router.delete("/:id", protect, async (req, res) => {
  try {
    const prayer = await GlobalPrayer.findById(req.params.id);
    if (!prayer) return res.status(404).json({ message: "Prayer not found" });

    if (prayer.user?.toString() !== req.user.id) {
      return res.status(403).json({ message: "Not authorised" });
    }

    await prayer.deleteOne();
    res.json({ message: "Prayer deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
