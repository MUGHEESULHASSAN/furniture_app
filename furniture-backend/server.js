const express = require('express');
const dotenv = require('dotenv');
const mongoose = require('mongoose');
const productRoutes = require('./routes/product.js');

// Load environment variables from .env file
dotenv.config();

// MongoDB connection
const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('MongoDB connected successfully');
  } catch (error) {
    console.error('MongoDB connection error:', error.message);
    process.exit(1); // Exit the process if connection fails
  }
};

// Initialize Express
const app = express();

// Middleware (if any)
app.use(express.json());

// Test route
app.get('/', (req, res) => {
  res.send('Server is running');
});

// Use product routes
app.use('/api/products', productRoutes);

// Test route
app.get('/', (req, res) => {
  res.send('Furniture API is running');
});
// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server started on port ${PORT}`);
  connectDB(); // Connect to MongoDB after server starts
});
