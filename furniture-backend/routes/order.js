const express = require("express");
const mongoose = require("mongoose");
const Order = require("../models/Order");
const router = express.Router();

// Place order
router.post("/", async (req, res) => {
  console.log("🚀 New POST /orders request received");
  console.log("Headers:", req.headers);
  console.log("Raw body:", req.body);

  try {
    const {
      userId,
      name,
      email,
      phone,
      address,
      paymentMethod,
      totalPrice,
      items
    } = req.body || {};

    if (!req.body) {
      console.error("❌ req.body is undefined");
      return res.status(400).json({ error: "Request body is empty" });
    }

    // Validate userId
    if (!userId || !mongoose.Types.ObjectId.isValid(userId)) {
      console.error("❌ Invalid userId:", userId);
      return res.status(400).json({ error: "Invalid or missing userId" });
    }

    // Validate items
    if (!items || items.length === 0) {
      console.error("❌ No items provided in order");
      return res.status(400).json({ error: "No items in the order" });
    }

    // Validate each productId
    for (let item of items) {
      if (!item.productId || !mongoose.Types.ObjectId.isValid(item.productId)) {
        console.error("❌ Invalid productId:", item.productId);
        return res.status(400).json({ error: `Invalid productId: ${item.productId}` });
      }
    }

    // Build order
    const newOrder = new Order({
      userId: new mongoose.Types.ObjectId(userId),
      name,
      email,
      phone,
      address,
      paymentMethod,
      totalPrice,
      items: items.map((item) => ({
        productId: new mongoose.Types.ObjectId(item.productId),
        name: item.name,
        price: item.price,
        quantity: item.quantity
      }))
    });

    const savedOrder = await newOrder.save();
    console.log("✅ Order saved successfully:", savedOrder._id);

    res.status(201).json(savedOrder);
  } catch (error) {
    console.error("🔥 Order save error:", error);
    res.status(500).json({ error: "Server error while placing order" });
  }
});

module.exports = router;
