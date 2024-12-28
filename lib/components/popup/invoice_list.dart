import 'package:coffee_app/app/models/invoice-item.dart';
import 'package:flutter/material.dart';

class InvoiceItemsWidget extends StatelessWidget {
  final List<InvoiceItem> invoiceItems;

  InvoiceItemsWidget({required this.invoiceItems});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: invoiceItems.length,
      itemBuilder: (context, index) {
        final item = invoiceItems[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Item #${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Product ID: ${item.product?.id ?? 'N/A'}'),
                Text('Product Name: ${item.product?.name ?? 'N/A'}'),
                Text('Invoice ID: ${item.invoice?.id ?? 'N/A'}'),
                Text('Discount: ${item.discount ?? 0}%'),
                Text('Unit Price: \$${item.unitPrice.toStringAsFixed(2)}'),
                Text('Total Price: \$${item.totalPrice.toStringAsFixed(2)}'),
                Text('Quantity: ${item.quantity}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
