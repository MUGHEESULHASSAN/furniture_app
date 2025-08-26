// controllers/orderController.js
const Order = require('../models/Order');
const User = require('../models/User');
const Product = require('../models/Product');

const createOrder = async (req, res) => {
  try {
    const userId = req.user.id; // ✅ set by auth middleware
    const { items } = req.body;

    // Debug log: show incoming request
    console.log("---- CREATE ORDER REQUEST ----");
    console.log("User ID from token:", userId);
    console.log("Items received in request:", items);

    // Fetch user details
    const user = await User.findById(userId).select("name email");
    console.log("User fetched from DB:", user);

    // Fetch product details
    const productIds = items.map(item => item.productId);
    const products = await Product.find({ _id: { $in: productIds } });
    console.log("Products fetched from DB:", products);

    // Create order
    const order = new Order({
      user: userId,
      items,
      status: "Pending"
    });

    await order.save();
    console.log("Order saved successfully:", order);

    res.status(201).json({ success: true, order });
  } catch (error) {
    console.error("Error creating order:", error);
    res.status(500).json({ success: false, message: "Error creating order" });
  }
};

module.exports = { createOrder };
