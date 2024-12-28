
class InvoiceItemDto {
  int productId;
  int quantity;
  double discount;
  double unitPrice;
  double totalPrice;

  InvoiceItemDto({
    required this.productId,
    required this.quantity,
    required this.discount,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory InvoiceItemDto.fromJson(Map<String, dynamic> json) {
    return InvoiceItemDto(
      productId: json['productId'],
      quantity: json['quantity'],
      discount: json['discount'],
      unitPrice: json['unitPrice'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'discount': discount,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }
}
