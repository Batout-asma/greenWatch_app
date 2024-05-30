import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_watch_app/components/my_button.dart';
import 'package:green_watch_app/components/my_textfield.dart';
import 'dart:io';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final currentUser = FirebaseAuth.instance.currentUser;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? image;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    } else {
      print('No image selected');
    }
  }

  Future<String> uploadImage(String productId) async {
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('product_images')
        .child('$productId.jpg');

    // Upload file to the specified path
    await ref.putFile(image!);

    // Get the download URL for the uploaded file
    String imageUrl = await ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> addProduct() async {
    try {
      if (image == null) {
        print('No image selected');
        return;
      }

      final String productId = const Uuid().v4();
      final imageUrl = await uploadImage(productId);

      await FirebaseFirestore.instance
          .collection("Products")
          .doc(productId)
          .set(
        {
          'id': productId,
          'name': nameController.text,
          'description': descriptionController.text,
          'price': double.tryParse(priceController.text) ?? 0.0,
          'owner': currentUser?.email,
          'imageUrl': imageUrl,
        },
      );

      nameController.clear();
      descriptionController.clear();
      priceController.clear();

      setState(() {
        image = null;
      });

      print('Product added successfully');
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green[600],
        title: const Text(
          'Add Item',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                'Add a new product',
                style: TextStyle(
                  color: Color.fromRGBO(60, 60, 60, 1),
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: MyTextField(
                  controller: nameController,
                  hintText: 'Product Name',
                  obscureText: false,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: MyTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  obscureText: false,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: MyTextField(
                  controller: priceController,
                  hintText: 'Price',
                  obscureText: false,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(height: 10),
              if (image != null)
                Image.file(
                  image!,
                  height: 150,
                ),
              const SizedBox(height: 20),
              MyButton(
                onTap: addProduct,
                text: 'A D D',
                enabled: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
