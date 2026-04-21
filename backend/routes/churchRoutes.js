const express = require("express");
const router = express.Router();

const Church = require("../models/Church");
const ChurchPost = require("../models/ChurchPost");
const User = require("../models/User");
const Notification = require("../models/Notification");
const protect = require("../middleware/authMiddleware");

// ── Helper: verify caller is the church's pastor ──────────────────────────────
async function verifyPastor(churchId, userId) {
  const church = await Church.findById(churchId);
  if (!church) return null;
  if (church.pastor.toString() !== userId) return null;
  return church;
}

// ── POST /api/church — create a new church (pastor) ──────────────────────────
router.post("/", protect, async (req, res) => {
  try {
    const {
      name, denomination, address, city, country,
      phone, email, website, youtube, instagram, allowTestimonies, lat, lng,
    } = req.body;

    if (!name) return res.status(400).json({ message: "Church name is required" });

    const church = await Church.create({
      name, denomination, address, city, country,
      phone, email, website, youtube, instagram,
      allowTestimonies: allowTestimonies !== false,
      pastor: req.user.id,
      lat: lat ?? null,
      lng: lng ?? null,
    });

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
    if (denomination) filter.denomination = { $regex: denomination, $options: "i" };

    const churches = await Church.find(filter)
      .populate("pastor", "name email")
      .sort({ createdAt: -1 });

    res.json(churches);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/church/my — churches the current user pastors or joined ──────────
router.get("/my", protect, async (req, res) => {
  try {
    const user = await User.findById(req.user.id).populate(
      "joinedChurch", "name denomination city country pastor members"
    );
    if (!user) return res.status(404).json({ message: "User not found" });

    const pastored = await Church.find({ pastor: req.user.id })
      .populate("pastor", "name email");

    res.json({ joined: user.joinedChurch || null, pastored });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── POST /api/church/:id/request-join — submit a join request ────────────────
router.post("/:id/request-join", protect, async (req, res) => {
  try {
    const church = await Church.findById(req.params.id);
    if (!church) return res.status(404).json({ message: "Church not found" });

    if (church.members.some(m => m.toString() === req.user.id))
      return res.status(400).json({ message: "Already a member" });

    const existing = church.joinRequests.find(
      r => r.user.toString() === req.user.id && r.status === "pending"
    );
    if (existing) return res.status(400).json({ message: "Request already submitted" });

    const user = await User.findById(req.user.id).select("name");
    church.joinRequests.push({ user: req.user.id, name: user?.name || "Member" });
    await church.save();

    // Notify the pastor
    await Notification.create({
      user: church.pastor,
      fromUser: req.user.id,
      church: church._id,
      type: "join_request",
      title: "New Join Request",
      message: `${user?.name || "Someone"} wants to join ${church.name}`,
    });

    res.json({ message: "Join request submitted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/church/:id/requests — list join requests (pastor only) ───────────
router.get("/:id/requests", protect, async (req, res) => {
  try {
    const church = await verifyPastor(req.params.id, req.user.id);
    if (!church) return res.status(403).json({ message: "Not authorized" });

    await church.populate("joinRequests.user", "name email avatarUrl");
    res.json(church.joinRequests);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── PATCH /api/church/:id/requests/:reqId/approve ────────────────────────────
router.patch("/:id/requests/:reqId/approve", protect, async (req, res) => {
  try {
    const church = await verifyPastor(req.params.id, req.user.id);
    if (!church) return res.status(403).json({ message: "Not authorized" });

    const request = church.joinRequests.id(req.params.reqId);
    if (!request) return res.status(404).json({ message: "Request not found" });

    request.status = "approved";

    if (!church.members.some(m => m.toString() === request.user.toString()))
      church.members.push(request.user);

    if (!church.memberRoles.some(r => r.user.toString() === request.user.toString()))
      church.memberRoles.push({ user: request.user, role: "member" });

    await church.save();
    await User.findByIdAndUpdate(request.user, { joinedChurch: church._id });

    await Notification.create({
      user: request.user,
      fromUser: req.user.id,
      church: church._id,
      type: "join_approved",
      title: "Request Approved!",
      message: `You are now a member of ${church.name}`,
    });

    res.json({ message: "Member approved" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── PATCH /api/church/:id/requests/:reqId/reject ─────────────────────────────
router.patch("/:id/requests/:reqId/reject", protect, async (req, res) => {
  try {
    const church = await verifyPastor(req.params.id, req.user.id);
    if (!church) return res.status(403).json({ message: "Not authorized" });

    const request = church.joinRequests.id(req.params.reqId);
    if (!request) return res.status(404).json({ message: "Request not found" });

    request.status = "rejected";
    await church.save();

    await Notification.create({
      user: request.user,
      fromUser: req.user.id,
      church: church._id,
      type: "join_rejected",
      title: "Request Not Approved",
      message: `Your request to join ${church.name} was not approved at this time`,
    });

    res.json({ message: "Request rejected" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/church/:id/members — list members with roles (pastor only) ───────
router.get("/:id/members", protect, async (req, res) => {
  try {
    const church = await verifyPastor(req.params.id, req.user.id);
    if (!church) return res.status(403).json({ message: "Not authorized" });

    await church.populate("members", "name email avatarUrl");

    const result = church.members.map(m => {
      const roleEntry = church.memberRoles.find(
        r => r.user.toString() === m._id.toString()
      );
      return {
        _id: m._id,
        name: m.name,
        email: m.email,
        avatarUrl: m.avatarUrl || null,
        role: roleEntry ? roleEntry.role : "member",
      };
    });

    res.json(result);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/church/:id/online-status — which members are online ──────────────
router.get("/:id/online-status", protect, async (req, res) => {
  try {
    const church = await verifyPastor(req.params.id, req.user.id);
    if (!church) return res.status(403).json({ message: "Not authorized" });

    const users = req.app.get("users") || {}; // { userId: socketId }
    const onlineIds = new Set(Object.keys(users));

    const statusMap = {};
    church.members.forEach(m => {
      statusMap[m.toString()] = onlineIds.has(m.toString());
    });

    res.json(statusMap);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── PATCH /api/church/:id/members/:userId/role — assign role ─────────────────
router.patch("/:id/members/:userId/role", protect, async (req, res) => {
  try {
    const church = await verifyPastor(req.params.id, req.user.id);
    if (!church) return res.status(403).json({ message: "Not authorized" });

    const { role } = req.body;
    if (!["member", "secretary", "treasurer", "committee"].includes(role))
      return res.status(400).json({ message: "Invalid role" });

    if (role === "committee") {
      const committeeCount = church.memberRoles.filter(
        r => r.role === "committee" && r.user.toString() !== req.params.userId
      ).length;
      if (committeeCount >= 5)
        return res.status(400).json({ message: "Maximum 5 committee members allowed" });
    }

    const roleEntry = church.memberRoles.find(r => r.user.toString() === req.params.userId);
    if (roleEntry) {
      roleEntry.role = role;
    } else {
      church.memberRoles.push({ user: req.params.userId, role });
    }

    await church.save();
    res.json({ message: "Role updated" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── DELETE /api/church/:id/members/:userId — remove member ───────────────────
router.delete("/:id/members/:userId", protect, async (req, res) => {
  try {
    const church = await verifyPastor(req.params.id, req.user.id);
    if (!church) return res.status(403).json({ message: "Not authorized" });

    church.members = church.members.filter(m => m.toString() !== req.params.userId);
    church.memberRoles = church.memberRoles.filter(r => r.user.toString() !== req.params.userId);
    await church.save();

    await User.findByIdAndUpdate(req.params.userId, { joinedChurch: null });
    res.json({ message: "Member removed" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/church/:id/events ───────────────────────────────────────────────
router.get("/:id/events", protect, async (req, res) => {
  try {
    const church = await Church.findById(req.params.id).select("events");
    if (!church) return res.status(404).json({ message: "Church not found" });
    const sorted = [...church.events].sort((a, b) => new Date(a.date) - new Date(b.date));
    res.json(sorted);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── POST /api/church/:id/events — create event (pastor only) ─────────────────
router.post("/:id/events", protect, async (req, res) => {
  try {
    const church = await verifyPastor(req.params.id, req.user.id);
    if (!church) return res.status(403).json({ message: "Not authorized" });

    const { title, description, date, location } = req.body;
    if (!title || !date) return res.status(400).json({ message: "Title and date are required" });

    church.events.push({
      title,
      description: description || "",
      date: new Date(date),
      location: location || "",
    });
    await church.save();

    const newEvent = church.events[church.events.length - 1];

    // Notify all members
    if (church.members.length > 0) {
      const notifs = church.members.map(memberId => ({
        user: memberId,
        fromUser: req.user.id,
        church: church._id,
        type: "event",
        title: `New Event: ${title}`,
        message: `${church.name} has a new event on ${new Date(date).toLocaleDateString()}`,
      }));
      await Notification.insertMany(notifs);
    }

    res.status(201).json(newEvent);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── DELETE /api/church/:id/events/:eventId ────────────────────────────────────
router.delete("/:id/events/:eventId", protect, async (req, res) => {
  try {
    const church = await verifyPastor(req.params.id, req.user.id);
    if (!church) return res.status(403).json({ message: "Not authorized" });

    church.events = church.events.filter(e => e._id.toString() !== req.params.eventId);
    await church.save();
    res.json({ message: "Event deleted" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── POST /api/church/:id/announce — broadcast to all members ─────────────────
router.post("/:id/announce", protect, async (req, res) => {
  try {
    const church = await verifyPastor(req.params.id, req.user.id);
    if (!church) return res.status(403).json({ message: "Not authorized" });

    const { title, message } = req.body;
    if (!title || !message) return res.status(400).json({ message: "Title and message are required" });

    if (church.members.length > 0) {
      const notifs = church.members.map(memberId => ({
        user: memberId,
        fromUser: req.user.id,
        church: church._id,
        type: "announcement",
        title,
        message,
      }));
      await Notification.insertMany(notifs);
    }

    // Also notify via socket if possible
    const users = req.app.get("users") || {};
    const io = req.app.get("io");
    if (io) {
      church.members.forEach(memberId => {
        const socketId = users[memberId.toString()];
        if (socketId) {
          io.to(socketId).emit("announcement", { title, message, churchId: church._id });
        }
      });
    }

    res.json({ message: `Announcement sent to ${church.members.length} members` });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── POST /api/church/:id/go-live — pastor starts live session ────────────────
router.post("/:id/go-live", protect, async (req, res) => {
  try {
    const church = await verifyPastor(req.params.id, req.user.id);
    if (!church) return res.status(403).json({ message: "Not authorized" });

    const { streamUrl, liveTitle } = req.body;
    if (!streamUrl) return res.status(400).json({ message: "Stream URL is required" });

    church.isLive = true;
    church.streamUrl = streamUrl;
    church.liveTitle = liveTitle || "Live Service";
    church.liveStartedAt = new Date();
    await church.save();

    // Broadcast via socket to all connected members
    const users = req.app.get("users") || {};
    const io = req.app.get("io");
    if (io) {
      church.members.forEach(memberId => {
        const socketId = users[memberId.toString()];
        if (socketId) {
          io.to(socketId).emit("church_live", {
            churchId: church._id,
            churchName: church.name,
            streamUrl,
            liveTitle: church.liveTitle,
          });
        }
      });
    }

    // Persistent notification
    if (church.members.length > 0) {
      const notifs = church.members.map(memberId => ({
        user: memberId,
        fromUser: req.user.id,
        church: church._id,
        type: "announcement",
        title: `🔴 ${church.name} is LIVE`,
        message: church.liveTitle,
      }));
      await Notification.insertMany(notifs);
    }

    res.json({ message: "Live started", church });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── DELETE /api/church/:id/go-live — pastor ends live session ─────────────────
router.delete("/:id/go-live", protect, async (req, res) => {
  try {
    const church = await verifyPastor(req.params.id, req.user.id);
    if (!church) return res.status(403).json({ message: "Not authorized" });

    church.isLive = false;
    church.streamUrl = "";
    church.liveStartedAt = null;
    await church.save();

    const io = req.app.get("io");
    if (io) {
      io.emit("church_live_ended", { churchId: church._id });
    }

    res.json({ message: "Live ended" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── GET /api/church/:id/live-status ──────────────────────────────────────────
router.get("/:id/live-status", protect, async (req, res) => {
  try {
    const church = await Church.findById(req.params.id).select("isLive streamUrl liveTitle liveStartedAt name");
    if (!church) return res.status(404).json({ message: "Church not found" });
    res.json({
      isLive: church.isLive,
      streamUrl: church.streamUrl,
      liveTitle: church.liveTitle,
      liveStartedAt: church.liveStartedAt,
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// ── POST /api/church/:id/join — direct join (kept for legacy) ────────────────
router.post("/:id/join", protect, async (req, res) => {
  try {
    const church = await Church.findById(req.params.id);
    if (!church) return res.status(404).json({ message: "Church not found" });

    if (!church.members.includes(req.user.id)) {
      church.members.push(req.user.id);
      if (!church.memberRoles.some(r => r.user.toString() === req.user.id))
        church.memberRoles.push({ user: req.user.id, role: "member" });
      await church.save();
    }
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

    church.members = church.members.filter(uid => uid.toString() !== req.user.id);
    church.memberRoles = church.memberRoles.filter(r => r.user.toString() !== req.user.id);
    await church.save();

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
