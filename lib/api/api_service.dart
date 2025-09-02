import 'package:dio/dio.dart';
import '../models/product.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = "http://localhost:5000/api/products"; 

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get(baseUrl);

      if (response.statusCode == 200) {
        List data = response.data;
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load products");
      }
    } on DioError catch (e) {
  throw Exception("Dio error: ${e.message}");
}
  }

  Future<List<Product>> fetchTrendingProducts() async {
    try {
      final response = await _dio.get(baseUrl);

      if (response.statusCode == 200) {
        List data = response.data;
        // Only keep products where trending == true
        return data
            .map((json) => Product.fromJson(json))
            .where((product) => product.trending)
            .toList();
      } else {
        throw Exception("Failed to load trending products");
      }
    } on DioError catch (e) {
      throw Exception("Dio error: ${e.message}");
    }
  }
}
