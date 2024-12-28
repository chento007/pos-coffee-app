class Role {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool status;

  Role({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.status,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      status: json['status'],
    );
  }
}
