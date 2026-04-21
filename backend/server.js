const express = require("express");
const http    = require("http");
const path    = require("path");
const { Server } = require("socket.io");

const app    = express();
const server = http.createServer(app);
const io     = new Server(server, { cors: { origin: "*" } });

// DB connection
const connectDB = require("./config/db");
connectDB();

// Middleware
app.use(express.json());

// Serve uploaded files (church media)
app.use("/uploads", express.static(path.join(__dirname, "uploads")));

// Track connected users: userId → socketId
const users = {};
app.set("io", io);
app.set("users", users);

// Socket.IO
io.on("connection", (socket) => {
  socket.on("register", (userId) => {
    users[userId] = socket.id;
  });

  socket.on("disconnect", () => {
    for (const [uid, sid] of Object.entries(users)) {
      if (sid === socket.id) { delete users[uid]; break; }
    }
  });
});

// Health check
app.get("/", (req, res) => res.send("API running..."));

// Routes
app.use("/api/auth",          require("./routes/authRoutes"));
app.use("/api/prayer",        require("./routes/prayerRoutes"));
app.use("/api/journal",       require("./routes/journalRoutes"));
app.use("/api/notifications", require("./routes/notificationRoutes"));
app.use("/api/church",        require("./routes/churchRoutes"));
app.use("/api/church-posts",  require("./routes/churchPostRoutes"));
app.use("/api/church-media",  require("./routes/churchMediaRoutes"));
app.use("/api/church-plan",   require("./routes/churchPlanRoutes"));
app.use("/api/church-lyrics", require("./routes/churchLyricsRoutes"));
app.use("/api/global-prayer", require("./routes/globalPrayerRoutes"));
app.use("/api/giving",        require("./routes/givingRoutes"));
app.use("/api/user",          require("./routes/userRoutes"));

// Protected test route
const protect = require("./middleware/authMiddleware");
app.get("/api/protected", protect, (req, res) => {
  res.json({ message: "You accessed protected route!", user: req.user });
});

const PORT = process.env.PORT || 4000;
server.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
