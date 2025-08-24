import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "http://localhost:5000/api/users")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  // GET /api/users
  @GET("")
  Future<List<User>> getUsers();

  // POST /api/users/signup
  @POST("/register")
  Future<AuthResponse> registerUser(@Body() Map<String, dynamic> formData);

  // POST /api/users/login (Add this method)
  @POST("/login")
  Future<AuthResponse> loginUser(@Body() Map<String, dynamic> formData);
}
