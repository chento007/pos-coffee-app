import 'dart:convert';

import 'package:coffee_app/app/response/response_item.dart';
import 'package:coffee_app/app/services/auth_interceptor.dart';
import 'package:coffee_app/core/values/constant.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:coffee_app/app/models/user.dart';

class UserService extends GetConnect {
  late Dio api;

  UserService() {
    api = Dio();
    api.interceptors.add(AuthInterceptor());
  }

  Future<ResponseEntity<User>> fetchUsers({
    int page = 1,
    int take = 10,
    String search = '',
    String order = 'DESC',
  }) async {
    final response = await api.get(
      '$BASE_URL/api/users',
      queryParameters: {
        'page': page,
        'take': take,
        'search': search,
        'order': order,
      },
    );
    if (response.statusCode == 200) {
      ResponseEntity<User> userResponse = ResponseEntity<User>.fromJson(
          response.data, (json) => User.fromJson(json as Map<String, dynamic>));
      return userResponse;
    } else {
      throw Exception('Error fetching users data: ${response.statusCode}');
    }
  }

  Future<bool> update(int id, String username, String phone, String email,
      List<int> roleIds) async {
    var data = json.encode({
      "username": username,
      "phone": phone,
      "email": email,
      "roleIds": roleIds
    });

    final response = await api.put('$BASE_URL/api/users/$id', data: data);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Update user fail');
    }
  }

  Future<bool> insertUser(
    String username,
    String email,
    String password,
    String confirmedPassword,
    String phone,
    List<int> roleIds,
  ) async {
    try {
      var data = json.encode({
        "username": username,
        "phone": phone,
        "email": email,
        "roleIds": roleIds,
        "password": password,
        "confirmedPassword": confirmedPassword,
      });

      final response = await api.post('$BASE_URL/api/users', data: data);
      print("response: ${response.statusCode}");
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('No users data found in the response');
      }
    } catch (e) {
      print("error : $e");
      throw Exception('update status fail $e');
    }
  }

  Future<bool> updateStatus(int id) async {
    try {
      final response = await api.put('$BASE_URL/api/users/status/$id');

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
}
