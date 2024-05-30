import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_watch_app/components/my_button.dart';
import 'package:green_watch_app/components/my_textfield.dart';
import 'package:uuid/uuid.dart';

class RequestProduct extends StatefulWidget {
  const RequestProduct({super.key});

  @override
  State<RequestProduct> createState() => _RequestProductState();
}

class _RequestProductState extends State<RequestProduct> {
  //user that is logged in
  final user = FirebaseAuth.instance.currentUser;

  //  Field controllers
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green[600],
        title: const Text(
          'Request Product',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),

              // Title
              const Text(
                'Fill the form for the request',
                style: TextStyle(
                  color: Color.fromRGBO(60, 60, 60, 1),
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 25),

              // name field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: MyTextField(
                  controller: nameController,
                  hintText: 'Product Name',
                  obscureText: false,
                ),
              ),

              const SizedBox(height: 10),

              // description field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: MyTextField(
                  controller: priceController,
                  hintText: 'Price',
                  obscureText: false,
                ),
              ),

              const SizedBox(height: 20),

              // Login Btn
              MyButton(
                onTap: requestProduct,
                text: 'R E Q U E S T',
                enabled: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // request product
  Future<String> requestProduct() async {
    final String productId = const Uuid().v4();
    // Create 'Requests' in the database
    await FirebaseFirestore.instance
        .collection("Requests")
        .doc(user?.email)
        .set(
      {
        'id': productId,
        'name': nameController.text,
        'price': priceController.text,
        'owner': user?.email,
      },
    );
    nameController.text = '';
    priceController.text = '';

    return productId;
  }
}
