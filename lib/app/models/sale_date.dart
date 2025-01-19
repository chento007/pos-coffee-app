class SalesData {
  final String today;
  final String thisWeek;
  final String thisMonth;
  final String thisYear;
  final String byCash;
  final String byABA;

  // Constructor
  SalesData({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.thisYear,
    required this.byCash,
    required this.byABA,
  });

  // Factory constructor for JSON deserialization
  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      today: json['today'] ?? '',
      thisWeek: json['thisWeek'] ?? '',
      thisMonth: json['thisMonth'] ?? '',
      thisYear: json['thisYear'] ?? '',
      byCash: json['byCash'] ?? '',
      byABA: json['byABA'] ?? '',
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'today': today,
      'thisWeek': thisWeek,
      'thisMonth': thisMonth,
      'thisYear': thisYear,
      'byCash': byCash,
      'byABA': byABA,
    };
  }
}
