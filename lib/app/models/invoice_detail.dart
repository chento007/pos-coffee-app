import 'package:coffee_app/app/models/product.dart';

class InvoiceDetail {
  int id;
  Product product;
  double unitPrice;
  double subTotal;
  int quantity;
  double discount;
  
  InvoiceDetail({
    required this.id,
    required this.product,
    required this.unitPrice,
    required this.subTotal,
    required this.quantity,
    required this.discount,
  });


  factory InvoiceDetail.fromJson(Map<String, dynamic> json) {
    return InvoiceDetail(
      id: json['id'],
      product: Product.fromJson(json['product']),
      unitPrice: json['unitPrice'],
      subTotal: json['subTotal'],
      quantity: json['quantity'],
      discount: json['discount'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'unitPrice': unitPrice,
      'subTotal': subTotal,
      'quantity': quantity,
      'discount': discount,
    };
  }
}
