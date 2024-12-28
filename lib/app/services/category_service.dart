import 'dart:convert';
import 'package:coffee_app/app/models/category.dart';
import 'package:coffee_app/app/response/response_item.dart';
import 'package:coffee_app/app/services/auth_interceptor.dart';
import 'package:coffee_app/core/values/constant.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class CategoryService {
  late Dio api;

  CategoryService() {
    api = Dio();
    api.interceptors.add(AuthInterceptor());
  }

  // Update fetchCategories to accept pagination parameters
  Future<ResponseEntity<Category>> fetchCategories({
    int page = 1,
    int take = 10,
    String search = '',
    String order = 'DESC',
  }) async {
    try {
      final response = await api.get(
        '$BASE_URL/api/categories',
        queryParameters: {
          'page': page,
          'take': take,
          'search': search,
          'order': order,
        },
      );

      if (response.statusCode == 200) {
        // Create CategoryResponse from the entire response data
        ResponseEntity<Category> categoryResponse =
            ResponseEntity<Category>.fromJson(
                response.data,
                (json) => Category.fromJson(
                    json as Map<String, dynamic>) // Corrected line
                );

        // Return the CategoryResponse containing categories and metadata
        return categoryResponse;
      } else if (response.statusCode == 401) {
        Get.offAllNamed('/login');
        throw Exception('Unauthorized');
      } else {
        throw Exception('No categories data found in the response');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<bool> createCategory(String name, String description) async {
    var data = json.encode({
      "name": name,
      "description": description,
    });

    final response = await api.post('$BASE_URL/api/categories', data: data);
    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      Get.offAllNamed('/login');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to create category');
    }
  }

  Future<bool> updateStatus(int id) async {
    final response = await api.put('$BASE_URL/api/categories/status/$id');

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      Get.offAllNamed('/login');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to create category');
    }
  }

    Future<bool> update(
    int id,
    String name,
    String description,
  ) async {
    var data = json.encode({
      "name": name,
      "description": description
    });

    final response = await api.put('$BASE_URL/api/categories/$id', data: data);
    print("response created: $response");
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Update product fail');
    }
  }
}
