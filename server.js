// Import required libraries
const express = require('express');
const bodyParser = require('body-parser');
const { MongoClient } = require('mongodb');
const cors = require('cors');

// Initialize the Express app
const app = express();
const port = 3000; // You can change this port number

// Middleware
app.use(cors()); // Enable CORS for cross-origin requests (important for Flutter)
app.use(bodyParser.json()); // Parse incoming JSON requests

// MongoDB connection URI (replace with your own MongoDB URI)
const mongoUri = 'mongodb+srv://mitesh:xaI3rt7PAQjPMhM0@cluster0.r41tu.mongodb.net/yourdollarstore?retryWrites=true&w=majority';

// MongoDB client initialization
let db;
MongoClient.connect(mongoUri, { useNewUrlParser: true, useUnifiedTopology: true })
  .then((client) => {
    db = client.db('yourdollarstore'); // Connect to the correct DB
    console.log('Connected to MongoDB');
  })
  .catch((error) => console.error('Failed to connect to MongoDB:', error));

// POST request to handle user registration
app.post('/api/users', async (req, res) => {
  try {
    // Extract user data from the request body
    const { name, email, password } = req.body;

    // Validate that the necessary fields are provided
    if (!name || !email || !password) {
      return res.status(400).json({ message: 'Please provide name, email, and password.' });
    }

    // Insert the user data into the 'users' collection
    const usersCollection = db.collection('users');
    const result = await usersCollection.insertOne({ name, email, password });

    // Respond with success
    res.status(200).json({ message: 'User registered successfully!', userId: result.insertedId });
  } catch (error) {
    console.error('Error registering user:', error);
    res.status(500).json({ message: 'Error registering user', error: error.message });
  }
});

// Start the server and listen for incoming requests
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
