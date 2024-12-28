import 'package:coffee_app/app/notification/toast_notification.dart';
import 'package:coffee_app/app/services/auth_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  final AuthService _authService = AuthService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    emailController.text = "john.doe@example.com";
    passwordController.text = "Password@123";
    super.onInit();
  }

  Future<void> login() async {
    print('email: ${emailController.text}');
    print('password: ${passwordController.text}');
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter both email and password');
      return;
    }

    isLoading.value = true;

    try {
      await _authService.login(emailController.text, passwordController.text);

      Get.offAllNamed('/home');

      ToastNotification.success(
        Get.context!,
        title: "Login successfully",
        description: "You have been login successfully.",
      );
    } catch (e) {
      print('error here chento ${e}');
      Get.snackbar('Error', 'Login failed. Please try again.');
      ToastNotification.error(
        Get.context!,
        title: "Login failed",
        description: "Your username or passowrd is incorrect",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    Get.offAllNamed('/login');
  }
}
