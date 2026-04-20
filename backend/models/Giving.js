const mongoose = require("mongoose");

const givingSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    // Optional: giving tied to a church
    church: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Church",
      default: null,
    },
    title: { type: String, required: true }, // e.g. "Tithe", "Building Fund"
    amount: { type: Number, required: true },
    currency: { type: String, default: "USD" },
    currencySymbol: { type: String, default: "$" },
    note: { type: String, default: "" },
    // "tithe" | "offering" | "building" | "missions" | "other"
    category: {
      type: String,
      enum: ["tithe", "offering", "building", "missions", "other"],
      default: "other",
    },
    givenAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Giving", givingSchema);
