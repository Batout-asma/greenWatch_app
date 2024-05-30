import 'package:green_watch_app/components/my_drawer.dart';
import 'package:green_watch_app/components/my_client_product_tile.dart';
import 'package:green_watch_app/models/product.dart';
import 'package:green_watch_app/pages/client/cart_page.dart';
import 'package:green_watch_app/pages/profile_page.dart';
import 'package:green_watch_app/pages/client/request_product.dart';
import 'package:green_watch_app/pages/settings_page.dart' as my_settings;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShopClient extends StatefulWidget {
  const ShopClient({super.key});

  @override
  State<ShopClient> createState() => _ShopClientState();
}

class _ShopClientState extends State<ShopClient> {
  final currentUser = FirebaseAuth.instance.currentUser;
  Future<List<Product>>? productsFuture;
  String searchText = '';
  @override
  void initState() {
    super.initState();
    productsFuture = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('Products').get();
    return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
  }

  void goToRequestPage() {
    // Go to request page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RequestProduct(),
      ),
    );
  }

  // Sign out user method
  void signUserOut() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Log Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Text('Log Out')),
            ],
          );
        });
  }

  void goToSettingsPage() {
    // Pop menu drawer
    Navigator.pop(context);

    // Go to settings page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const my_settings.Settings(),
      ),
    );
  }

  void goToProfilePage() {
    // Pop menu drawer
    Navigator.pop(context);

    // Go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Profile(),
      ),
    );
  }

  void goToCartPage() {
    // Go to cart page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Cart(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green[600],
        title: const Text(
          "Shop",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: goToCartPage,
              icon: const Icon(Icons.shopping_cart_rounded),
            ),
          )
        ],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSettingsTap: goToSettingsPage,
        onLogOutTap: signUserOut,
      ),
      body: FutureBuilder<List<Product>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!
              .where((product) =>
                  product.name.toLowerCase().contains(searchText.toLowerCase()))
              .toList();

          return ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Search Product",
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (text) => setState(() => searchText = text),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.post_add_rounded),
                    onPressed: goToRequestPage,
                  ),
                ],
              ),

              // products list
              products.isNotEmpty
                  ? SizedBox(
                      height: 600,
                      child: ListView.builder(
                        itemCount: products.length,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(15),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return MyClientProductTile(
                            product: product,
                          );
                        },
                      ),
                    )
                  : const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text('No product Available'),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
