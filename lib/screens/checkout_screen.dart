import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

import '../models/credit_card_model.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import 'order_confirmation_screen.dart';
import 'credit_card_form.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<CreditCardModel> savedCards = [];
  bool _isSameAsShippingAddress = false;
  String _paymentMethod = 'COD';
  String _dropdownValue = 'Existing Card';
  CreditCardModel? selectedCard;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController shippingAddressController =
      TextEditingController();
  final TextEditingController billingAddressController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
        savedCards =
            raw
                .map<CreditCardModel>(
                  (e) => CreditCardModel.fromJson(
                    Map<String, dynamic>.from(e as Map),
                  ),
                )
                .toList();
      });
    }
  }

  Future<void> _saveNewCard(CreditCardModel card) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedCards.add(card);
      selectedCard = card;
      _dropdownValue = 'Existing Card';
    });

    final List<Map<String, dynamic>> toStore =
        savedCards.map((c) => c.toJson()).toList();
    await prefs.setString('cards', json.encode(toStore));
  }

  Future<void> _placeOrder(BuildContext context) async {
    final orderProvider = context.read<OrderProvider>();
    final auth = context.read<AuthProvider>();
    print("DEBUG token: ${auth.token}");
    print("DEBUG userId: ${auth.userId}");

    if (auth.token == null || auth.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must be logged in to place an order"),
        ),
      );
      return;
    }

    // ✅ Create order with proper OrderItem type
    final order = OrderModel(
      userId: auth.userId!,
      name: fullNameController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: shippingAddressController.text,
      paymentMethod: _paymentMethod,
      totalPrice: orderProvider.totalPrice,
      items: orderProvider.items, // Already a List<OrderItem>
    );

    final success = await orderProvider.placeOrder(order, auth);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrderConfirmationScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(orderProvider.errorMessage ?? "Order failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: const Color.fromARGB(217, 214, 191, 175),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- Personal Info ----------------
              const Text(
                "Personal Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInputField("Full Name", fullNameController, (v) {
                if (v == null || v.isEmpty) return 'Enter full name';
                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(v))
                  return 'Invalid name';
                return null;
              }),
              _buildInputField("Email Address", emailController, (v) {
                if (v == null || v.isEmpty) return 'Enter email';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v))
                  return 'Invalid email';
                return null;
              }),
              _buildInputField("Phone Number", phoneController, (v) {
                if (v == null || v.isEmpty) return 'Enter phone number';
                if (!RegExp(r'^\+44\d{10}$').hasMatch(v) &&
                    !RegExp(r'^07\d{9}$').hasMatch(v))
                  return 'Enter valid UK number';
                return null;
              }),
              const SizedBox(height: 25),

              // ---------------- Shipping ----------------
              const Text(
                "Shipping Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildInputField(
                "Shipping Address",
                shippingAddressController,
                (v) => v == null || v.isEmpty ? 'Enter shipping address' : null,
              ),
              const SizedBox(height: 25),

              // ---------------- Billing ----------------
              const Text(
                "Billing Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildInputField(
                "Billing Address",
                billingAddressController,
                (v) => v == null || v.isEmpty ? 'Enter billing address' : null,
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isSameAsShippingAddress,
                    onChanged: (value) {
                      setState(() {
                        _isSameAsShippingAddress = value ?? false;
                        if (_isSameAsShippingAddress) {
                          billingAddressController.text =
                              shippingAddressController.text;
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

              // ---------------- Payment ----------------
              const Text(
                "Payment Method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Radio<String>(
                    value: 'COD',
                    groupValue: _paymentMethod,
                    onChanged: (v) => setState(() => _paymentMethod = v!),
                  ),
                  const Text("Cash on Delivery"),
                  Radio<String>(
                    value: 'CreditCard',
                    groupValue: _paymentMethod,
                    onChanged: (v) => setState(() => _paymentMethod = v!),
                  ),
                  const Text("Credit Card"),
                ],
              ),

              if (_paymentMethod == 'CreditCard') ...[
                const SizedBox(height: 15),
                const Text(
                  "Choose Card Type",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _dropdownValue,
                  onChanged:
                      (String? newValue) =>
                          setState(() => _dropdownValue = newValue!),
                  items:
                      ['Existing Card', 'New Card']
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                ),
                if (_dropdownValue == 'Existing Card')
                  ListView.builder(
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
                        onTap: () => setState(() => selectedCard = card),
                      );
                    },
                  ),
                if (_dropdownValue == 'New Card')
                  IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.black,
                    onPressed: () async {
                      final CreditCardModel? newCard = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => CreditCardForm(
                                onSave: (newCard) {
                                  _saveNewCard(newCard);
                                  Navigator.pop(context, newCard);
                                },
                              ),
                        ),
                      );
                      if (newCard != null) {
                        setState(() {
                          savedCards.add(newCard);
                          _dropdownValue = 'Existing Card';
                        });
                      }
                    },
                  ),
              ],

              // ---------------- Confirm Button ----------------
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(217, 214, 191, 175),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed:
                        orderProvider.isLoading
                            ? null
                            : () {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (_paymentMethod == 'CreditCard' &&
                                    selectedCard == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Please select a credit card",
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                _placeOrder(context);
                              }
                            },
                    child:
                        orderProvider.isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              "Confirm Order",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
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

  Widget _buildInputField(
    String hint,
    TextEditingController controller,
    String? Function(String?)? validator,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: validator,
      ),
    );
  }
}
