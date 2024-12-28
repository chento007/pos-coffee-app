import 'package:coffee_app/app/controllers/category_controller.dart';
import 'package:coffee_app/app/controllers/product_controller.dart';
import 'package:coffee_app/app/models/category.dart';
import 'package:coffee_app/app/models/product.dart'; // Assuming you have a Product model
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProductDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onUpdate;
  final Product product; // The product to be edited

  const EditProductDialog(
      {Key? key, required this.onUpdate, required this.product})
      : super(key: key);

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final ProductController productController = Get.put(ProductController());
  final CategoryController categoryController = Get.put(CategoryController());

  int? selectedCategory;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.product.name;
    descriptionController.text = widget.product.description;
    priceController.text = widget.product.price.toString();
    selectedCategory = widget.product.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit Product',
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
                // Category dropdown with ID as the selected value
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  value: selectedCategory,
                  items: categoryController.categories.map((Category category) {
                    return DropdownMenuItem<int>(
                      value: category.id, // Store the category ID as the value
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Category is required' : null,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: nameController,
                  label: 'Name',
                  hint: 'Enter product name',
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: descriptionController,
                  label: 'Description',
                  hint: 'Enter product description',
                ),
                const SizedBox(height: 12),
                _buildNumericField(
                  controller: priceController,
                  label: 'Price',
                  hint: 'Enter product price',
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
            // Validate all fields before submitting
            if (_formKey.currentState?.validate() ?? false) {
              widget.onUpdate({
                'category':
                    selectedCategory, // This will now be the category ID
                'name': nameController.text,
                'description': descriptionController.text,
                'price': double.tryParse(priceController.text) ?? 0.0,
              });

              productController.updateProduct(
                widget.product.id,
                nameController.text,
                descriptionController.text,
                double.tryParse(priceController.text) ?? 0.0,
                selectedCategory ?? 0,
              );
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

  /// Builds a numeric text field with a label and hint
  Widget _buildNumericField({
    required TextEditingController controller,
    required String label,
    String? hint,
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
        if (value == null || value.isEmpty) {
          return '$label is required';
        } else if (double.tryParse(value) == null) {
          return 'Enter a valid number';
        }
        return null;
      },
    );
  }
}
