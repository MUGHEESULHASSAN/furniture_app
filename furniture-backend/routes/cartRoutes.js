// routes/cartRoutes.js
const express = require("express");
const CartItem = require("../models/Cart"); // your Cart model
const { protect } = require("../middleware/auth"); // JWT auth middleware
const router = express.Router();

// Add item to cart
// Add item to cart
router.post("/", protect, async (req, res) => {
  const { productId, quantity } = req.body;

  try {
    let cartItem = await CartItem.findOne({ user: req.user._id, product: productId });

    if (cartItem) {
      // If item already exists, update quantity
      cartItem.quantity += quantity || 1;
      await cartItem.save();
    } else {
      // Otherwise create new
      cartItem = new CartItem({
        user: req.user._id,
        product: productId,
        quantity: quantity || 1,
      });
      await cartItem.save();
    }

    // ✅ Populate the product before sending
    cartItem = await cartItem.populate("product");

    res.status(200).json(cartItem);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});


// Get all items in cart
router.get("/", protect, async (req, res) => {
  try {
    const cart = await CartItem.find({ user: req.user._id }).populate("product");
    res.status(200).json(cart);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Update cart item quantity
router.put("/:id", protect, async (req, res) => {
  const { quantity } = req.body;

  try {
    const cartItem = await CartItem.findOneAndUpdate(
      { _id: req.params.id, user: req.user._id },
      { quantity },
      { new: true }
    );

    if (!cartItem) {
      return res.status(404).json({ message: "Cart item not found" });
    }

    res.status(200).json(cartItem);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Remove single item
router.delete("/:id", protect, async (req, res) => {
  try {
    const deletedItem = await CartItem.findOneAndDelete({
      _id: req.params.id,
      user: req.user._id,
    });

    if (!deletedItem) {
      return res.status(404).json({ message: "Cart item not found" });
    }

    res.status(200).json({ message: "Item removed from cart" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Clear entire cart
router.delete("/", protect, async (req, res) => {
  try {
    await CartItem.deleteMany({ user: req.user._id });
    res.status(200).json({ message: "Cart cleared" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
