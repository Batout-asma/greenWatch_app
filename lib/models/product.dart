import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String owner;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.owner,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'owner': owner,
      'imageUrl': imageUrl
    };
  }

  factory Product.fromMapClient(Map<String, dynamic> data) {
    return Product(
      id: data['id'] as String,
      name: data['name'] as String,
      price: (data['price'] is int)
          ? (data['price'] as int).toDouble()
          : data['price'] as double,
      description: data['description'] as String,
      owner: data['owner'] as String,
      imageUrl: data['imageUrl'] as String,
    );
  }

  factory Product.fromMapSeller(Map<String, dynamic> data) {
    return Product(
      id: data['id']?.toString() ?? '',
      name: data['name']?.toString() ?? 'Unknown Product',
      price: (data['price'] is int)
          ? (data['price'] as int).toDouble()
          : double.tryParse(data['price']?.toString() ?? '0.0') ?? 0.0,
      description: data['description']?.toString() ?? '',
      owner: data['owner']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString() ?? '',
    );
  }

  factory Product.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return Product(
      id: snapshot.id,
      name: data['name']?.toString() ?? 'Unknown Product',
      price: (data['price'] is int)
          ? (data['price'] as int).toDouble()
          : double.tryParse(data['price']?.toString() ?? '0.0') ?? 0.0,
      description: data['description']?.toString() ?? '',
      owner: data['owner']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString() ?? '',
    );
  }

  static Product fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return Product.fromFirestore(doc);
  }
}
