import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'profile_screen.dart';
import 'custom_design_screen.dart';
import "cart_screen.dart";
import 'package:untitled/models/cart_model.dart';
import '../providers/cart_provider.dart';
import 'trending_products_screen.dart';
import 'products_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Map<String, dynamic>> products = [
    {
      'name': 'Luxury Sofa',
      'image': 'assets/images/sofa.jpeg',
      'price': 499.00,
      'description': 'A luxurious and comfortable sofa.',
      'category': 'Chair',
    },
    {
      'name': 'Modern Chair',
      'image': 'assets/images/chair.jpeg',
      'price': 199.00,
      'description': 'A stylish modern chair for your living room.',
      'category': 'Chair',
    },
    {
      'name': 'King Size Bed',
      'image': 'assets/images/bed1.jpeg',
      'price': 1399.99,
      'description': 'A large king-sized bed for ultimate comfort.',
      'category': 'Bed',
    },
    {
      'name': 'Dining Table',
      'image': 'assets/images/table.jpeg',
      'price': 899.99,
      'description': 'Elegant dining table for family dinners.',
      'category': 'Table',
    },
  ];

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
      body: SingleChildScrollView(
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
                      allProducts: products),
                  CategoryCard(
                      title: "Table",
                      icon: Icons.table_chart,
                      color: lightBeige,
                      allProducts: products),
                  CategoryCard(
                      title: "Bed",
                      icon: Icons.bed,
                      color: lightBeige,
                      allProducts: products),
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
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),

            // Products Heading
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    name: product['name']!,
                    image: product['image']!,
                    price: product['price']!,
                    description: product['description']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        backgroundColor: const Color(0xFFF5F5DC),
        selectedItemColor: lightBeige,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Trends'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'AR'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Custom Design'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrendingProductsScreen()),
            );
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BedCustomizerScreen()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
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
            builder: (context) =>
                CategoryProductsScreen(category: title, allProducts: allProducts),
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
    final filteredProducts = allProducts
        .where((product) =>
    product['category'].toString().toLowerCase() ==
        category.toLowerCase())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("$category Products"),
        backgroundColor: const Color(0xFFD6BFAF),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      backgroundColor: const Color(0xFFF5F5DC),
      body: filteredProducts.isEmpty
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
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return ProductCard(
            name: product['name']!,
            image: product['image']!,
            price: product['price']!,
            description: product['description']!,
          );
        },
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final String name;
  final String image;
  final double price;
  final String description;

  const ProductCard({
    super.key,
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

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
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
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
                child: SizedBox(
                  height: 160,
                  child: Image.asset(
                    widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                          onPressed: () {
                            cartProvider.addItem(CartItem(
                              name: widget.name,
                              image: widget.image,
                              price: widget.price,
                              description: widget.description,
                            ));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                Text('${widget.name} added to cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
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

/// 🔍 Search Delegate Implementation
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
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.white),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = allProducts
        .where((product) =>
    product['name'].toString().toLowerCase().contains(query.toLowerCase()) ||
        product['category'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();

    return results.isEmpty
        ? const Center(
        child: Text("No products found",
            style: TextStyle(color: Colors.black)))
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
          name: product['name']!,
          image: product['image']!,
          price: product['price']!,
          description: product['description']!,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
