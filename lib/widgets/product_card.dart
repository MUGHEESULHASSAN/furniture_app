import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String productId;
  final String name;
  final String image;
  final double price;
  final String description;

  const ProductCard({
    super.key,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Product Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: image.isNotEmpty
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, size: 50),
                    )
                  : const Icon(Icons.image, size: 50),
            ),
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text("\$${price.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.green, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
