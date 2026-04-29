const mongoose = require("mongoose");

// ── Sub-schemas ───────────────────────────────────────────────────────────────

const joinRequestSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  name: { type: String, default: "" },
  status: {
    type: String,
    enum: ["pending", "approved", "rejected"],
    default: "pending",
  },
  createdAt: { type: Date, default: Date.now },
});

const memberRoleSchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  role: {
    type: String,
    enum: ["member", "secretary", "treasurer", "committee", "worship_leader", "media_team", "choir"],
    default: "member",
  },
});

const churchEventSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String, default: "" },
  date: { type: Date, required: true },
  location: { type: String, default: "" },
  createdAt: { type: Date, default: Date.now },
});

// ── Main schema ───────────────────────────────────────────────────────────────

const churchSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    denomination: { type: String, default: "" },
    address: { type: String, default: "" },
    city: { type: String, default: "" },
    country: { type: String, default: "" },
    phone: { type: String, default: "" },
    email: { type: String, default: "" },
    website: { type: String, default: "" },
    youtube: { type: String, default: "" },
    instagram: { type: String, default: "" },
    allowTestimonies: { type: Boolean, default: true },
    pastor: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    members: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
    memberRoles: [memberRoleSchema],
    joinRequests: [joinRequestSchema],
    events: [churchEventSchema],
    lat: { type: Number, default: null },
    lng: { type: Number, default: null },
    status: {
      type: String,
      enum: ["pending", "approved"],
      default: "approved",
    },
    // Live session
    isLive: { type: Boolean, default: false },
    streamUrl: { type: String, default: "" },
    liveTitle: { type: String, default: "" },
    liveStartedAt: { type: Date, default: null },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Church", churchSchema);
