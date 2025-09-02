import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:untitled/providers/auth_provider.dart';
import 'package:untitled/providers/cart_provider.dart';

import 'profile_screen.dart';
import 'custom_design_screen.dart';
import 'cart_screen.dart';
import 'trending_products_screen.dart';
import 'products_detail_screen.dart';
import '../providers/order_provider.dart';
import '../models/order_model.dart';

// ---------------- HomeScreen ----------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:5000/api",
      connectTimeout: 10000, // 10 seconds in milliseconds
      receiveTimeout: 10000, // 10 seconds in milliseconds
    ),
  );

  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final res = await dio.get('/products');
      if (res.statusCode == 200 && res.data is List) {
        final List list = res.data as List;
        setState(() {
          products =
              list.map<Map<String, dynamic>>((p) {
                final price = p['price'];
                return {
                  'id': p['_id']?.toString() ?? '',
                  'name': p['name']?.toString() ?? 'Untitled',
                  'image':
                      (p['image']?.toString().isNotEmpty ?? false)
                          ? p['image'].toString()
                          : 'assets/images/placeholder.png', // fallback asset
                  'price':
                      (price is num)
                          ? price.toDouble()
                          : double.tryParse('$price') ?? 0.0,
                  'description': p['description']?.toString() ?? '',
                  'category': p['category']?.toString() ?? 'Other',
                };
              }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products';
          isLoading = false;
        });
      }
    } on DioError catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Network error';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Unexpected error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color lightBeige = const Color.fromARGB(217, 214, 191, 175);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5DC),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CartScreen()),
                  );
                },
              ),
              Flexible(
                child: Image.asset(
                  'assets/images/mosfurex.png',
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ProductSearchDelegate(products),
                  );
                },
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFFF5F5DC),

      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(errorMessage, textAlign: TextAlign.center),
                ),
              )
              : SingleChildScrollView(
                child: Column(
                  children: [
                    // Category Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CategoryCard(
                            title: "Chair",
                            icon: Icons.chair,
                            color: lightBeige,
                            allProducts: products,
                          ),
                          CategoryCard(
                            title: "Table",
                            icon: Icons.table_chart,
                            color: lightBeige,
                            allProducts: products,
                          ),
                          CategoryCard(
                            title: "Bed",
                            icon: Icons.bed,
                            color: lightBeige,
                            allProducts: products,
                          ),
                        ],
                      ),
                    ),

                    // Banner
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 250,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(15),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/sofatop.jpeg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "High-quality sofa offers",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "50% off",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios, color: Colors.white),
                          ],
                        ),
                      ),
                    ),

                    // Products Heading
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Products",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    // Product Grid Section
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            productId: product['id'] as String,
                            name: product['name'] as String,
                            image: product['image'] as String,
                            price: product['price'] as double,
                            description: product['description'] as String,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

      // Bottom Navigation (unchanged)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        backgroundColor: const Color(0xFFF5F5DC),
        selectedItemColor: lightBeige,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trends',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'AR'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Custom Design',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TrendingProductsScreen(),
              ),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BedCustomizerScreen(),
              ),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const ProfileScreen(
                      name: '',
                      email: '',
                      phone: '',
                      address: '',
                    ),
              ),
            );
          }
        },
      ),
    );
  }
}

// ---------------- CategoryCard ----------------
class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Map<String, dynamic>> allProducts;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.allProducts,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => CategoryProductsScreen(
                  category: title,
                  allProducts: allProducts,
                ),
          ),
        );
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.black),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

// ---------------- CategoryProductsScreen ----------------
class CategoryProductsScreen extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> allProducts;

  const CategoryProductsScreen({
    super.key,
    required this.category,
    required this.allProducts,
  });

  @override
  Widget build(BuildContext context) {
    final filtered =
        allProducts
            .where(
              (p) =>
                  p['category'].toString().toLowerCase() ==
                  category.toLowerCase(),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("$category Products"),
        backgroundColor: const Color(0xFFD6BFAF),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      backgroundColor: const Color(0xFFF5F5DC),
      body:
          filtered.isEmpty
              ? const Center(
                child: Text(
                  "No products available in this category",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              )
              : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final product = filtered[index];
                  return ProductCard(
                    productId: product['id'] as String,
                    name: product['name'] as String,
                    image: product['image'] as String,
                    price: product['price'] as double,
                    description: product['description'] as String,
                  );
                },
              ),
    );
  }
}

// ---------------- ProductCard ----------------
class ProductCard extends StatefulWidget {
  final String productId;
  final String name;
  final String image; // can be asset path OR URL
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
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) => setState(() => _scale = 0.95);
  void _onTapUp(TapUpDetails details) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  bool get _isNetwork => widget.image.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ProductDetailsScreen(
                  productId: widget.productId,
                  title: widget.name,
                  image: widget.image,
                  price: "\$${widget.price.toStringAsFixed(2)}",
                  description: widget.description,
                ),
          ),
        );
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: _scale,
        child: Card(
          color: const Color.fromARGB(217, 214, 191, 175),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: SizedBox(
                  height: 160,
                  child:
                      _isNetwork
                          ? Image.network(
                            widget.image,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => const Center(
                                  child: Icon(Icons.broken_image, size: 48),
                                ),
                          )
                          : Image.asset(
                            widget.image,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) => const Center(
                                  child: Icon(Icons.broken_image, size: 48),
                                ),
                          ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          color: Colors.black,
                          iconSize: 20,
                          tooltip: 'Add to Cart',
                          onPressed: () async {
                            final cartProvider = Provider.of<CartProvider>(
                              context,
                              listen: false,
                            );
                            final authProvider = Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            );
                            final token = authProvider.token;

                            if (token == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'You must be logged in to add to cart',
                                  ),
                                ),
                              );
                              return;
                            }

                            try {
                              // Find if the product is already in the cart
                              final existingItems = cartProvider.items.where(
                                (item) => item.product.id == widget.productId,
                              );

                              if (existingItems.isNotEmpty) {
                                // Increase quantity if already in cart
                                await cartProvider.increaseQuantity(
                                  token,
                                  existingItems.first,
                                );
                              } else {
                                // Add new item to cart
                                await cartProvider.addToCart(
                                  token,
                                  widget.productId,
                                  1,
                                );
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${widget.name} added to cart'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to add ${widget.name} to cart: $e',
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "\$${widget.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- Search Delegate ----------------
class ProductSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> allProducts;

  ProductSearchDelegate(this.allProducts);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 18),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFD6BFAF),
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: const Icon(Icons.clear, color: Colors.white),
      onPressed: () => query = '',
    ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) {
    final results =
        allProducts
            .where(
              (p) =>
                  p['name'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  p['category'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();

    return results.isEmpty
        ? const Center(
          child: Text(
            "No products found",
            style: TextStyle(color: Colors.black),
          ),
        )
        : GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final product = results[index];
            return ProductCard(
              productId: product['id'] as String,
              name: product['name'] as String,
              image: product['image'] as String,
              price: product['price'] as double,
              description: product['description'] as String,
            );
          },
        );
  }

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);
}
