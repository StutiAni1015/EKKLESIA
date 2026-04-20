const mongoose = require("mongoose");

const commentSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    text: { type: String, required: true },
  },
  { timestamps: true }
);

const prayerSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    title: { type: String, default: "" },
    content: { type: String, required: true },
    category: {
      type: String,
      enum: ["Health", "Family", "Guidance", "Provision", "Community", "Praise", "Other"],
      default: "Other",
    },
    isAnonymous: { type: Boolean, default: false },
    isAnswered: { type: Boolean, default: false },
    // Community scope: "church" = visible to joined church; "global" = global prayer map
    scope: {
      type: String,
      enum: ["personal", "church", "global"],
      default: "personal",
    },
    likes: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
    comments: [commentSchema],
  },
  { timestamps: true }
);

module.exports = mongoose.model("Prayer", prayerSchema);
