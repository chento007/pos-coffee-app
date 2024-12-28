import 'package:coffee_app/app/controllers/category_controller.dart';
import 'package:coffee_app/app/controllers/invoice_controller.dart';
import 'package:coffee_app/app/controllers/product_controller.dart';
import 'package:coffee_app/app/models/category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditOrderItemDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onUpdate;
  final int index;
  final double price;
  final double discount;
  final InvoiceController invoiceController = Get.put(InvoiceController());

  EditOrderItemDialog({
    Key? key,
    required this.onUpdate,
    required this.index,
    required this.price,
    required this.discount,
  }) : super(key: key);

  @override
  _EditOrderItemDialogState createState() => _EditOrderItemDialogState();
}

class _EditOrderItemDialogState extends State<EditOrderItemDialog> {
  final _formKey = GlobalKey<FormState>();

  final priceController = TextEditingController();
  final discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    priceController.text = widget.price.toString();
    discountController.text = widget.discount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Product Order',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 600,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                _buildNumericField(
                  controller: priceController,
                  label: 'Price',
                  hint: 'Enter product price',
                ),
                const SizedBox(height: 12),
                _buildNumericField(
                  controller: discountController,
                  label: 'Discount (%)',
                  hint: 'Enter product Discount',
                  isOptional: true,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              widget.onUpdate({
                'price': priceController.text,
                'discount': discountController.text,
              });
              widget.invoiceController.updateOrderItem(
                  widget.index,
                  double.parse(priceController.text),
                  double.parse(discountController.text));
              Navigator.of(context).pop();
            }
          },
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  /// Builds a text field with a label, hint, and validation
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      validator: (value) =>
          value == null || value.isEmpty ? '$label is required' : null,
    );
  }

  Widget _buildNumericField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool isOptional = false, // Add an optional flag
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (!isOptional && (value == null || value.isEmpty)) {
          return '$label is required';
        } else if (value != null &&
            value.isNotEmpty &&
            double.tryParse(value) == null) {
          return 'Enter a valid number';
        }
        return null;
      },
    );
  }
}
