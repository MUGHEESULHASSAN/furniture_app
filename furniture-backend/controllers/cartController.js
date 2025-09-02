// controllers/cartController.js

const CartItem = require("../models/Cart");

// Add product to cart
exports.addToCart = async (req, res) => {
  try {
    const { productId, quantity } = req.body;
    const userId = req.user.id; // coming from JWT auth middleware

    // check if product already in cart
    let item = await CartItem.findOne({ user: userId, product: productId });

    if (item) {
      item.quantity += quantity;
      await item.save();
    } else {
      item = await CartItem.create({ user: userId, product: productId, quantity });
    }

    res.status(201).json(item);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get all items in user’s cart
exports.getCart = async (req, res) => {
  try {
    const userId = req.user.id;
    const items = await CartItem.find({ user: userId }).populate("product");
    res.json(items);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update quantity
exports.updateCartItem = async (req, res) => {
  try {
    const { id } = req.params;
    const { quantity } = req.body;
    const item = await CartItem.findByIdAndUpdate(id, { quantity }, { new: true });
    res.json(item);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Remove single item
exports.removeCartItem = async (req, res) => {
  try {
    const { id } = req.params;
    await CartItem.findByIdAndDelete(id);
    res.json({ message: "Item removed" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Clear entire cart
exports.clearCart = async (req, res) => {
  try {
    const userId = req.user.id;
    await CartItem.deleteMany({ user: userId });
    res.json({ message: "Cart cleared" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
