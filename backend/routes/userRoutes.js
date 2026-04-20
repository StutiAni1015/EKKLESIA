const express = require("express");
const router = express.Router();

const User = require("../models/User");
const protect = require("../middleware/authMiddleware");

// ── GET /api/user/profile — get the current user's full profile ───────────────
router.get("/profile", protect, async (req, res) => {
  try {
    const user = await User.findById(req.user.id)
      .select("-password")
      .populate("joinedChurch", "name denomination city country");

    if (!user) return res.status(404).json({ message: "User not found" });

    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── PUT /api/user/profile — update editable profile fields ───────────────────
router.put("/profile", protect, async (req, res) => {
  try {
    const { name, bio, country, countryIso, city, currency, currencySymbol, avatarUrl } =
      req.body;

    const updates = {};
    if (name !== undefined) updates.name = name;
    if (bio !== undefined) updates.bio = bio;
    if (country !== undefined) updates.country = country;
    if (countryIso !== undefined) updates.countryIso = countryIso;
    if (city !== undefined) updates.city = city;
    if (currency !== undefined) updates.currency = currency;
    if (currencySymbol !== undefined) updates.currencySymbol = currencySymbol;
    if (avatarUrl !== undefined) updates.avatarUrl = avatarUrl;

    const user = await User.findByIdAndUpdate(req.user.id, updates, {
      new: true,
      runValidators: true,
    })
      .select("-password")
      .populate("joinedChurch", "name denomination city country");

    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/user/:id — public profile of any user ───────────────────────────
router.get("/:id", async (req, res) => {
  try {
    const user = await User.findById(req.params.id)
      .select("name bio country city avatarUrl isPastor joinedChurch createdAt")
      .populate("joinedChurch", "name denomination");

    if (!user) return res.status(404).json({ message: "User not found" });

    res.json(user);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
