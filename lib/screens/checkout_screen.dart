import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/credit_card_model.dart';
import 'order_confirmation_screen.dart';
import 'credit_card_form.dart'; // Import CreditCardFormScreen

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<CreditCardModel> savedCards = [];
  bool _isSameAsShippingAddress = false;
  String _paymentMethod = 'COD'; // Default payment method is COD
  String _dropdownValue = 'Existing Card'; // Default dropdown value
  CreditCardModel? selectedCard; // Variable to store the selected card

  // Create separate controllers for each field
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController shippingAddressController = TextEditingController();
  final TextEditingController billingAddressController = TextEditingController();

  final _formKey = GlobalKey<FormState>(); // Add a form key for validation

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString('cards');
    if (cardsJson != null) {
      final List<dynamic> raw = json.decode(cardsJson);
      setState(() {
        savedCards = raw
            .map<CreditCardModel>((e) => CreditCardModel.fromJson(
          Map<String, dynamic>.from(e as Map),
        ))
            .toList();
      });
    }
  }

  Future<void> _saveNewCard(CreditCardModel card) async {
    final prefs = await SharedPreferences.getInstance();

    // Update UI immediately
    setState(() {
      savedCards.add(card);
      selectedCard = card;
      _dropdownValue = 'Existing Card'; // <-- ensures the list view is visible
    });

    // Persist as List<Map> (not list of strings)
    final List<Map<String, dynamic>> toStore = savedCards.map((c) => c.toJson()).toList();
    await prefs.setString('cards', json.encode(toStore));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: const Color.fromARGB(217, 214, 191, 175),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Attach the form key here
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Personal Information Section
              const Text(
                "Personal Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInputField("Full Name", fullNameController, (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name.';
                }
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                  return 'Please enter a valid name.';
                }
                return null;
              }),
              _buildInputField("Email Address", emailController, (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address.';
                }
                if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email address.';
                }
                return null;
              }),
              _buildInputField("Phone Number", phoneController, (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number.';
                }
                // Validate UK phone number
                if (!RegExp(r'^\+44\d{10}$').hasMatch(value) && !RegExp(r'^07\d{9}$').hasMatch(value)) {
                  return 'Please enter a valid UK phone number (e.g., 07123456789 or +447123456789).';
                }
                return null;
              }),

              const SizedBox(height: 25),

              // Shipping Address Section
              const Text(
                "Shipping Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInputField("Shipping Address", shippingAddressController, (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your shipping address.';
                }
                return null;
              }),

              const SizedBox(height: 25),

              // Billing Address Section
              const Text(
                "Billing Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInputField("Billing Address", billingAddressController, (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your billing address.';
                }
                return null;
              }),

              const SizedBox(height: 10),

              // Checkbox for Same as Shipping Address
              Row(
                children: [
                  Checkbox(
                    value: _isSameAsShippingAddress,
                    onChanged: (value) {
                      setState(() {
                        _isSameAsShippingAddress = value ?? false;
                        if (_isSameAsShippingAddress) {
                          billingAddressController.text = shippingAddressController.text;
                        } else {
                          billingAddressController.clear();
                        }
                      });
                    },
                  ),
                  const Text("Same as Shipping Address"),
                ],
              ),

              const SizedBox(height: 25),

              // Payment Method Section
              const Text(
                "Payment Method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Payment method options
              Row(
                children: [
                  Radio<String>(
                    value: 'COD',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                  ),
                  const Text("Cash on Delivery"),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: 'CreditCard',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                  ),
                  const Text("Credit Card"),
                ],
              ),
              const SizedBox(height: 25),

              // If Credit Card is selected, show card option dropdown
              if (_paymentMethod == 'CreditCard') ...[
                const Text(
                  "Choose Card Type",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _dropdownValue,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Existing Card', 'New Card']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 25),

                // Show existing card list when "Existing Card" is selected
                if (_dropdownValue == 'Existing Card') ...[
                  const Text(
                    "Saved Cards",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0), // Add padding below the list
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: savedCards.length,
                      itemBuilder: (context, index) {
                        final card = savedCards[index];
                        return ListTile(
                          title: Text(
                            "**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}",
                            style: const TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            "${card.cardHolderName} • Exp: ${card.validTill}",
                            style: const TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            setState(() {
                              selectedCard = card;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],

                // Show new card form when "New Card" is selected
                if (_dropdownValue == 'New Card') ...[
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.black),
                    onPressed: () async {
                      final CreditCardModel? newCard = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CreditCardForm(
                                onSave: (newCard) {
                                  _saveNewCard(newCard);           // updates UI + storage
                                  Navigator.pop(context, newCard);
                                },
                              ),
                        ),
                      );
                      // Ensure the UI updates after adding a new card
                      if (newCard != null) {
                        setState(() {
                          savedCards.add(newCard); // Add the new card to the list
                          _dropdownValue = 'Existing Card'; // Switch to "Existing Card" to show the list
                        });
                      }
                    },
                  ),
                ],
              ],

              // Checkout button
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(217, 214, 191, 175),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (_paymentMethod == 'CreditCard' && selectedCard != null) {
                          // Show a confirmation message using ScaffoldMessenger
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Amount deducted from card: ${selectedCard!.cardHolderName} - ${selectedCard!.cardNumber}"),
                              duration: const Duration(seconds: 3),
                            ),
                          );

                          // Proceed to the order confirmation screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderConfirmationScreen(),
                            ),
                          );
                        } else if (_paymentMethod == 'COD') {
                          // For Cash on Delivery, proceed directly to the order confirmation screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderConfirmationScreen(),
                            ),
                          );
                        } else {
                          // Show an error if no payment method is selected
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please select a payment method and a valid card.")),
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Confirm Order",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Input field for new card with validator
  Widget _buildInputField(String hint, TextEditingController controller, String? Function(String?)? validator) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color.fromARGB(217, 214, 191, 175), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color.fromARGB(217, 214, 191, 175), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color.fromARGB(217, 214, 191, 175), width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
