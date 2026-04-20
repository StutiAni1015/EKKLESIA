const mongoose = require("mongoose");

// A GlobalPrayer is a prayer "lit" on the world map.
// Privacy rule: only countryIso is stored, never exact coordinates.
const globalPrayerSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null, // null when isAnonymous
    },
    title: { type: String, required: true },
    body: { type: String, required: true },
    category: {
      type: String,
      enum: ["Health", "Family", "Guidance", "Provision", "Community", "Praise", "Other"],
      default: "Other",
    },
    location: { type: String, default: "" }, // display string e.g. "Lagos, Nigeria"
    countryIso: { type: String, default: "" }, // ISO 3166-1 alpha-2
    countryName: { type: String, default: "" },
    isAnonymous: { type: Boolean, default: false },
    // Users who have prayed for this request
    prayedBy: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
  },
  { timestamps: true }
);

module.exports = mongoose.model("GlobalPrayer", globalPrayerSchema);
