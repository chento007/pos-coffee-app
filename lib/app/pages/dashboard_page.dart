import 'package:coffee_app/components/popup/delete_item_dialog.dart';
import 'package:coffee_app/components/popup/edit_product_dialog.dart';
import 'package:coffee_app/core/values/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coffee_app/app/controllers/product_controller.dart';
import 'package:coffee_app/components/button/button_create_new_item.dart';
import 'package:coffee_app/components/button/icon_button_action.dart';
import 'package:coffee_app/components/button/search_button.dart';
import 'package:coffee_app/components/popup/create_product_dialog.dart';

class DashboardPage extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
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

  DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SearchButton(
                        hintText: "Search",
                        onChanged: (value) {
                          // Handle search functionality if needed
                          productController.search.value = value;
                          productController.onChangeSearchTitle();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonCreateNewItem(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => CreateProductDialog(
                                        onAdd:
                                            (Map<String, dynamic> newItemData) {
                                          print('New Item Data: $newItemData');
                                        },
                                      ));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                      value: productController.take.value,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          productController.take.value = newValue;
                          productController.onChangeSearchTitle();
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
                              DataColumn(label: Text('Title')),
                              DataColumn(label: Text('Price (\$)')),
                              DataColumn(label: Text('Category')),
                              DataColumn(label: Text('Description')),
                              DataColumn(label: Text('Popular')),
                              DataColumn(label: Text('Active')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: List.generate(
                              productController.productDashboard.length,
                              (index) => DataRow(
                                cells: [
                                  DataCell(Text(
                                      '${index + 1}')),
                                  DataCell(Text(productController
                                      .productDashboard[index].name)),
                                  DataCell(Text(
                                      "${productController.productDashboard[index].price}")),
                                  DataCell(Text(productController
                                      .productDashboard[index].category.name)),
                                  DataCell(Text(productController
                                      .productDashboard[index].description)),
                                  DataCell(
                                    Switch.adaptive(
                                      applyCupertinoTheme: false,
                                      activeColor: ColorConstant.primary,
                                      value: productController
                                          .productDashboard[index].isPopular,
                                      onChanged: (bool value) {
                                        productController.updatePopular(
                                            productController
                                                .productDashboard[index].id);
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    Switch.adaptive(
                                      activeColor: ColorConstant.primary,
                                      applyCupertinoTheme: false,
                                      value: productController
                                          .productDashboard[index].status,
                                      onChanged: (bool value) {
                                        productController.updateStatus(
                                            productController
                                                .productDashboard[index].id);
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButtonAction(
                                          color: ColorConstant.primary,
                                          icon: Icons.edit,
                                          text: "Edit",
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  EditProductDialog(
                                                product: productController
                                                    .productDashboard[index],
                                                onUpdate: (p0) {},
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        IconButtonAction(
                                          color: ColorConstant.danger,
                                          icon: Icons.delete_outline,
                                          text: "Delete",
                                          onTap: () {
                                            // Show the delete confirmation dialog
                                            showDialog(
                                              context: context,
                                              builder: (_) => DeleteItemDialog(
                                                index: productController
                                                    .productDashboard[index].id,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
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
                                onTap: productController.hasPreviousPage.value
                                    ? () {
                                        productController.page.value -= 1;
                                        productController.onChangeSearchTitle();
                                      }
                                    : null,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: productController
                                              .hasPreviousPage.value
                                          ? ColorConstant.border
                                          : Colors.grey,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color:
                                        productController.hasPreviousPage.value
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
                                    productController.pageCount.value, (index) {
                                  return InkWell(
                                    onTap: () {
                                      productController.page.value = index + 1;
                                      productController.onChangeSearchTitle();
                                    },
                                    child: Container(
                                      width: 50,
                                      padding: const EdgeInsets.all(5),
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: productController.page.value ==
                                                (index + 1)
                                            ? ColorConstant.primary
                                            : ColorConstant.white,
                                        border: Border.all(
                                          color: productController.page.value ==
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
                                          color: productController.page.value ==
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
                                onTap: productController.hasNextPage.value
                                    ? () {
                                        productController.page.value += 1;
                                        productController.onChangeSearchTitle();
                                      }
                                    : null,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: productController.hasNextPage.value
                                          ? ColorConstant.border
                                          : Colors.grey,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: productController.hasNextPage.value
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
}
