const mongoose = require("mongoose");

const connectDB = async () => {
  console.log("Connecting to MongoDB...");

  try {
    await mongoose.connect("mongodb://127.0.0.1:27017/ekklesia");

    console.log("MongoDB Connected ✅");
  } catch (error) {
    console.error("DB ERROR:", error.message);
    process.exit(1);
  }
};

module.exports = connectDB;