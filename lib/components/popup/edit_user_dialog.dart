import 'package:coffee_app/app/controllers/role_controller.dart';
import 'package:coffee_app/app/controllers/user_controller.dart';
import 'package:coffee_app/app/models/category.dart';
import 'package:coffee_app/app/models/role.dart';
import 'package:coffee_app/app/models/user.dart';
import 'package:coffee_app/core/values/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class EditUserDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onUpdate;
  final User user;

  const EditUserDialog({Key? key, required this.onUpdate, required this.user})
      : super(key: key);

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final UserController userController = Get.put(UserController());
  final RoleController roleController = Get.put(RoleController());

  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  List<Role> _selectedRoles = [];

  int? selectedCategory;

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.user.username;
    emailController.text = widget.user.email;
    phoneController.text = widget.user.phone;
    _selectedRoles = widget.user.roles
        .map((userRole) =>
            roleController.roles.firstWhere((role) => role.id == userRole.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Edit User',
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
                _buildTextField(
                  controller: usernameController,
                  label: 'Username',
                  hint: 'Enter User Username',
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Enter user email',
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: phoneController,
                  label: 'Phone',
                  hint: 'Enter user phone',
                ),
                const SizedBox(height: 12),
                MultiSelectDialogField<Role>(
                  selectedColor: ColorConstant.primary,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorConstant.primary),
                  ),
                  items: roleController.roles.map((role) {
                    return MultiSelectItem<Role>(role, role.name);
                  }).toList(),
                  initialValue: _selectedRoles,
                  title: const Text("Roles"),
                  buttonText: const Text("Select Roles"),
                  onSelectionChanged: (p0) {
                    _selectedRoles = p0;
                  },
                  onConfirm: (values) {
                    setState(() {
                      _selectedRoles = values;
                    });
                  },
                  validator: (values) {
                    if (values == null || values.isEmpty) {
                      return "Please select at least one category";
                    }
                    return null;
                  },
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
                'username': usernameController.text,
                'email': emailController.text,
                'phone': phoneController.text,
                'roles': _selectedRoles.map((role) => role.id).toList(),
              });

              await userController.updateUser(
                widget.user.id,
                usernameController.text,
                phoneController.text,
                emailController.text,
                _selectedRoles.map((role) => role.id).toList(),
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
