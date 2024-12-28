import 'dart:convert';
import 'package:coffee_app/app/models/product.dart';
import 'package:coffee_app/app/response/response_item.dart';
import 'package:coffee_app/app/services/auth_interceptor.dart';
import 'package:coffee_app/core/values/constant.dart';
import 'package:dio/dio.dart';

class ProductService {
  late Dio api;

  ProductService() {
    api = Dio();
    api.interceptors.add(AuthInterceptor());
  }

  // Fetch products with pagination
  Future<ResponseEntity<Product>> fetchProducts({
    int page = 1,
    int take = 10,
    String search = '',
    String order = 'DESC',
  }) async {
    final response = await api.get(
      '$BASE_URL/api/products',
      queryParameters: {
        'page': page,
        'take': take,
        'search': search,
        'order': order,
      },
    );

    if (response.statusCode == 200) {
      ResponseEntity<Product> productResponse =
          ResponseEntity<Product>.fromJson(
        response.data,
        (json) => Product.fromJson(json as Map<String, dynamic>),
      );

      return productResponse;
    } else {
      throw Exception('Error fetching products');
    }
  }

  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final response =
        await api.get('$BASE_URL/api/products/category/$categoryId');
        print("response: ${response.data}");
    if (response.statusCode == 200) {
      var productList = response.data as List;

      List<Product> products =
          productList.map((userJson) => Product.fromJson(userJson)).toList();
      return products;
    } else {
      throw Exception('No users data found in the response');
    }
  }

  Future<bool> updateStatus(int id) async {
    try {
      final response = await api.put('$BASE_URL/api/products/status/$id');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('update status fail');
      }
    } catch (e) {
      print("error: $e");
    }
    return false;
  }

  Future<bool> updatePopular(int id) async {
    try {
      final response = await api.put('$BASE_URL/api/products/popular/$id');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('update status fail');
      }
    } catch (e) {
      print("error: $e");
    }
    return false;
  }

  Future<bool> deleteById(int id) async {
    try {
      final response = await api.delete('$BASE_URL/api/products/$id');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('delete product fail');
      }
    } catch (e) {
      print("error: $e");
    }
    return false;
  }

  Future<bool> insertProduct(
    String name,
    String description,
    double price,
    int categoryId,
  ) async {
    var data = json.encode({
      "name": name,
      "description": description,
      "price": price,
      "categoryId": categoryId,
    });

    final response = await api.post('$BASE_URL/api/products', data: data);
    print("response created: $response");
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('No users data found in the response');
    }
  }

  Future<bool> update(
    int id,
    String name,
    String description,
    double price,
    int categoryId,
  ) async {
    var data = json.encode({
      "name": name,
      "description": description,
      "price": price,
      "categoryId": categoryId,
    });

    final response = await api.put('$BASE_URL/api/products/$id', data: data);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Update product fail');
    }
  }
}
