const mongoose = require("mongoose");

const churchPlanProgressSchema = new mongoose.Schema({
  plan:          { type: mongoose.Schema.Types.ObjectId, ref: "ChurchPlan", required: true },
  church:        { type: mongoose.Schema.Types.ObjectId, ref: "Church",     required: true },
  user:          { type: mongoose.Schema.Types.ObjectId, ref: "User",       required: true },
  completedDays: [{ type: Number }],   // array of dayNumbers the user marked done
}, { timestamps: true });

churchPlanProgressSchema.index({ plan: 1, user: 1 }, { unique: true });

module.exports = mongoose.model("ChurchPlanProgress", churchPlanProgressSchema);
