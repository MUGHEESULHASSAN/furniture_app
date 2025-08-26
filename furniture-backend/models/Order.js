// models/Order.js
const mongoose = require("mongoose");
 const orderItemSchema = new mongoose.Schema({
  productId: { type: mongoose.Schema.Types.ObjectId, ref: "Product", required: true }, // 👈 expects ObjectId
  name: { type: String, required: true },
  price: { type: Number, required: true },
  quantity: { type: Number, required: true }
});
const orderSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required:true
  },
  name: String,
  email: String,
  phone: String,
  address: String,
  paymentMethod: String,
  totalPrice: Number,
  items: [orderItemSchema],
  status: {
    type: String,
    default: "Pending"
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model("Order", orderSchema);
