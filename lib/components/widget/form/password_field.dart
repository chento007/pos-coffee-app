import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPasswordVisible;
  final Function(bool) togglePasswordVisibility;
  final bool isConfirmPassword; // To differentiate between password and confirm password field

  const PasswordField({
    Key? key,
    required this.controller,
    required this.label,
    required this.isPasswordVisible,
    required this.togglePasswordVisibility,
    this.isConfirmPassword = false, // Defaults to false for password field
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !widget.isPasswordVisible, // Toggle visibility based on the state
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(
            widget.isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            widget.togglePasswordVisibility(!widget.isPasswordVisible);
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${widget.label} is required';
        }
        if (widget.isConfirmPassword && value != widget.controller.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }
}
