import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'credit_card_form.dart'; // Import CreditCardFormScreen
import '../models/credit_card_model.dart';

class CreditCardScreen extends StatefulWidget {
  final CreditCardModel? card; // Declare the card parameter
  const CreditCardScreen({Key? key, this.card}) : super(key: key); // Accept card in the constructor

  @override
  _CreditCardScreenState createState() => _CreditCardScreenState();
}

class _CreditCardScreenState extends State<CreditCardScreen> {
  List<CreditCardModel> cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  // Load saved cards from shared preferences
  _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString('cards');
    if (cardsJson != null) {
      List<dynamic> cardList = json.decode(cardsJson);
      setState(() {
        cards = cardList
            .map((cardData) => CreditCardModel.fromJson(cardData))
            .toList();
      });
    }
  }

  // Save cards to shared preferences
  _saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    String cardsJson = json.encode(cards.map((card) => card.toJson()).toList());
    prefs.setString('cards', cardsJson);
  }

  void addCard(CreditCardModel card) {
    setState(() {
      cards.add(card);
    });
    _saveCards();  // Save cards after adding
  }

  void editCard(int index, CreditCardModel updatedCard) {
    setState(() {
      cards[index] = updatedCard;
    });
    _saveCards();  // Save cards after editing
  }

  void deleteCard(int index) {
    setState(() {
      cards.removeAt(index);
    });
    _saveCards();  // Save cards after deleting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Credit Cards"),
        backgroundColor: Color.fromARGB(217, 214, 191, 175),
      ),
      backgroundColor: Color(0xFFF5F5DC),
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return ListTile(
            title: Text(
              "**** **** **** ${card.cardNumber.substring(card.cardNumber.length - 4)}",
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              "${card.cardHolderName} • Exp: ${card.validTill}",
              style: TextStyle(color: Colors.black),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Color.fromARGB(217, 214, 191, 175)),
                  onPressed: () async {
                    // Pass the onSave function to CreditCardForm when editing a card
                    final updatedCard = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreditCardForm(
                          card: card,
                          onSave: (updatedCard) {
                            editCard(index, updatedCard); // Handle editing the card
                          },
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => deleteCard(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(217, 214, 191, 175),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          // Pass the onSave function to CreditCardForm when adding a new card
          final newCard = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreditCardForm(
                onSave: (newCard) {
                  addCard(newCard); // Handle adding a new card
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
