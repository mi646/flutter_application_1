const express = require("express");
const { MongoClient } = require("mongodb");
const cors = require("cors");
const bodyParser = require("body-parser");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const app = express();
const PORT = 3001;
const MONGO_URI = "mongodb://localhost:27017";
const DB_NAME = "yourdollarstore";

app.use(cors());
app.use(bodyParser.json()); 

const mongoUri = 'mongodb+srv://mitesh:xaI3rt7PAQjPMhM0@cluster0.r41tu.mongodb.net/yourdollarstore?retryWrites=true&w=majority';

let db;
MongoClient.connect(mongoUri, { useNewUrlParser: true, useUnifiedTopology: true })
  .then((client) => {
    db = client.db('yourdollarstore');
    console.log('Connected to MongoDB');
  })
  .catch((err) => console.error("MongoDB Connection Error:", err));

app.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: "Email and Password are required" });
    }

    const user = await db.collection('users').findOne({ email });

    if (!user) {
      return res.status(401).json({ message: "User not found" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: "Invalid credentials" });
    }

    const token = jwt.sign({ email: user.email }, 'yourSecretKey', { expiresIn: '1h' });

    res.status(200).json({
      message: "Login successful",
      token,
      user: { email: user.email }
    });
  } catch (error) {
    console.error("Login Error:", error);
    res.status(500).json({ message: "Server error" });
  }
});

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
