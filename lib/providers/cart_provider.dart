import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    return _items.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }

  // Add item (but check if it already exists)
  void addItem(CartItem newItem) {
    final index = _items.indexWhere((item) => item.name == newItem.name);

    if (index >= 0) {
      // If item already exists → just increase quantity
      _items[index].quantity += newItem.quantity;
    } else {
      // Otherwise add new item
      _items.add(newItem);
    }
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }
}
