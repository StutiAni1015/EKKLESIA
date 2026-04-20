const express = require("express");
const router = express.Router();

const Church = require("../models/Church");
const User = require("../models/User");
const protect = require("../middleware/authMiddleware");

// ── POST /api/church — create a new church (pastor) ──────────────────────────
router.post("/", protect, async (req, res) => {
  try {
    const {
      name, denomination, address, city, country,
      phone, email, website, youtube, instagram, allowTestimonies, lat, lng,
    } = req.body;

    if (!name) {
      return res.status(400).json({ message: "Church name is required" });
    }

    const church = await Church.create({
      name, denomination, address, city, country,
      phone, email, website, youtube, instagram,
      allowTestimonies: allowTestimonies !== false,
      pastor: req.user.id,
      lat: lat ?? null,
      lng: lng ?? null,
    });

    // Mark user as pastor
    await User.findByIdAndUpdate(req.user.id, { isPastor: true });

    res.status(201).json(church);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/church — search / list approved churches ────────────────────────
router.get("/", async (req, res) => {
  try {
    const { q, denomination } = req.query;
    const filter = { status: "approved" };

    if (q) {
      filter.$or = [
        { name: { $regex: q, $options: "i" } },
        { city: { $regex: q, $options: "i" } },
        { address: { $regex: q, $options: "i" } },
        { denomination: { $regex: q, $options: "i" } },
      ];
    }

    if (denomination) {
      filter.denomination = { $regex: denomination, $options: "i" };
    }

    const churches = await Church.find(filter)
      .populate("pastor", "name email")
      .sort({ createdAt: -1 });

    res.json(churches);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/church/my — churches the current user has joined ────────────────
router.get("/my", protect, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).populate(
      "joinedChurch",
      "name denomination city country pastor members"
    );

    if (!user) return res.status(404).json({ message: "User not found" });

    // Also include churches the user pastors
    const pastored = await Church.find({ pastor: req.user.id })
      .populate("pastor", "name email");

    res.json({
      joined: user.joinedChurch || null,
      pastored,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── POST /api/church/:id/join — join a church ────────────────────────────────
router.post("/:id/join", protect, async (req, res) => {
  try {
    const church = await Church.findById(req.params.id);
    if (!church) return res.status(404).json({ message: "Church not found" });

    // Add user to church members list (idempotent)
    if (!church.members.includes(req.user.id)) {
      church.members.push(req.user.id);
      await church.save();
    }

    // Set as user's joined church
    await User.findByIdAndUpdate(req.user.id, { joinedChurch: church._id });

    res.json({ message: "Joined church", church });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── DELETE /api/church/:id/leave — leave a church ────────────────────────────
router.delete("/:id/leave", protect, async (req, res) => {
  try {
    const church = await Church.findById(req.params.id);
    if (!church) return res.status(404).json({ message: "Church not found" });

    church.members = church.members.filter(
      (uid) => uid.toString() !== req.user.id
    );
    await church.save();

    // Clear user's joinedChurch if it was this church
    await User.findByIdAndUpdate(req.user.id, { joinedChurch: null });

    res.json({ message: "Left church" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/church/:id — single church ──────────────────────────────────────
router.get("/:id", async (req, res) => {
  try {
    const church = await Church.findById(req.params.id)
      .populate("pastor", "name email")
      .populate("members", "name");

    if (!church) return res.status(404).json({ message: "Church not found" });
    res.json(church);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
