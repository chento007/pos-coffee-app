import 'package:coffee_app/app/models/dto/product.dto.dart';

import 'invoice.dart';
class InvoiceItem {
  int? id;
  int? discount;
  double unitPrice;
  double totalPrice;
  int quantity;
  Invoice? invoice;
  ProductDto? product;

  InvoiceItem({
    this.id,
    this.discount,
    required this.unitPrice,
    required this.totalPrice,
    required this.quantity,
    this.invoice,
    this.product,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id'],
      discount: json['discount'] ?? 0,
      unitPrice: json['unitPrice'] != null
          ? double.tryParse(json['unitPrice'].toString()) ?? 0.0
          : 0.0,
      totalPrice: json['totalPrice'] != null
          ? double.tryParse(json['totalPrice'].toString()) ?? 0.0
          : 0.0,
      quantity: json['quantity'] ?? 0,
      invoice: json['invoice'] != null ? Invoice.fromJson(json['invoice']) : null,
      product: json['product'] != null ? ProductDto.fromJson(json['product']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discount': discount,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'quantity': quantity,
      'invoice': invoice?.toJson(),
      'product': product?.toJson(),
    };
  }
}
