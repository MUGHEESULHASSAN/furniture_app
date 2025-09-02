const express = require('express');
const dotenv = require('dotenv');
const mongoose = require('mongoose');
const cors = require('cors');

const productRoutes = require('./routes/product.js');
const userRoutes = require('./routes/users.js');
const orderRoutes = require('./routes/order.js');
const creditCardRoutes = require('./routes/CreditCard.js');
const cartRoutes = require("./routes/cartRoutes.js");

// Load environment variables
dotenv.config();

if (!process.env.JWT_SECRET) {
  console.error('JWT_SECRET is not set in the .env file!');
  process.exit(1);
}
if (!process.env.MONGODB_URI) {
  console.error('MONGODB_URI is not set in the .env file!');
  process.exit(1);
}

const app = express();

// ---- Middleware ----
app.use(
  cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
  })
);
app.use(express.json({ limit: '1mb' }));
app.use(express.urlencoded({ extended: true }));

// ---- Routes ----
app.use('/api/products', productRoutes);
app.use('/api/users', userRoutes); // includes /register and /login
app.use('/api/orders', orderRoutes);
app.use('/api/creditcards', creditCardRoutes);
app.use("/api/cart", cartRoutes);

// Health check
app.get('/', (_req, res) => res.send('Server is running'));
app.get('/test', (_req, res) => res.send('Furniture API is running'));

// 404 handler for unknown routes
app.use((req, res, next) => {
  res.status(404).json({ message: `Route not found: ${req.originalUrl}` });
});

// Global error handler
app.use((err, req, res, _next) => {
  console.error('Unhandled error:', err);
  const status = err.status || 500;
  res.status(status).json({
    message: err.message || 'Internal Server Error',
    ...(process.env.NODE_ENV !== 'production' && { stack: err.stack }),
  });
});

// ---- Start server AFTER DB connects ----
const PORT = process.env.PORT || 5000;

(async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      // useNewUrlParser/useUnifiedTopology are default on modern Mongoose, safe to omit
    });
    console.log('MongoDB connected successfully');

    app.listen(PORT, () => {
      console.log(`Server started on port ${PORT}`);
    });
  } catch (error) {
    console.error('MongoDB connection error:', error.message);
    process.exit(1);
  }
})();
