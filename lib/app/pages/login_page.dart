import 'package:coffee_app/app/controllers/auth_controller.dart';
import 'package:coffee_app/core/values/color_const.dart';
import 'package:coffee_app/core/values/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorConstant.primary,
        centerTitle: true,
      ),
      body: SizedBox(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo or App Name
                const Icon(
                  Icons.local_cafe,
                  size: 100,
                  color: ColorConstant.primary,
                ),
                const SizedBox(height: 20),
                const Text(
                  PROJECT_NAME,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.primary,
                  ),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  width: 700,
                  child: TextField(
                    controller: authController.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: ColorConstant.primary),
                      hintText: 'Enter your email',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: Icon(
                        Icons.email,
                        color: ColorConstant.primary,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: 20),

                // Password TextField with Icons and Custom Style
                SizedBox(
                  width: 700,
                  child: TextField(
                    controller: authController.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: ColorConstant.primary),
                      hintText: 'Enter your password',
                      hintStyle: TextStyle(color: ColorConstant.primary),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: ColorConstant.primary,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Loading Indicator or Login Button
                Obx(() {
                  return authController.isLoading.value
                      ? CircularProgressIndicator(
                          color: ColorConstant.primary,
                        )
                      : ElevatedButton(
                          onPressed: authController.login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstant.primary,
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.white,
                            ),
                          ),
                        );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
