import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/credit_card_model.dart';

// Credit Card Number Formatter
class CreditCardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'\s+'), '');  // Remove spaces

    // Add space after every 4 digits
    StringBuffer formattedText = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      formattedText.write(newText[i]);
      if ((i + 1) % 4 == 0 && i + 1 != newText.length) {
        formattedText.write(' ');
      }
    }

    return TextEditingValue(
      text: formattedText.toString(),
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

// Valid Date (MM/YY) Formatter
class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    if (newText.length == 2 && !newText.contains('/')) {
      newText = '$newText/';
    }
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class CreditCardForm extends StatefulWidget {
  final CreditCardModel? card;
  final Function(CreditCardModel) onSave;
  const CreditCardForm({super.key, this.card,required this.onSave});

  @override
  _CreditCardFormState createState() => _CreditCardFormState();
}

class _CreditCardFormState extends State<CreditCardForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _numberController;
  late TextEditingController _validFromController;
  late TextEditingController _validTillController;
  late TextEditingController _nameController;
  late TextEditingController _cvvController;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.card?.cardNumber ?? '');
    _validFromController = TextEditingController(text: widget.card?.validFrom ?? '');
    _validTillController = TextEditingController(text: widget.card?.validTill ?? '');
    _nameController = TextEditingController(text: widget.card?.cardHolderName ?? '');
    _cvvController = TextEditingController(text: widget.card?.cvv ?? '');
  }

  bool _isValidCardNumber(String cardNumber) {
    cardNumber = cardNumber.replaceAll(' ', '');
    return RegExp(r'^\d{16}$').hasMatch(cardNumber); // Example: Must be 16 digits
  }

  bool _isValidDate(String date) {
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(date)) return false;
    int month = int.parse(date.split('/')[0]);
    int year = int.parse("20${date.split('/')[1]}");
    if (month < 1 || month > 12) return false;
    return true;
  }

  bool _isValidTillDate(String validFrom, String validTill) {
    if (!_isValidDate(validFrom) || !_isValidDate(validTill)) return false;

    int fromMonth = int.parse(validFrom.split('/')[0]);
    int fromYear = int.parse("20${validFrom.split('/')[1]}");
    int tillMonth = int.parse(validTill.split('/')[0]);
    int tillYear = int.parse("20${validTill.split('/')[1]}");

    DateTime fromDate = DateTime(fromYear, fromMonth);
    DateTime tillDate = DateTime(tillYear, tillMonth);
    DateTime now = DateTime.now();

    return fromDate.isBefore(tillDate) && tillDate.isAfter(now);
  }

  bool _isValidCVV(String cvv) {
    return RegExp(r'^\d{3,4}$').hasMatch(cvv);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.card == null ? "Add Card" : "Edit Card",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(217, 214, 191, 175),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Card Holder Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Card Holder Name",
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(217, 214, 191, 175), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(217, 214, 191, 175), width: 1),
                      ),
                    ),
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter card holder name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Card Number
                  TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Card Number",
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(217, 214, 191, 175), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(217, 214, 191, 175), width: 1),
                      ),
                    ),
                    cursorColor: Colors.black,
                    inputFormatters: [CreditCardNumberFormatter()],
                    validator: (value) {
                      if (value == null || !_isValidCardNumber(value)) {
                        return "Invalid card number";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Valid From
                  TextFormField(
                    controller: _validFromController,
                    decoration: InputDecoration(
                      labelText: "Valid From (MM/YY)",
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(217, 214, 191, 175), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(217, 214, 191, 175), width: 1),
                      ),
                    ),
                    cursorColor: Colors.black,
                    inputFormatters: [DateFormatter()],
                    validator: (value) {
                      if (value == null || !_isValidDate(value)) {
                        return "Invalid valid-from date";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Valid Till
                  TextFormField(
                    controller: _validTillController,
                    decoration: InputDecoration(
                      labelText: "Valid Till (MM/YY)",
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(217, 214, 191, 175), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(217, 214, 191, 175), width: 1),
                      ),
                    ),
                    cursorColor: Colors.black,
                    inputFormatters: [DateFormatter()],
                    validator: (value) {
                      if (value == null ||
                          !_isValidDate(value) ||
                          !_isValidTillDate(_validFromController.text, value)) {
                        return "Invalid or expired valid-till date";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // CVV
                  TextFormField(
                    controller: _cvvController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "CVV",
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(217, 214, 191, 175), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(217, 214, 191, 175), width: 1),
                      ),
                    ),
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value == null || !_isValidCVV(value)) {
                        return "Invalid CVV";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Save Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(217, 214, 191, 175),
                    ),
                    child: Text("Save", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        CreditCardModel newCard = CreditCardModel(
                          cardNumber: _numberController.text,
                          cardHolderName: _nameController.text,
                          cvv: _cvvController.text,
                          validFrom: _validFromController.text,
                          validTill: _validTillController.text,
                        );
                        // Pass the new card back to the CheckoutScreen and close the form
                        Navigator.pop(context, newCard);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
