const mongoose = require("mongoose");

const churchMediaSchema = new mongoose.Schema(
  {
    church: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Church",
      required: true,
    },
    uploadedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    uploaderName: { type: String, default: "" },
    uploaderRole: { type: String, default: "member" },
    title: { type: String, required: true },
    fileName: { type: String, required: true },   // original filename
    fileUrl: { type: String, required: true },     // served URL path
    fileType: {
      type: String,
      enum: ["pdf", "image", "ppt", "other"],
      default: "other",
    },
    fileSize: { type: Number, default: 0 },        // bytes
    isLyrics: { type: Boolean, default: false },   // worship leader promoted to Lyrics tab
  },
  { timestamps: true }
);

module.exports = mongoose.model("ChurchMedia", churchMediaSchema);
