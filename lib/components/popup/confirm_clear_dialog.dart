import 'package:coffee_app/app/controllers/invoice_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmClearDialog {
  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Confirm Action",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure you want to clear all items? This action cannot be undone.",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.4), // Shadow color
                        offset: Offset(0, 4), // Vertical shadow position
                        blurRadius: 8, // Blur effect
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [Colors.grey, Colors.grey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ), // Gradient effect
                  ),
                  child: Center(
                    // Ensures the text is centered
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Increased font size
                        fontWeight: FontWeight.bold, // Bold for emphasis
                        letterSpacing: 1.2, // Spacing between letters
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.find<InvoiceController>().clearInvoice();
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.redAccent.withOpacity(0.4), // Shadow color
                        offset: Offset(0, 4), // Vertical shadow position
                        blurRadius: 8, // Blur effect
                      ),
                    ],
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.redAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ), // Gradient effect
                  ),
                  child: Center(
                    // Ensures the text is centered
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16, // Increased font size
                        fontWeight: FontWeight.bold, // Bold for emphasis
                        letterSpacing: 1.2, // Spacing between letters
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
