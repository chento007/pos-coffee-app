class SalesData {
  final String today;
  final String thisWeek;
  final String thisMonth;
  final String thisYear;

  // Constructor
  SalesData({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.thisYear,
  });

  // Factory constructor for JSON deserialization
  factory SalesData.fromJson(Map<String, dynamic> json) {
    return SalesData(
      today: json['today'] ?? '',
      thisWeek: json['thisWeek'] ?? '',
      thisMonth: json['thisMonth'] ?? '',
      thisYear: json['thisYear'] ?? '',
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'today': today,
      'thisWeek': thisWeek,
      'thisMonth': thisMonth,
      'thisYear': thisYear,
    };
  }
}
