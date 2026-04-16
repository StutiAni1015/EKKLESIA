const express = require("express");
const router = express.Router();

const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const User = require("../models/User"); //only once 

// 🔐 Signup

router.post("/signup", async (req, res) => {
  const { name, email, password } = req.body;

  // check if user already exists
  const userExists = await User.findOne({ email });

  if (userExists) {
    return res.status(400).json({ message: "User already exists" });
  }

  // hash password
  const hashedPassword = await bcrypt.hash(password, 10);

  // save user in database
  const user = await User.create({
    name,
    email,
    password: hashedPassword
  });

  res.json({
    message: "User registered successfully",
    user: {
      id: user.id,
      name: user.name,
      email: user.email
    }
  });
});

// 🔐 Login
router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email }); // ✅ fixed

  if (!user) {
    return res.status(400).json({ message: "User not found" });
  }

  const isMatch = await bcrypt.compare(password, user.password);

  if (!isMatch) {
    return res.status(400).json({ message: "Invalid password" });
  }

const token = jwt.sign({ id: user.id }, "secretkey", {
   expiresIn: "1d"
  });

  res.json({
    message: "Login successful",
    token,
    userId: user.id,
    name: user.name
  });
});

module.exports = router;

console.log("User:", User);