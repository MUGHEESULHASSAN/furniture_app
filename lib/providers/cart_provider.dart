import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/cart_model.dart';

class CartProvider with ChangeNotifier {
  final Dio _dio = Dio();
  List<CartItem> _cartItems = [];
  List<CartItem> get items => _cartItems;

  final String baseUrl = "http://localhost:5000/api/cart"; 
  // Use 10.0.2.2 for Android emulator, localhost for iOS simulator

  bool isLoading = false;

  // -------------------- Fetch Cart --------------------
  Future<void> fetchCart(String token) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _dio.get(
        baseUrl,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _cartItems = data.map((json) => CartItem.fromJson(json)).toList();
      }
    } catch (e) {
      print("Error fetching cart: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // -------------------- Add Item --------------------
Future<void> addToCart(String token, String productId, int quantity) async {
  try {
    final response = await _dio.post(
      baseUrl,
      data: {"productId": productId, "quantity": quantity}, // ✅ changed key
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200) { // ✅ backend sends 200 on success
      final item = CartItem.fromJson(response.data);
      _cartItems.add(item);
      notifyListeners();
    }
  } catch (e) {
    print("Error adding to cart: $e");
    rethrow;
  }
}


  // -------------------- Update Quantity --------------------
  Future<void> updateQuantity(String token, String id, int quantity) async {
    try {
      await _dio.put(
        "$baseUrl/$id",
        data: {"quantity": quantity},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      // ✅ Update locally without parsing backend response
      final index = _cartItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _cartItems[index].quantity = quantity;
        notifyListeners();
      }
    } catch (e) {
      print("Error updating quantity: $e");
    }
  }

  // -------------------- Remove Item --------------------
  Future<void> removeItem(String token, String id) async {
    try {
      final response = await _dio.delete(
        "$baseUrl/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        _cartItems.removeWhere((item) => item.id == id);
        notifyListeners();
      }
    } catch (e) {
      print("Error removing from cart: $e");
    }
  }

  // -------------------- Helpers --------------------
  Future<void> increaseQuantity(String token, CartItem item) async {
    await updateQuantity(token, item.id, item.quantity + 1);
  }

  Future<void> decreaseQuantity(String token, CartItem item) async {
    if (item.quantity > 1) {
      await updateQuantity(token, item.id, item.quantity - 1);
    } else {
      await removeItem(token, item.id);
    }
  }

  // -------------------- Total Price --------------------
  double get totalPrice {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  // In cart_provider.dart

// -------------------- Clear Entire Cart --------------------
Future<void> clearCart(String token) async {
  try {
    final response = await _dio.delete(
      baseUrl,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    if (response.statusCode == 200) {
      _cartItems.clear();
      notifyListeners();
    }
  } catch (e) {
    print("Error clearing cart: $e");
  }
}

}


