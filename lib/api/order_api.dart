import 'package:dio/dio.dart';
import '../models/order_model.dart';

class OrderService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:5000/api"));

  Future<bool> placeOrder(OrderModel order) async {
    try {
      final response = await _dio.post("/orders", data: order.toJson());
      return response.statusCode == 201;
    } catch (e) {
      print("Order error: $e");
      return false;
    }
  }
}
