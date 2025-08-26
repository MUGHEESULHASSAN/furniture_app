import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final String? token;
  final String? status;
  final String? userId;
  final User? user;

  AuthResponse({this.token, this.status, this.userId, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json["token"],
      userId: json["user"]["_id"], // ✅ correctly map from backend
      user: User.fromJson(json["user"]),
    );
  }
}
