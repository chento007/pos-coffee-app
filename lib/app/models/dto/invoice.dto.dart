import 'package:coffee_app/app/models/dto/invoice-item.dto.dart';

class InvoiceDto {
  int? discount;
  double totalAmount;
  List<InvoiceItemDto> items;

  InvoiceDto({
    this.discount,
    required this.totalAmount,
    required this.items,
  });

  factory InvoiceDto.fromJson(Map<String, dynamic> json) {
    return InvoiceDto(
      discount: json['discount'],
      totalAmount: json['totalAmount'].toDouble(),
      items: List<InvoiceItemDto>.from(
        json['items'].map((item) => InvoiceItemDto.fromJson(item)).toList(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discount': discount,
      'totalAmount': totalAmount,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}