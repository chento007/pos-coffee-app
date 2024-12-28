import 'dart:convert';

// Product DTO class
class CreateProductDto {
  final String name;
  final String description;
  final double price;
  final int stockQty;
  final int categoryId;
  final int discount;

  // Constructor
  CreateProductDto({
    required this.name,
    required this.description,
    required this.price,
    required this.stockQty,
    required this.categoryId,
    required this.discount,
  });

  // Factory method to create a Product from a JSON object
  factory CreateProductDto.fromJson(Map<String, dynamic> json) {
    return CreateProductDto(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0.0,
      stockQty: json['stockQty'] ?? 0,
      categoryId: json['categoryId'] ?? 0,
      discount: json['discount'] ?? 0,
    );
  }

  // Method to convert Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stockQty': stockQty,
      'categoryId': categoryId,
      'discount': discount,
    };
  }

  // Optional: A method to encode to JSON string (useful for HTTP requests)
  String toJsonString() {
    return json.encode(toJson());
  }
}

