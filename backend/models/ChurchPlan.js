const mongoose = require("mongoose");

const daySchema = new mongoose.Schema({
  dayNumber:  { type: Number, required: true },
  title:      { type: String, default: "" },       // e.g. "The Beatitudes"
  scripture:  { type: String, required: true },    // e.g. "Matthew 5:1-12"
  reflection: { type: String, default: "" },       // optional pastor note
}, { _id: false });

const churchPlanSchema = new mongoose.Schema({
  church:      { type: mongoose.Schema.Types.ObjectId, ref: "Church", required: true },
  createdBy:   { type: mongoose.Schema.Types.ObjectId, ref: "User",   required: true },
  title:       { type: String, required: true },
  description: { type: String, default: "" },
  startDate:   { type: Date, default: Date.now },
  days:        [daySchema],
  isActive:    { type: Boolean, default: true },
}, { timestamps: true });

// Only one active plan per church
churchPlanSchema.index({ church: 1, isActive: 1 });

module.exports = mongoose.model("ChurchPlan", churchPlanSchema);
