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

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "name": name,
    "price": price,
    "quantity": quantity,
  };
}

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

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "name": name,
    "email": email,
    "phone": phone,
    "address": address,
    "paymentMethod": paymentMethod,
    "totalPrice": totalPrice,
    "items": items.map((e) => e.toJson()).toList(),
  };
}
