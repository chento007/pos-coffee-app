import 'package:flutter/material.dart';
import 'dart:async';

class CurrentDateTimeAction extends StatefulWidget {
  const CurrentDateTimeAction({Key? key}) : super(key: key);

  @override
  _CurrentDateTimeActionState createState() => _CurrentDateTimeActionState();
}

class _CurrentDateTimeActionState extends State<CurrentDateTimeAction> {
  late String _currentDateTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    // Update the time every 30 seconds
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      _updateDateTime();
    });
  }

  // Method to get the current date and time
  void _updateDateTime() {
    setState(() {
      final now = DateTime.now();
      _currentDateTime = "${now.toLocal().day.toString().padLeft(2, '0')}-"
          "${(now.month).toString().padLeft(2, '0')}-${now.year} "
          " ${now.hour.toString().padLeft(2, '0')}:" 
          "${now.minute.toString().padLeft(2, '0')} ";
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            color: Colors.blue.shade700,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Today: $_currentDateTime',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
