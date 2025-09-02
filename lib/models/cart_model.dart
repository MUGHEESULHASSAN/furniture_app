class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String image;
  final bool trending;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    required this.trending,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["_id"],
      name: json["name"],
      description: json["description"] ?? "",
      price: (json["price"] as num).toDouble(),
      category: json["category"] ?? "",
      image: json["image"] ?? "",
      trending: json["trending"] ?? false,
    );
  }
}

class CartItem {
  final String id;
  final Product product;
   int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json["_id"],
      product: Product.fromJson(json["product"]), // ✅ nested product
      quantity: json["quantity"] ?? 1,
    );
  }
}
