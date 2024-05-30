import 'package:green_watch_app/components/my_button.dart'; // Import MyButton
import 'package:green_watch_app/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Product> cartItems = [];
  final user = FirebaseAuth.instance.currentUser!;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  void fetchCartItems() async {
    setState(() {
      isLoading = true;
    });

    final userDoc =
        FirebaseFirestore.instance.collection('Users').doc(user.email);
    final cart = userDoc.collection('Cart');
    final cartSnapshot = await cart.get();

    if (cartSnapshot.docs.isEmpty) {
      setState(() {
        cartItems = [];
        isLoading = false;
      });
      return;
    }

    // Collect all product IDs from the cart
    List<String> productIds =
        cartSnapshot.docs.map((doc) => doc.data()['id'] as String).toList();

    // Fetch product details in a single batched request
    final productsSnapshot = await FirebaseFirestore.instance
        .collection('Products')
        .where(FieldPath.documentId, whereIn: productIds)
        .get();

    List<Product> newCartItems = productsSnapshot.docs.map((doc) {
      return Product.fromFirestore(doc);
    }).toList();

    setState(() {
      cartItems = newCartItems;
      isLoading = false;
    });
  }

  void removeItemFromCart(Product product) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Remove ${product.name} from Cart?"),
        content: const Text("Remove this item from your cart?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              cartItems.remove(product);
              setState(() {});

              final userDocRef = FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.email);
              final cartRef = userDocRef.collection('Cart');

              final productRef =
                  cartRef.where('id', isEqualTo: product.id).limit(1).get();
              productRef.then((querySnapshot) {
                if (querySnapshot.docs.isNotEmpty) {
                  querySnapshot.docs.first.reference.delete();
                }
              });
            },
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  void payBtnPressed(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Text("Payment processing..."),
      ),
    );

    // Replace with your actual payment processing logic
    final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(user.email);
    final cartRef = userDocRef.collection('Cart');

    await cartRef.get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      } // Delete each document
    });

    cartItems.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green[600],
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          // Cart list with data fetching
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : cartItems.isEmpty
                    ? const Center(child: Text("Your cart is empty..."))
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final product = cartItems[index];
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green.shade300,
                              child: ListTile(
                                title: Text(product.name),
                                subtitle:
                                    Text(product.price.toStringAsFixed(2)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => removeItemFromCart(product),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ), // Pay button
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
            child: MyButton(
              onTap: cartItems.isEmpty ? null : () => payBtnPressed(context),
              text: "P A Y  N O W",
              enabled: cartItems.isNotEmpty,
            ),
          ),
        ],
      ),
    );
  }
}
