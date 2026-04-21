const mongoose = require("mongoose");

const churchLyricsSchema = new mongoose.Schema(
  {
    church:        { type: mongoose.Schema.Types.ObjectId, ref: "Church", required: true },
    submittedBy:   { type: mongoose.Schema.Types.ObjectId, ref: "User",   required: true },
    submitterName: { type: String, default: "" },
    submitterRole: { type: String, default: "member" },

    title:         { type: String, required: true },
    artist:        { type: String, default: "" },         // song author / artist

    // Either plain text OR a reference to an uploaded ChurchMedia file
    contentType:   { type: String, enum: ["text", "file"], default: "text" },
    textContent:   { type: String, default: "" },         // plain-text lyrics
    mediaRef:      { type: mongoose.Schema.Types.ObjectId, ref: "ChurchMedia", default: null },
    mediaFileUrl:  { type: String, default: "" },         // cached URL for file-based lyrics
    mediaFileType: { type: String, default: "" },         // pdf | image | ppt

    isApproved:    { type: Boolean, default: false },
    approvedBy:    { type: mongoose.Schema.Types.ObjectId, ref: "User", default: null },
  },
  { timestamps: true }
);

module.exports = mongoose.model("ChurchLyrics", churchLyricsSchema);
