import 'package:coffee_app/app/models/role.dart';
import 'package:coffee_app/app/response/response_item.dart';
import 'package:coffee_app/app/services/auth_interceptor.dart';
import 'package:coffee_app/core/values/constant.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class RoleService extends GetConnect {
  late Dio api;

  RoleService() {
    api = Dio();
    api.interceptors.add(AuthInterceptor());
  }

  Future<ResponseEntity<Role>> fetchRoles({
    int page = 1,
    int take = 10,
    String search = '',
    String order = 'DESC',
  }) async {
    final response = await api.get(
      '$BASE_URL/api/roles',
      queryParameters: {
        'page': page,
        'take': take,
        'search': search,
        'order': order,
      },
    );
    if (response.statusCode == 200) {
      ResponseEntity<Role> userResponse = ResponseEntity<Role>.fromJson(
          response.data,
          (json) =>
              Role.fromJson(json as Map<String, dynamic>)
          );
      return userResponse;
    } else {
      throw Exception('Error fetching users data: ${response.statusCode}');
    }
  }
}
