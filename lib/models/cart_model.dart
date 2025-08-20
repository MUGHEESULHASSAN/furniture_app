class CartItem {
  final String name;
  final String image;
  final double price;
  final String description; // Added description
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    required this.description, // Add description to the constructor
    this.quantity = 1,
  });
}

