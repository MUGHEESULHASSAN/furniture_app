import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/order_model.dart';
import '../providers/auth_provider.dart';

class OrderProvider with ChangeNotifier {
  late Dio _dio;
  final List<OrderItem> _items = [];
  List<OrderItem> get items => List.unmodifiable(_items);

  double get totalPrice =>
      _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  // ✅ Order state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _orderSuccess = false;
  bool get orderSuccess => _orderSuccess;

  OrderProvider(AuthProvider authProvider) {
    _dio = Dio(
      BaseOptions(
        baseUrl: "http://localhost:5000/api",
        headers: {
          "Content-Type": "application/json",
          if (authProvider.token != null)
            "Authorization": "Bearer ${authProvider.token}",
        },
      ),
    );
  }

  // ✅ Cart methods
  void addItem(OrderItem item) {
    final index = _items.indexWhere((i) => i.productId == item.productId);
    if (index >= 0) {
      _items[index] = OrderItem(
        productId: _items[index].productId,
        name: _items[index].name,
        price: _items[index].price,
        quantity: _items[index].quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void increaseQuantity(OrderItem item) {
    final index = _items.indexOf(item);
    if (index >= 0) {
      _items[index] = OrderItem(
        productId: item.productId,
        name: item.name,
        price: item.price,
        quantity: item.quantity + 1,
      );
      notifyListeners();
    }
  }

  void decreaseQuantity(OrderItem item) {
    final index = _items.indexOf(item);
    if (index >= 0) {
      if (item.quantity > 1) {
        _items[index] = OrderItem(
          productId: item.productId,
          name: item.name,
          price: item.price,
          quantity: item.quantity - 1,
        );
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItem(OrderItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void resetOrderStatus() {
    _orderSuccess = false;
    _errorMessage = null;
    notifyListeners();
  }

  // ✅ Place order with proper JSON serialization
  Future<bool> placeOrder(OrderModel order, AuthProvider authProvider) async {
    _isLoading = true;
    _errorMessage = null;
    _orderSuccess = false;
    notifyListeners();

    try {
      if (authProvider.userId == null || authProvider.userId!.isEmpty) {
        throw Exception("User not logged in or invalid userId");
      }

      for (var item in order.items) {
        if (item.productId.isEmpty) {
          throw Exception("Invalid productId in cart");
        }
      }

      // Use json_serializable to generate correct JSON
      final body = order.toJson();
      print("📦 Sending order body: $body");

      final response = await _dio.post(
        "/orders",
        data: body,
        options: Options(
          headers: {"Authorization": "Bearer ${authProvider.token}"},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _orderSuccess = true;
        clearCart();
      } else {
        _errorMessage =
            response.data["message"] ?? "Failed to place order. Try again.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
    return _orderSuccess;
  }
}
