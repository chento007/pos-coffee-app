import 'package:coffee_app/app/models/role.dart';

class User {
  final int id;
  final String uuid;
  final String username;
  final String fullname;
  final String phone;
  final String email;
  final String? refresh;
  final List<Role> roles;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt; 
  final bool status;
  User({
    required this.id,
    required this.uuid,
    this.username = '',  
    this.fullname = '',
    this.phone = '',
    required this.email,
    this.refresh = '',
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.status,
  }) : assert(email.isNotEmpty, 'Email cannot be empty'),
       assert(roles.isNotEmpty, 'Roles cannot be empty');

  factory User.fromJson(Map<String, dynamic> json) {
    var roleList = (json['roles'] as List?)
            ?.map((roleJson) => Role.fromJson(roleJson))
            .toList() ?? []; // Defaults to an empty list if 'roles' is null

    DateTime createdAt = DateTime.parse(json['createdAt'] as String);
    DateTime updatedAt = DateTime.parse(json['updatedAt'] as String);
    DateTime? deletedAt = json['deletedAt'] != null ? DateTime.parse(json['deletedAt'] as String) : null;

    return User(
      id: json['id'] as int,                        // Parse ID
      uuid: json['uuid'] as String,                 // Parse UUID
      username: json['username'] as String? ?? '',  // Default empty string if null
      fullname: json['fullname'] as String? ?? '',  // Default empty string if null
      phone: json['phone'] as String? ?? '',        // Default empty string if null
      email: json['email'] as String? ?? '',        // Default empty string if null
      refresh: json['refresh'] as String?,          // Allow null for refresh if it's not in the JSON
      roles: roleList,                              // Safely handles null list
      createdAt: createdAt,                         // Parse createdAt
      updatedAt: updatedAt,                         // Parse updatedAt
      deletedAt: deletedAt,                        // Parse deletedAt (can be null)
            status: json['status'],

    );
  }
}
