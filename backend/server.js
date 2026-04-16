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
app.use("/api/church", require("./routes/churchRoutes"));

// 🔐 Protected route
const protect = require("./middleware/authMiddleware");

app.get("/api/protected", protect, (req, res) => {
  res.json({
    message: "You accessed protected route!",
    user: req.user
  });
});

// 🚀 Start server
const http = require("http");
const { Server } = require("socket.io");

const server = http.createServer(app);

const io = new Server(server, {
  cors: { origin: "*" }
});

// 🔐 store users
const users = {};

io.on("connection", (socket) => {
  console.log("User connected:", socket.id);

  // user registers
  socket.on("register", (userId) => {
    users[userId] = socket.id;
    console.log("Registered:", userId);
  });

  socket.on("disconnect", () => {
    for (let userId in users) {
      if (users[userId] === socket.id) {
        delete users[userId];
      }
    }
  });
});

// make available in routes
app.set("io", io);
app.set("users", users);

// start server
server.listen(4000, "0.0.0.0", () => {
  console.log("Server running on port 4000");
});
