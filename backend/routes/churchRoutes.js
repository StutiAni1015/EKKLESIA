const express = require("express");
const router = express.Router();

const Church = require("../models/Church");
const protect = require("../middleware/authMiddleware");

// =====================================
// ⛪ CREATE CHURCH  (pastor creates)
// =====================================
router.post("/", protect, async (req, res) => {
  try {
    const {
      name,
      denomination,
      address,
      city,
      country,
      phone,
      email,
      website,
      youtube,
      instagram,
      allowTestimonies,
    } = req.body;

    if (!name) {
      return res.status(400).json({ message: "Church name is required" });
    }

    const church = await Church.create({
      name,
      denomination,
      address,
      city,
      country,
      phone,
      email,
      website,
      youtube,
      instagram,
      allowTestimonies: allowTestimonies !== false,
      pastor: req.user.id,
    });

    res.status(201).json(church);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// =====================================
// 🔍 SEARCH / LIST CHURCHES
// GET /api/church?q=grace&denomination=Baptist
// =====================================
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

// =====================================
// 📋 GET SINGLE CHURCH
// =====================================
router.get("/:id", async (req, res) => {
  try {
    const church = await Church.findById(req.params.id).populate(
      "pastor",
      "name email"
    );

    if (!church) {
      return res.status(404).json({ message: "Church not found" });
    }

    res.json(church);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
