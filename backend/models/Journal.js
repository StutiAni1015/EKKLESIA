const mongoose = require("mongoose");

const journalSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User"
  },
  title: String,
  content: String,
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// 🔥 THIS LINE IS VERY IMPORTANT
module.exports = mongoose.model("Journal", journalSchema);
