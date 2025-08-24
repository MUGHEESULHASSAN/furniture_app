const mongoose = require('mongoose');

const CreditCardSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }, // Reference to the User model
  cardToken: { type: String, required: true }, // A token from a payment gateway like Stripe
}, { timestamps: true });

module.exports = mongoose.model('CreditCard', CreditCardSchema);
