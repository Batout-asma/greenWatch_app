import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_watch_app/models/product.dart';

Future<void> addProductToCart(BuildContext context, Product product) async {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userDocRef =
      FirebaseFirestore.instance.collection('Users').doc(currentUser.email);
  final cartRef = userDocRef.collection('Cart');
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Add ${product.name} to Cart?"),
            content: const Text("Add this item to your cart?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await cartRef.add({'id': product.id});
                  final cartDocSnap = await userDocRef.get();
                  if (!cartDocSnap.exists) {
                    await userDocRef.set({'Cart': []});
                  }

                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"${product.name}" added to cart!'),
                    ),
                  );
                },
                child: const Text("Add"),
              ),
            ],
          ));

  // Show success message
}
