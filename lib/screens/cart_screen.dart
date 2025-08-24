import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart'; // ✅ Your provider
import '../models/order_model.dart'; // ✅ OrderItem & OrderModel
import 'checkout_screen.dart';
import 'products_detail_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<OrderProvider>(); // ✅ Listen to OrderProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: const Color.fromARGB(217, 214, 191, 175),
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Your cart is empty",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final OrderItem item = cart.items[index]; // ✅ use OrderItem

                      return ListTile(
                        // ⚠️ OrderItem doesn’t have image by default
                        // If you want product images, add `image` field to OrderItem model
                        leading: const Icon(Icons.shopping_bag, size: 40, color: Colors.brown),

                        title: Text(
                          item.name,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            // Decrease quantity
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () {
                                cart.decreaseQuantity(item);
                              },
                            ),
                            // Show quantity
                            Text(
                              "Qty: ${item.quantity}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Increase quantity
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.green),
                              onPressed: () {
                                cart.increaseQuantity(item);
                              },
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Delete button
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                cart.removeItem(item);
                              },
                            ),
                            // Price
                            Text(
                              "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // ✅ Navigate to ProductDetailsScreen when tapped
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(
                                title: item.name,
                                image: "assets/images/placeholder.png", // ⚠️ replace when image exists
                                price: "\$${item.price.toStringAsFixed(2)}",
                                description: "No description available", // ✅ OrderItem doesn’t have description
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Total + Checkout Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Total: \$${cart.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: cart.items.isEmpty
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CheckoutScreen(),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cart.items.isEmpty
                              ? Colors.grey
                              : const Color.fromARGB(217, 214, 191, 175),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          "Proceed to Checkout",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
