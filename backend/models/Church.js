const mongoose = require("mongoose");

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
    members: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
      },
    ],
    // 'pending' until an admin approves; set to 'approved' to appear in search
    // Optional coordinates for proximity search
    lat: { type: Number, default: null },
    lng: { type: Number, default: null },

    status: {
      type: String,
      enum: ["pending", "approved"],
      default: "approved", // auto-approve for now — add admin review later
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Church", churchSchema);
