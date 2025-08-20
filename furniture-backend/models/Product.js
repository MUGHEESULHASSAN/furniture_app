const mongoose = require('mongoose');

const ProductSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  price: { type: Number, required: true },
  category: { type: String, required: true },
  image: { type: String },  // URL or base64 encoded image string
}, {
  timestamps: true
});

module.exports = mongoose.model('Product', ProductSchema);
