class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String image;
  final bool trending; // ✅ new field

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    this.trending = false, // ✅ default to false if not provided
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      trending: json['trending'] ?? false, // ✅ parse trending
    );
  }
}
