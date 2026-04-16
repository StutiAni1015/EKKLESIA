const express = require("express");
const app = express();

// 🔌 DB connection
const connectDB = require("./config/db");

// 🔥 Connect DB FIRST
connectDB();

// 🔐 Middleware
app.use(express.json());

// 🔹 Test route
app.get("/", (req, res) => {
  res.send("API running...");
});

// 🔹 Routes
app.use("/api/auth", require("./routes/authRoutes"));
app.use("/api/journal", require("./routes/journalRoutes"));
app.use("/api/prayer", require("./routes/prayerRoutes")); // 🔥 IMPORTANT
app.use("/api/notifications", require("./routes/notificationRoutes"));

// 🔐 Protected route
const protect = require("./middleware/authMiddleware");

app.get("/api/protected", protect, (req, res) => {
  res.json({
    message: "You accessed protected route!",
    user: req.user
  });
});

// 🚀 Start server
app.listen(4000, "0.0.0.0", () => {
  console.log("Server running on port 4000");
});
