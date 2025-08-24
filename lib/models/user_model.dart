import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart'; // Make sure you have this part statement

@JsonSerializable()
class User {
  final String? id; // Add this field
  final String name;
  final String email;
  final String password;
  final String phone;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
