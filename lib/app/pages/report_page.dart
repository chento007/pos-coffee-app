import 'package:coffee_app/components/card/sele_card.dart';
import 'package:coffee_app/components/chart/bar_chart.dart';
import 'package:coffee_app/components/chart/line_chart.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String selectedPeriod = 'Today'; // Default selection

  // Example sales data with a timestamp, amount, and quantity
  final List<Map<String, dynamic>> salesData = [
    {
      'amount': 200.0,
      'quantity': 3,
      'timestamp': DateTime(2024, 11, 16, 10, 30)
    }, // Today
    {
      'amount': 150.0,
      'quantity': 2,
      'timestamp': DateTime(2024, 11, 15, 14, 30)
    }, // Yesterday
    {
      'amount': 100.0,
      'quantity': 1,
      'timestamp': DateTime(2024, 11, 10, 16, 00)
    }, // Last week
    {
      'amount': 500.0,
      'quantity': 5,
      'timestamp': DateTime(2024, 10, 31, 13, 30)
    }, // Last month
    {
      'amount': 1000.0,
      'quantity': 10,
      'timestamp': DateTime(2024, 1, 10, 11, 00)
    }, // Last year
  ];

  // Function to calculate total sales and quantity for a specific period
  Map<String, double> calculateSalesAndQuantity(
      DateTime startDate, DateTime endDate) {
    double totalSales = 0;
    double totalQuantity = 0;
    for (var sale in salesData) {
      DateTime saleDate = sale['timestamp'];
      if (saleDate.isAfter(startDate) && saleDate.isBefore(endDate)) {
        totalSales += sale['amount'];
        totalQuantity += sale['quantity'];
      }
    }
    return {
      'sales': totalSales,
      'quantity': totalQuantity,
    };
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    // Date ranges for different periods
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime startOfWeek =
        now.subtract(Duration(days: now.weekday - 1)); // Start of the week
    DateTime startOfMonth =
        DateTime(now.year, now.month, 1); // Start of the month
    DateTime startOfYear = DateTime(now.year, 1, 1); // Start of the year

    // Calculate sales and quantity for each period
    Map<String, double> todayData = calculateSalesAndQuantity(startOfDay, now);
    Map<String, double> weekData = calculateSalesAndQuantity(startOfWeek, now);
    Map<String, double> monthData =
        calculateSalesAndQuantity(startOfMonth, now);
    Map<String, double> yearData = calculateSalesAndQuantity(startOfYear, now);

    Map<String, Map<String, double>> periodData = {
      'Today': todayData,
      'This Week': weekData,
      'This Month': monthData,
      'This Year': yearData,
    };

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text("Hello"),
      // child: SingleChildScrollView(
      //   scrollDirection: Axis.vertical,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       SingleChildScrollView(
      //         scrollDirection: Axis.horizontal,
      //         child: Row(
      //           children: [
      //             SizedBox(
      //               width: 1500,
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 children: [
      //                   const Text(
      //                     "Sales Overview: Today, This Week, This Month, & This Year",
      //                     style: TextStyle(
      //                       fontSize: 24, // Adjust font size for prominence
      //                       fontWeight: FontWeight.bold, // Bold for emphasis
      //                       color: Colors
      //                           .black, // Text color (you can adjust this)
      //                       letterSpacing:
      //                           1.2, // Slight letter spacing for clarity
      //                     ),
      //                     textAlign: TextAlign.center, // Center-align the text
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: [
      //                       SalesCard(
      //                         title: selectedPeriod,
      //                         amount: periodData['Today']?['sales'] ?? 0.0,
      //                         quantity: periodData['Today']?['quantity'] ?? 0.0,
      //                       ),
      //                       const SizedBox(width: 20),
      //                       SalesCard(
      //                         title: 'This Week',
      //                         amount: periodData['This Week']?['sales'] ?? 0.0,
      //                         quantity:
      //                             periodData['This Week']?['quantity'] ?? 0.0,
      //                       ),
      //                       const SizedBox(width: 20),
      //                       SalesCard(
      //                         title: 'This Month',
      //                         amount: periodData['This Month']?['sales'] ?? 0.0,
      //                         quantity:
      //                             periodData['This Month']?['quantity'] ?? 0.0,
      //                       ),
      //                       SizedBox(width: 20),
      //                       SalesCard(
      //                         title: 'This Year',
      //                         amount: periodData['This Year']?['sales'] ?? 0.0,
      //                         quantity:
      //                             periodData['This Year']?['quantity'] ?? 0.0,
      //                       ),
      //                     ],
      //                   ),
      //                   const SizedBox(
      //                     height: 50,
      //                   ),
      //                   const Text(
      //                     "Sales Overview - This Year",
      //                     style: TextStyle(
      //                       fontSize: 24,
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.black,
      //                       letterSpacing: 1.5,
      //                     ),
      //                     textAlign: TextAlign.center,
      //                   ),
      //                   const LineChartSample2(),
      //                   const SizedBox(
      //                     height: 50,
      //                   ),
      //                   const Text(
      //                     "Total Sales of All Products",
      //                     style: TextStyle(
      //                       fontSize: 24, // Adjust font size for prominence
      //                       fontWeight: FontWeight.bold, // Bold for emphasis
      //                       color: Colors
      //                           .black, // Text color (you can adjust this)
      //                       letterSpacing:
      //                           1.2, // Slight letter spacing for clarity
      //                     ),
      //                     textAlign: TextAlign.center, // Center-align the text
      //                   ),
      //                   const BarChartComponent()
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
