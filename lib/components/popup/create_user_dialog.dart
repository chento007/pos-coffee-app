import 'package:coffee_app/app/controllers/category_controller.dart';
import 'package:coffee_app/app/controllers/role_controller.dart';
import 'package:coffee_app/app/controllers/user_controller.dart';
import 'package:coffee_app/app/models/role.dart';
import 'package:coffee_app/components/widget/form/password_field.dart';
import 'package:coffee_app/core/values/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class CreateUserDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const CreateUserDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  _CreateUserDialogState createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final UserController userController = Get.put(UserController());
  final RoleController roleController = Get.put(RoleController());

  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  List<Role> _selectedRoles = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Create New User',
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
                  label: 'Userame',
                  hint: 'Enter username',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: emailController,
                  label: 'Email',
                  hint: 'Enter User email',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: phoneController,
                  label: 'Phone',
                  hint: 'Enter User Phone',
                ),
                const SizedBox(height: 16),
                MultiSelectDialogField<Role>(
                  dialogWidth: 650,
                  dialogHeight: 300,
                  selectedColor: ColorConstant.primary,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorConstant.black),
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
                const SizedBox(height: 16),
                PasswordField(
                  controller: passwordController,
                  label: 'Password',
                  isPasswordVisible: _isPasswordVisible,
                  togglePasswordVisibility: (value) {
                    setState(() {
                      _isPasswordVisible = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                PasswordField(
                  controller: confirmedPasswordController,
                  label: 'Confirmed Password',
                  isPasswordVisible: _isConfirmPasswordVisible,
                  togglePasswordVisibility: (value) {
                    setState(() {
                      _isConfirmPasswordVisible = value;
                    });
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
              widget.onAdd({
                'username': usernameController.text,
                'email': emailController.text,
                'phone': phoneController.text,
                'roles': _selectedRoles.map((role) => role.id).toList(),
                'password': passwordController.text,
                'confirmedPassword': confirmedPasswordController.text,
              });
              await userController.insertUser(
                usernameController.text,
                emailController.text,
                passwordController.text,
                confirmedPasswordController.text,
                phoneController.text,
                _selectedRoles.map((role) => role.id).toList(),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add Item'),
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true, // Hide the text for passwords
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) =>
          value == null || value.isEmpty ? '$label is required' : null,
    );
  }

  Widget _buildConfirmPasswordField({
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
    required String label,
  }) {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: true, // Hide the text for passwords
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        if (value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
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
