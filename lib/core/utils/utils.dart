import 'package:coffee_app/app/models/role.dart';

class Utils {
  static String formatMultiRoleName(List<Role> roles) {
    return roles.map((role) => role.name).join(', ');
  }
}
