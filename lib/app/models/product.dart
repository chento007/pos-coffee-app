import 'package:coffee_app/app/models/category.dart';

class Product {
  final int id;
  final String uuid;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool status;
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final Category category;
  final bool isPopular;

  Product({
    required this.id,
    required this.uuid,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.status,
    required this.isPopular,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.category, // Add category to constructor
  });

  // Factory method to create a Product object from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      uuid: json['uuid'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'], // deletedAt can be null
      status: json['status'],
      isPopular: json['isPopular'],
      name: json['name'],
      description: json['description'],
      price: _parsePrice(json['price']), // Parse price safely
      categoryId: json['categoryId'],
      category: Category.fromJson(json['category']), // Parse category
    );
  }

  // Helper function to handle price as int, double, or string
  static double _parsePrice(dynamic price) {
    if (price is String) {
      // If it's a string, try to convert it to double
      return double.tryParse(price) ?? 0.0;
    } else if (price is int) {
      // If it's an integer, just convert to double
      return price.toDouble();
    } else if (price is double) {
      // If it's already a double, just return it
      return price;
    } else {
      return 0.0; // Default value if price is invalid or null
    }
  }

  // Method to convert a Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'isPopular': isPopular,
      'name': name,
      'description': description,
      'price': price, // Price is always a double now
      'categoryId': categoryId,
      'category': category.toJson(),
    };
  }
}
