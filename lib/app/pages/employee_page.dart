import 'package:coffee_app/app/controllers/user_controller.dart';
import 'package:coffee_app/components/popup/create_user_dialog.dart';
import 'package:coffee_app/components/popup/edit_user_dialog.dart';
import 'package:coffee_app/core/utils/utils.dart';
import 'package:coffee_app/core/values/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coffee_app/components/button/button_create_new_item.dart';
import 'package:coffee_app/components/button/icon_button_action.dart';
import 'package:coffee_app/components/button/search_button.dart';

class EmployeePage extends StatelessWidget {
  final UserController userController = Get.put(UserController());

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

  EmployeePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (userController.isLoading.value) {
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
                          userController.search.value = value;
                          userController.fetchUsers();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonCreateNewItem(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => CreateUserDialog(
                                        onAdd:
                                            (Map<String, dynamic> newItemData) {
                                        },
                                      ));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
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
                      value: userController.take.value,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          userController.take.value = newValue;
                          userController.fetchUsers();
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
                const SizedBox(
                  height: 10,
                ),
                Card(
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
                              DataColumn(label: Text('Username')),
                              DataColumn(label: Text('Roles')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Phone')),
                              DataColumn(label: Text('Active')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: List.generate(
                              userController.users.length,
                              (index) => DataRow(
                                cells: [
                                  DataCell(Text(
                                      '${index + 1}')),
                                  DataCell(Text(
                                      userController.users[index].username)),
                                  DataCell(Text(Utils.formatMultiRoleName(
                                      userController.users[index].roles))),
                                  DataCell(
                                      Text(userController.users[index].email)),
                                  DataCell(
                                      Text(userController.users[index].phone)),
                                  DataCell(
                                    Switch.adaptive(
                                      activeColor: ColorConstant.primary,
                                      applyCupertinoTheme: false,
                                      value: userController.users[index].status,
                                      onChanged: (bool value) {
                                        userController.updateStatus(
                                            userController.users[index].id);
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
                                                    EditUserDialog(
                                                      onUpdate:
                                                          (Map<String, dynamic>
                                                              newItemData) {},
                                                      user: userController
                                                          .users[index],
                                                    ));
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: userController.hasPreviousPage.value
                                    ? () {
                                        userController.page.value -= 1;
                                        userController.fetchUsers();
                                      }
                                    : null,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color:
                                          userController.hasPreviousPage.value
                                              ? ColorConstant.border
                                              : Colors.grey,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: userController.hasPreviousPage.value
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
                                    userController.pageCount.value, (index) {
                                  return InkWell(
                                    onTap: () {
                                      userController.page.value = index + 1;
                                      userController.fetchUsers();
                                    },
                                    child: Container(
                                      width: 50,
                                      padding: const EdgeInsets.all(5),
                                      clipBehavior: Clip.hardEdge,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: userController.page.value ==
                                                (index + 1)
                                            ? ColorConstant.primary
                                            : ColorConstant.white,
                                        border: Border.all(
                                          color: userController.page.value ==
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
                                          color: userController.page.value ==
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
                                onTap: userController.hasNextPage.value
                                    ? () {
                                        userController.page.value += 1;
                                        userController.fetchUsers();
                                      }
                                    : null,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: userController.hasNextPage.value
                                          ? ColorConstant.border
                                          : Colors.grey,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: userController.hasNextPage.value
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
}
