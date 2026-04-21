const mongoose = require("mongoose");

const churchPostSchema = new mongoose.Schema(
  {
    church: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Church",
      required: true,
    },
    author: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    authorName: { type: String, default: "" },
    content: { type: String, required: true },
    // pending → awaiting pastor review
    // approved → visible in church timeline
    // rejected → hidden (soft delete)
    status: {
      type: String,
      enum: ["pending", "approved", "rejected"],
      default: "pending",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("ChurchPost", churchPostSchema);
