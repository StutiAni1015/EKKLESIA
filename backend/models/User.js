const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    bio: { type: String, default: "" },
    country: { type: String, default: "" },
    countryIso: { type: String, default: "" },
    city: { type: String, default: "" },
    currency: { type: String, default: "USD" },
    currencySymbol: { type: String, default: "$" },
    // Church the user has joined (as a member)
    joinedChurch: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Church",
      default: null,
    },
    // True when this user is also a pastor who created a church
    isPastor: { type: Boolean, default: false },
    // Identity verification flags
    emailVerified: { type: Boolean, default: false },
    phoneVerified: { type: Boolean, default: false },
    faceVerified:  { type: Boolean, default: false },
    avatarUrl: { type: String, default: "" },
    // Pastor certification document
    certificationUrl:       { type: String, default: null },
    certificationInstitute: { type: String, default: "" },
    // 'none' | 'pending' | 'verified'
    certificationStatus:    { type: String, default: "none" },
    privacy: {
      showInDirectory:    { type: Boolean, default: true },
      allowPrayerTags:    { type: Boolean, default: true },
      publicProfile:      { type: Boolean, default: true },
      showChurchMembership: { type: Boolean, default: true },
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("User", userSchema);
