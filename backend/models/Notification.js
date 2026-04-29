const mongoose = require("mongoose");

const notificationSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User"
    },
    fromUser: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User"
    },
    church: { type: mongoose.Schema.Types.ObjectId, ref: "Church" },
    type: {
      type: String,
      enum: ["like", "comment", "announcement", "join_request", "join_approved", "join_rejected", "event"],
    },
    title: { type: String, default: "" },
    prayer: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Prayer"
    },
    message: { type: String, default: "" },
    read: {
      type: Boolean,
      default: false
    }
  },
  { timestamps: true }
);

module.exports = mongoose.model("Notification", notificationSchema);
