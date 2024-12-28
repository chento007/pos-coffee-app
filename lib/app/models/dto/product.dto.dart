class ProductDto {
  final int id;
  final String uuid;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final bool status;
  final String name;
  final String description;
  final double price;  // Price should be a double
  final String? order;
  final int categoryId;
  final bool isPopular;

  ProductDto({
    required this.id,
    required this.uuid,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.status,
    required this.name,
    required this.description,
    required this.price,
    this.order,
    required this.categoryId,
    required this.isPopular,
  });

  // Factory constructor to create ProductDto from JSON
  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id'] ,
      uuid: json['uuid'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      status: json['status'] as bool,
      name: json['name'] as String,
      description: json['description'] as String,
      price: _parsePrice(json['price']),
      order: json['order'] as String?,
      categoryId: json['categoryId'] as int,
      isPopular: json['isPopular'] as bool,
    );
  }

  // Helper method to parse price
  static double _parsePrice(dynamic price) {
    if (price is String) {
      return double.tryParse(price) ?? 0.0; // Try parsing the string as a double
    } else if (price is num) {
      return price.toDouble(); // If it's already a number, return it as a double
    } else {
      return 0.0; // Fallback to 0.0 if it's an unexpected type
    }
  }

  // To JSON method to serialize the ProductDto object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'status': status,
      'name': name,
      'description': description,
      'price': price.toString(),  // Convert price to string when serializing
      'order': order,
      'categoryId': categoryId,
      'isPopular': isPopular,
    };
  }
}
