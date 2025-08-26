import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OrderModel {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String paymentMethod;
  final double totalPrice;
  final List<OrderItem> items;

  OrderModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.paymentMethod,
    required this.totalPrice,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
