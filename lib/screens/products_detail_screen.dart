// ---------------- ProductDetailsScreen ----------------
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productId; // ✅ Backend product ID
  final String title;
  final String image;
  final String price;
  final String description;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(217, 214, 191, 175),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: Image.network(
              image,
              width: double.infinity,
              height: 260,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.broken_image, size: 100));
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$$price",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Product Description",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  ),
                  const SizedBox(height: 80), // Extra space for button
                ],
              ),
            ),
          ),
        ],
      ),

      // Floating Add to Cart Button
      bottomNavigationBar: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(217, 214, 191, 175),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18),
        ),
        onPressed: () async {
          if (token == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You must be logged in to add to cart')),
            );
            return;
          }

          try {
            // Check if product already exists in cart
            final existingItems = cartProvider.items.where(
              (item) => item.product.id == productId,
            );

            if (existingItems.isNotEmpty) {
              await cartProvider.increaseQuantity(token, existingItems.first);
            } else {
              await cartProvider.addToCart(token, productId, 1);
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title added to cart')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add $title to cart: $e')),
            );
          }
        },
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text("Add to Cart"),
      ),
    );
  }
}
