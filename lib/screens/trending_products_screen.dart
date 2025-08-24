import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'products_detail_screen.dart';
import '../models/order_model.dart';
import '../providers/order_provider.dart';

class TrendingProductsScreen extends StatelessWidget {
  const TrendingProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> trendingCategories = [
      {
        'title': 'Chairs',
        'image': 'assets/images/chairs.jpg',
        'price': '\$120',
        'description': 'Comfortable wooden chair perfect for living rooms.',
      },
      {
        'title': 'Beds',
        'image': 'assets/images/beds.jpg',
        'price': '\$350',
        'description':
            'Queen-sized bed with storage drawers and modern design.',
      },
      {
        'title': 'Sofas',
        'image': 'assets/images/sofas.jpg',
        'price': '\$270',
        'description': 'Elegant 3-seater sofa with soft cushions and fabric.',
      },
      {
        'title': 'Wardrobes',
        'image': 'assets/images/wardrobes.jpg',
        'price': '\$400',
        'description': 'Spacious wardrobe with sliding doors and mirror.',
      },
      {
        'title': 'Tables',
        'image': 'assets/images/tables.jpg',
        'price': '\$150',
        'description': 'Dining table that seats six, with a solid wood finish.',
      },
      {
        'title': 'Desks',
        'image': 'assets/images/desks.jpg',
        'price': '\$180',
        'description': 'Office desk with drawers and cable management design.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trending Products",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(217, 214, 191, 175),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: trendingCategories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final item = trendingCategories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ProductDetailsScreen(
                          title: item['title']!,
                          image: item['image']!,
                          price: item['price']!,
                          description: item['description']!,
                        ),
                  ),
                );
              },
              child: Card(
                color: const Color.fromARGB(217, 214, 191, 175),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: SizedBox(
                        height: 140,
                        child: Image.asset(
                          item['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image, size: 50),
                            );
                          },
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_shopping_cart),
                                color: Colors.black,
                                iconSize: 20,
                                tooltip: 'Add to Cart',
                                onPressed: () {
                                  // Use OrderProvider instead of CartProvider
                                  final orderProvider =
                                      context.read<OrderProvider>();
                                  orderProvider.addItem(
                                    OrderItem(
                                      productId: DateTime.now().toString(),
                                      name: item['title']!,
                                      price:
                                          double.tryParse(
                                            item['price']!.replaceAll("\$", ""),
                                          ) ??
                                          0,
                                      quantity: 1,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${item['title']} added to cart',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['price']!,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
