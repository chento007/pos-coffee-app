import 'package:coffee_app/core/values/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // This is a placeholder login method. Replace with your actual logic.
  Future<void> login(String email, String password) async {
    // Send a POST request to your login API
    final response = await http.post(
      Uri.parse("$BASE_URL/api/auth/login"),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 201) {
      // Assuming response contains 'access' and 'refresh' tokens
      final data = jsonDecode(response.body);
      final accessToken = data['access'];
      final refreshToken = data['refresh'];

      // Store tokens securely
      await _storage.write(key: 'access', value: accessToken);
      await _storage.write(key: 'refresh', value: refreshToken);

      // Navigate to the home page after successful login
      Get.offAllNamed('/home'); // Example route
    } else {
      throw Exception('Login failed');
    }
  }
}
