const express = require('express');
const CreditCard = require('../models/Card');
const router = express.Router();

// Store tokenized credit card information
router.post('/store', async (req, res) => {
  const { userId, cardToken } = req.body; // `cardToken` should be provided by a payment processor like Stripe

  const newCard = new CreditCard({
    userId,
    cardToken,
  });

  try {
    await newCard.save();
    res.status(200).json({ message: 'Credit card information stored successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Retrieve stored credit card information (for reference, never store actual card details)
router.get('/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    const creditCard = await CreditCard.findOne({ userId });
    if (!creditCard) {
      return res.status(404).json({ message: 'No credit card information found' });
    }
    res.status(200).json(creditCard);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
