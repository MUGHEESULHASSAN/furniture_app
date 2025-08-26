import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "_id") // 👈 tells Dart that MongoDB's `_id` maps to this field
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? phone;

  User({this.id, this.name, this.email, this.password, this.phone});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
