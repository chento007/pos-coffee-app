import 'package:coffee_app/app/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class DeleteItemDialog extends StatelessWidget {
  final int index;
  final ProductController productController = Get.put(ProductController());

  DeleteItemDialog({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Deletion'),
      content: const Text('Are you sure you want to delete this item?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();  // Close the dialog without deleting
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            productController.deleteById(index);
            Navigator.of(context).pop();  // Close the dialog after deletion
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
