import 'package:coffee_app/app/controllers/invoice_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditOrderItemsDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onUpdate;
  final InvoiceController invoiceController = Get.put(InvoiceController());

  EditOrderItemsDialog({
    super.key,
    required this.onUpdate,
  });

  @override
  _EditOrderItemsDialogState createState() => _EditOrderItemsDialogState();
}

class _EditOrderItemsDialogState extends State<EditOrderItemsDialog> {
  final _formKey = GlobalKey<FormState>();

  final discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                'discount': discountController.text,
              });

              widget.invoiceController.updateOrderAllDiscountItem(
                double.parse(discountController.text),
              );
              widget.invoiceController.update();
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
