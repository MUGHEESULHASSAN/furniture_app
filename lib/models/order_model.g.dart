// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      productId: json['productId'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'productId': instance.productId,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      paymentMethod: json['paymentMethod'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'paymentMethod': instance.paymentMethod,
      'totalPrice': instance.totalPrice,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
