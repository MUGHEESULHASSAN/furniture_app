import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';
part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  final String? token;
  final String? status;
  final String? userId; // top-level userId
  final User? user; // reference your existing User class

  AuthResponse({this.token, this.status, this.userId, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}
