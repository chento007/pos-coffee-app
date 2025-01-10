import 'package:coffee_app/app/controllers/category_controller.dart';
import 'package:coffee_app/components/popup/create_category_dialog.dart';
import 'package:coffee_app/components/popup/edit_category.dart';
import 'package:coffee_app/core/values/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coffee_app/components/button/button_create_new_item.dart';
import 'package:coffee_app/components/button/icon_button_action.dart';
import 'package:coffee_app/components/button/search_button.dart';
import 'package:intl/intl.dart';

class CategoryPage extends StatelessWidget {
  final CategoryController categoryController = Get.put(CategoryController());

  final primary = Colors.blue;

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockQtyController = TextEditingController();
  final discountController = TextEditingController();

  final List<int> paginationLimits = [10, 20, 30, 50];
  int selectedLimit = 10;

  bool light = true;
  String? selectedItem;

  CategoryPage({super.key});
  @override
  Widget build(BuildContext context) {
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
                    hintText: "Search Category",
                    onChanged: (value) {
                      categoryController.search.value = value;
                      categoryController.onChangeSearchTitle();
                    },
                  ),
                  ButtonCreateNewItem(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => CreateCategoryDialog(
                                onAdd: (Map<String, dynamic> newItemData) {
                                  print('New Item Data: $newItemData');
                                },
                              ));
                    },
                  ),
                ],
              ),
            ),
            // please drop down here
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Items per page:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 20),
                DropdownButton<int>(
                  value: categoryController.take.value,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      selectedLimit = newValue;
                      categoryController.take.value = newValue;
                      categoryController.updateLimit();
                    }
                  },
                  items:
                      paginationLimits.map<DropdownMenuItem<int>>((int value) {
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
            Obx(
              () {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.all(20),
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Category Name')),
                              DataColumn(label: Text('Description')),
                              DataColumn(label: Text('Created At')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: List.generate(
                              categoryController.categoriesDashboard.length,
                              (index) => DataRow(
                                cells: [
                                  DataCell(Text('${index + 1}')),
                                  DataCell(Text(categoryController
                                      .categoriesDashboard[index].name)),
                                  DataCell(Text(categoryController
                                      .categoriesDashboard[index].description)),
                                  DataCell(
                                    Text(
                                      DateFormat('yyyy-MM-dd').format(
                                        DateTime.parse(categoryController
                                            .categoriesDashboard[index]
                                            .createdAt),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Switch.adaptive(
                                      applyCupertinoTheme: false,
                                      activeColor: ColorConstant.primary,
                                      value: categoryController
                                          .categoriesDashboard[index].status,
                                      onChanged: (bool value) {
                                        categoryController.updateStatus(
                                            categoryController
                                                .categoriesDashboard[index].id);
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
                                                  EditCategoryDialog(
                                                onUpdate: (Map<String, dynamic>
                                                    newItemData) {},
                                                category: categoryController
                                                    .categoriesDashboard[index],
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: categoryController.hasPreviousPage.value
                                    ? () {
                                        categoryController.page.value -= 1;
                                        categoryController
                                            .onChangeSearchTitle();
                                      }
                                    : null,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: categoryController
                                              .hasPreviousPage.value
                                          ? ColorConstant.border
                                          : Colors.grey,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color:
                                        categoryController.hasPreviousPage.value
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
                                    categoryController.pageCount.value,
                                    (index) {
                                  return InkWell(
                                    onTap: () {
                                      categoryController.page.value = index + 1;
                                      categoryController.onChangeSearchTitle();
                                    },
                                    child: Container(
                                      width: 50,
                                      padding: const EdgeInsets.all(5),
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: categoryController.page.value ==
                                                (index + 1)
                                            ? ColorConstant.primary
                                            : ColorConstant.white,
                                        border: Border.all(
                                          color:
                                              categoryController.page.value ==
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
                                          color:
                                              categoryController.page.value ==
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
                                onTap: categoryController.hasNextPage.value
                                    ? () {
                                        categoryController.page.value += 1;
                                        categoryController
                                            .onChangeSearchTitle();
                                      }
                                    : null,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:
                                          categoryController.hasNextPage.value
                                              ? ColorConstant.border
                                              : Colors.grey,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: categoryController.hasNextPage.value
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
                );
              },
            )
          ],
        ),
      ),
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
