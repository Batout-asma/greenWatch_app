import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:green_watch_app/components/my_drawer.dart';
import 'package:green_watch_app/components/my_seller_product_tile.dart';
import 'package:green_watch_app/models/product.dart';
import 'package:green_watch_app/pages/settings_page.dart' as my_settings;
import 'package:flutter/material.dart';

import 'package:green_watch_app/pages/profile_page.dart';

import 'package:firebase_auth/firebase_auth.dart';

class HomeSeller extends StatefulWidget {
  const HomeSeller({super.key});

  @override
  State<HomeSeller> createState() => _HomeSellerState();
}

class _HomeSellerState extends State<HomeSeller> {
  final user = FirebaseAuth.instance.currentUser!;
  List<Product> products = [];

  void deleteProduct(Product product) async {
    final productRef =
        FirebaseFirestore.instance.collection('Products').doc(product.id);

    try {
      // Delete the product document
      await productRef.delete();

      // Update the local product list
      setState(() {
        products.removeWhere((item) => item.id == product.id);
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully!'),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting product: $e'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserProducts();
  }

  void fetchUserProducts() async {
    final userDoc = FirebaseFirestore.instance.collection('Products');
    final querySnapshot =
        await userDoc.where('owner', isEqualTo: user.email).get();

    setState(() {
      products =
          querySnapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    });
  }

// sign user out method
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
    // pop menu drawer
    Navigator.pop(context);

    // go to settings page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const my_settings.Settings(),
      ),
    );
  }

  void goToProfilePage() {
    // pop menu drawer
    Navigator.pop(context);

    // go to profile page

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Profile(),
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
            "Home",
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: MyDrawer(
          onProfileTap: goToProfilePage,
          onSettingsTap: goToSettingsPage,
          onLogOutTap: signUserOut,
        ),
        body: ListView(
          children: [
            const SizedBox(height: 25),
            // shop subtitle
            Center(
              child: Text(
                "My list of products",
                style: TextStyle(color: Colors.green[900], fontSize: 16),
              ),
            ),

            SizedBox(
              height: 550,
              child: products.isEmpty
                  ? Center(
                      child: Text(
                      "No owned product, try add some.",
                      style: TextStyle(color: Colors.grey[900], fontSize: 20),
                    ))
                  : ListView.builder(
                      itemCount: products.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return MySellerProductTile(
                          product: product,
                          deleteProduct: deleteProduct,
                        );
                      },
                    ),
            ),
          ],
        ));
  }
}
