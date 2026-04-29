const mongoose = require("mongoose");

const parentIDSchema = new mongoose.Schema(
  {
    parent:          { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true, unique: true },
    status:          { type: String, enum: ["pending", "verified", "rejected"], default: "pending" },
    idFileUrl:       { type: String, required: true },
    verifiedAt:      { type: Date, default: null },
    rejectionReason: { type: String, default: null },
  },
  { timestamps: true }
);

module.exports = mongoose.model("ParentIDVerification", parentIDSchema);
