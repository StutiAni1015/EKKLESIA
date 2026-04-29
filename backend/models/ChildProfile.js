const mongoose = require("mongoose");

const childProfileSchema = new mongoose.Schema(
  {
    parent:        { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    name:          { type: String, required: true, trim: true },
    age:           { type: Number, required: true, min: 5, max: 18 },
    avatarEmoji:   { type: String, default: "🧒" },
    avatarColor:   { type: String, default: "#FF7947" },
    isActive:      { type: Boolean, default: true },
    // cumulative stats
    totalPoints:   { type: Number, default: 0 },
    prayerStreak:  { type: Number, default: 0 },
    readStreak:    { type: Number, default: 0 },
    lastActiveDate: { type: String, default: null }, // 'YYYY-MM-DD'
    badges:        [{ type: String }],               // 'seed' | 'fire' | 'crown'
    // parent controls
    gamesEnabled:  { type: Boolean, default: true },
    customReadingId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "KidsContent",
      default: null,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("ChildProfile", childProfileSchema);
