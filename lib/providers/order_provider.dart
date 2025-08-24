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
    // ✅ Setup Dio with baseURL and Authorization header
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

  // ✅ Add product to cart
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

  // ✅ Increase item quantity
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

  // ✅ Decrease item quantity
  void decreaseQuantity(OrderItem item) {
    final index = _items.indexOf(item);
    if (index >= 0 && item.quantity > 1) {
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

  // ✅ Remove item completely
  void removeItem(OrderItem item) {
    _items.remove(item);
    notifyListeners();
  }

  // ✅ Clear cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // ✅ Reset order state
  void resetOrderStatus() {
    _orderSuccess = false;
    _errorMessage = null;
    notifyListeners();
  }

  // ✅ Send order to backend (with token + userId automatically)
  Future<bool> placeOrder(OrderModel order, AuthProvider authProvider) async {
    _isLoading = true;
    _errorMessage = null;
    _orderSuccess = false;
    notifyListeners();

    try {
      final body = {
        ...order.toJson(),
        "userId": authProvider.userId!, // ✅ Attach logged-in userId
      };

      final response = await _dio.post(
        "/orders",
        data: body,
        options: Options(
          headers: {
            "Authorization": "Bearer ${authProvider.token}", // ✅ attach token
          },
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
