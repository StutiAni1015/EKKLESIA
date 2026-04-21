const express  = require("express");
const router   = express.Router();
const protect  = require("../middleware/authMiddleware");
const Church   = require("../models/Church");
const ChurchPlan  = require("../models/ChurchPlan");
const ChurchPlanProgress = require("../models/ChurchPlanProgress");

// ── helper: verify caller is pastor of this church ────────────────────────────
async function verifyPastor(churchId, userId) {
  const church = await Church.findById(churchId);
  if (!church) return false;
  return church.pastor.toString() === userId;
}

// ── helper: verify caller is member (or pastor) ───────────────────────────────
async function verifyMember(churchId, userId) {
  const church = await Church.findById(churchId);
  if (!church) return false;
  if (church.pastor.toString() === userId) return true;
  return church.members.some(m => m.toString() === userId);
}

// ── GET /api/church-plan/:churchId
//    Returns the active plan + caller's progress
router.get("/:churchId", protect, async (req, res) => {
  try {
    const ok = await verifyMember(req.params.churchId, req.user.id);
    if (!ok) return res.status(403).json({ message: "Not a member" });

    const plan = await ChurchPlan.findOne({ church: req.params.churchId, isActive: true });
    if (!plan) return res.json({ plan: null, completedDays: [] });

    const progress = await ChurchPlanProgress.findOne({ plan: plan._id, user: req.user.id });
    res.json({ plan, completedDays: progress?.completedDays ?? [] });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── POST /api/church-plan/:churchId  — pastor creates/replaces the active plan
router.post("/:churchId", protect, async (req, res) => {
  try {
    const isPastor = await verifyPastor(req.params.churchId, req.user.id);
    if (!isPastor) return res.status(403).json({ message: "Only the pastor can set the church plan" });

    const { title, description, startDate, days } = req.body;
    if (!title || !Array.isArray(days) || days.length === 0) {
      return res.status(400).json({ message: "title and at least one day are required" });
    }

    // Deactivate any existing plans
    await ChurchPlan.updateMany({ church: req.params.churchId }, { isActive: false });
    // Also wipe old progress records for this church
    const oldPlans = await ChurchPlan.find({ church: req.params.churchId });
    const oldIds   = oldPlans.map(p => p._id);
    await ChurchPlanProgress.deleteMany({ plan: { $in: oldIds } });

    const plan = await ChurchPlan.create({
      church:      req.params.churchId,
      createdBy:   req.user.id,
      title,
      description: description || "",
      startDate:   startDate ? new Date(startDate) : new Date(),
      days: days.map((d, i) => ({
        dayNumber:  d.dayNumber ?? i + 1,
        title:      d.title      || "",
        scripture:  d.scripture  || "",
        reflection: d.reflection || "",
      })),
    });

    res.status(201).json(plan);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── PATCH /api/church-plan/:churchId/toggle-day  — member toggles a day
//    body: { dayNumber: Number }
router.patch("/:churchId/toggle-day", protect, async (req, res) => {
  try {
    const ok = await verifyMember(req.params.churchId, req.user.id);
    if (!ok) return res.status(403).json({ message: "Not a member" });

    const plan = await ChurchPlan.findOne({ church: req.params.churchId, isActive: true });
    if (!plan) return res.status(404).json({ message: "No active plan" });

    const dayNumber = Number(req.body.dayNumber);
    if (!dayNumber) return res.status(400).json({ message: "dayNumber required" });

    let progress = await ChurchPlanProgress.findOne({ plan: plan._id, user: req.user.id });
    if (!progress) {
      progress = new ChurchPlanProgress({
        plan:   plan._id,
        church: req.params.churchId,
        user:   req.user.id,
        completedDays: [],
      });
    }

    const idx = progress.completedDays.indexOf(dayNumber);
    if (idx === -1) {
      progress.completedDays.push(dayNumber);
    } else {
      progress.completedDays.splice(idx, 1);
    }
    await progress.save();

    res.json({ completedDays: progress.completedDays });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/church-plan/:churchId/stats  — pastor sees per-day completion counts
router.get("/:churchId/stats", protect, async (req, res) => {
  try {
    const isPastor = await verifyPastor(req.params.churchId, req.user.id);
    if (!isPastor) return res.status(403).json({ message: "Pastor only" });

    const plan = await ChurchPlan.findOne({ church: req.params.churchId, isActive: true });
    if (!plan) return res.json({ plan: null, stats: {} });

    const allProgress = await ChurchPlanProgress.find({ plan: plan._id });
    const totalMembers = allProgress.length;

    // Count completions per day
    const dayCounts = {};
    for (const p of allProgress) {
      for (const d of p.completedDays) {
        dayCounts[d] = (dayCounts[d] || 0) + 1;
      }
    }

    res.json({ plan, stats: dayCounts, totalMembers });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── DELETE /api/church-plan/:churchId  — pastor deletes the active plan
router.delete("/:churchId", protect, async (req, res) => {
  try {
    const isPastor = await verifyPastor(req.params.churchId, req.user.id);
    if (!isPastor) return res.status(403).json({ message: "Pastor only" });

    await ChurchPlan.updateMany({ church: req.params.churchId }, { isActive: false });
    res.json({ message: "Plan removed" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

module.exports = router;
