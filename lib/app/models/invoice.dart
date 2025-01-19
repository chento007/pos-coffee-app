import 'package:coffee_app/app/models/invoice-item.dart';

class Invoice {
  int? id;
  int? discount;
  double totalAmount;
  List<InvoiceItem> details;
  final String createdAt; // Changed to DateTime
  final String updatedAt; // Changed to DateTime
  
  Invoice({
    this.id,
    this.discount,
    required this.totalAmount,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] ?? 0,
      discount: json['discount'] ?? 0,
      totalAmount: json['totalAmount'] is String
          ? double.tryParse(json['totalAmount']) ?? 0.0
          : (json['totalAmount'] as num).toDouble(),
      details: json['details'] != null && json['details'] is List
          ? List<InvoiceItem>.from((json['details'] as List).map((detail) {
              if (detail == null) {
                throw Exception('Null detail in details array');
              }
              return InvoiceItem.fromJson(detail as Map<String, dynamic>);
            }))
          : [],
      createdAt: json['createdAt'] ?? '1970-01-01', // Parse as DateTime
      updatedAt: json['updatedAt'] ?? '1970-01-01', // Parse as DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discount': discount,
      'totalAmount': totalAmount,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'details': details.map((x) => x.toJson()).toList(),
    };
  }
}
