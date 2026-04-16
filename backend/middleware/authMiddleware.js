const jwt = require("jsonwebtoken");
const User = require("../models/User");

const protect = async (req, res, next) => {
  let token;

  if (req.headers.authorization && req.headers.authorization.startsWith("Bearer")) {
    try {
      // 🔥 Extract token
      token = req.headers.authorization.split(" ")[1];

      // 🔐 Verify token
      const decoded = jwt.verify(token, "secretkey");

      // 👤 Get user
      req.user = await User.findById(decoded.id).select("-password");

      next();
    } catch (error) {
      console.log("TOKEN ERROR:", error.message);
      res.status(401).json({ message: "Not authorized" });
    }
  } else {
    res.status(401).json({ message: "No token" });
  }
};

module.exports = protect;
