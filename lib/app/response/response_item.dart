class ResponseEntity<T> {
  final List<T> items; // Generic type list
  final int itemCount;
  final int pageCount;
  final bool hasPreviousPage;
  final bool hasNextPage;

  ResponseEntity({
    required this.items,
    required this.itemCount,
    required this.pageCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  // From JSON
  factory ResponseEntity.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return ResponseEntity<T>(
     items: (json['data'] as List)
          .map((e) => fromJsonT(e as Map<String,
              dynamic>)) // Cast each item to Map<String, dynamic>
          .toList(), 
      itemCount: json['meta']['itemCount'] ?? 0,
      pageCount: json['meta']['pageCount'] ?? 0,
      hasPreviousPage: json['meta']['hasPreviousPage'] ?? false,
      hasNextPage: json['meta']['hasNextPage'] ?? false,
    );
  }

  // To JSON
  Map<String, dynamic> toJson(T Function(T item) toJsonT) {
    return {
      'data': items.map((e) => toJsonT(e)).toList(),
      'meta': {
        'itemCount': itemCount,
        'pageCount': pageCount,
        'hasPreviousPage': hasPreviousPage,
        'hasNextPage': hasNextPage,
      }
    };
  }
}
