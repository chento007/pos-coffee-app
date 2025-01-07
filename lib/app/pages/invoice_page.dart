import 'package:coffee_app/app/controllers/invoice_controller.dart';
import 'package:coffee_app/app/models/invoice-item.dart';
import 'package:coffee_app/components/popup/invoice_list.dart';
import 'package:coffee_app/core/values/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coffee_app/components/button/button_create_new_item.dart';
import 'package:coffee_app/components/button/search_button.dart';
import 'package:coffee_app/components/popup/create_product_dialog.dart';
import 'package:intl/intl.dart';

class InvoicePage extends StatelessWidget {
  final InvoiceController invoiceController = Get.put(InvoiceController());

  final primary = Colors.blue;

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockQtyController = TextEditingController();
  final discountController = TextEditingController();
  bool light = true;
  final List<int> paginationLimits = [10, 20, 30, 50];

  // Category selection
  String? selectedCategory;

  InvoicePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (invoiceController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Items per page:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 20),
                    DropdownButton<int>(
                      value: invoiceController.take.value,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          invoiceController.take.value = newValue;
                          invoiceController.onChangeSearchTitle();
                        }
                      },
                      items: paginationLimits
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: SizedBox(
                              width: 100, child: Center(child: Text('$value'))),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(20),
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Total amount')),
                              DataColumn(label: Text('Discount')),
                              DataColumn(label: Text('Created At')),
                              DataColumn(label: Text('View Items')),
                            ],
                            rows: List.generate(
                              invoiceController.invoiceDashboard.length,
                              (index) => DataRow(
                                cells: [
                                  DataCell(Text(
                                      '${index + 1}')),
                                  DataCell(Text(
                                      "${invoiceController.invoiceDashboard[index].totalAmount}")),
                                  DataCell(Text(
                                      "${invoiceController.invoiceDashboard[index].discount}")),
                                  DataCell(
                                    Text(
                                      DateFormat('yyyy-MM-dd HH:mm').format(
                                        DateTime.parse(invoiceController
                                            .invoiceDashboard[index].createdAt),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.remove_red_eye_rounded,
                                          size:
                                              18), // Smaller icon for better alignment
                                      label: Text(
                                        "View Details",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        elevation: 2, // Subtle shadow effect
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              20), // Rounded corners
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical:
                                                10), // Padding for better spacing
                                      ),
                                      onPressed: () {
                                        showInvoiceItemsDialog(
                                          context,
                                          invoiceController
                                              .invoiceDashboard[index].details,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Pagination controls
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: invoiceController.hasPreviousPage.value
                                    ? () {
                                        invoiceController.page.value -= 1;
                                        invoiceController.onChangeSearchTitle();
                                      }
                                    : null,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: invoiceController
                                              .hasPreviousPage.value
                                          ? ColorConstant.border
                                          : Colors.grey,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color:
                                        invoiceController.hasPreviousPage.value
                                            ? Colors.black
                                            : Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Wrap(
                                spacing: 8.0,
                                children: List.generate(
                                    invoiceController.pageCount.value, (index) {
                                  return InkWell(
                                    onTap: () {
                                      invoiceController.page.value = index + 1;
                                      invoiceController.onChangeSearchTitle();
                                    },
                                    child: Container(
                                      width: 50,
                                      padding: const EdgeInsets.all(5),
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: invoiceController.page.value ==
                                                (index + 1)
                                            ? ColorConstant.primary
                                            : ColorConstant.white,
                                        border: Border.all(
                                          color: invoiceController.page.value ==
                                                  (index + 1)
                                              ? ColorConstant.primary
                                              : ColorConstant.white,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Text(
                                        "${index + 1}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: invoiceController.page.value ==
                                                  (index + 1)
                                              ? ColorConstant.white
                                              : ColorConstant.black,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: invoiceController.hasNextPage.value
                                    ? () {
                                        invoiceController.page.value += 1;
                                        invoiceController.onChangeSearchTitle();
                                      }
                                    : null,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: invoiceController.hasNextPage.value
                                          ? ColorConstant.border
                                          : Colors.grey,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: invoiceController.hasNextPage.value
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  void showInvoiceItemsDialog(
      BuildContext context, List<InvoiceItem> invoiceItems) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invoice Items'),
          content: SizedBox(
            width: double.maxFinite, 
            child: InvoiceItemsWidget(invoiceItems: invoiceItems),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
