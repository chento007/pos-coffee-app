import 'dart:ui';

import 'package:coffee_app/app/controllers/invoice_controller.dart';
import 'package:coffee_app/core/values/color_const.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:get/get.dart';

class CurrentDateTimeAction extends StatefulWidget {
  const CurrentDateTimeAction({Key? key}) : super(key: key);

  @override
  _CurrentDateTimeActionState createState() => _CurrentDateTimeActionState();
}

class _CurrentDateTimeActionState extends State<CurrentDateTimeAction> {
  final InvoiceController invoiceController = Get.put(InvoiceController());

  late String _currentDateTime;
  late Timer _timer;
  bool isPasswordVerified = false;
  bool showPrice = false; // New state to toggle visibility
  final passwordController = TextEditingController();
  String correctPassword = "TwoBean*2025#";
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
    return Obx(() => Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
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
                    Icons.monetization_on_rounded,
                    color: ColorConstant.warning,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (!isPasswordVerified) {
                            // Show password dialog if not verified yet
                            _showPasswordDialog(context);
                          } else {
                            // Toggle price visibility if already verified
                            setState(() {
                              showPrice = !showPrice;
                              isPasswordVerified = !showPrice;
                            });
                          }
                        },
                        child: Container(
                          child: isPasswordVerified && showPrice
                              ? Text(
                                  // Show actual price if verified & toggled
                                  'Checkout ABA ${invoiceController.salesData.value?.byABA} \$',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.warning,
                                  ),
                                )
                              : Stack(
                                  // Show blurred price otherwise
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      // Hidden (transparent) text to maintain layout
                                      'Checkout ABA ${invoiceController.salesData.value?.byABA} \$',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white.withOpacity(0.1),
                                      child: Text(
                                        'Checkout ABA **** \$',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant.warning,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
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
                    Icons.monetization_on_rounded,
                    color: ColorConstant.warning,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (!isPasswordVerified) {
                            // Show password dialog if not verified yet
                            _showPasswordDialog(context);
                          } else {
                            // Toggle price visibility if already verified
                            setState(() {
                              showPrice = !showPrice;
                              isPasswordVerified = !showPrice;
                            });
                          }
                        },
                        child: Container(
                          child: isPasswordVerified && showPrice
                              ? Text(
                                  // Show actual price if verified & toggled
                                  'Checkout Cash ${invoiceController.salesData.value?.byCash} \$',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.warning,
                                  ),
                                )
                              : Stack(
                                  // Show blurred price otherwise
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      // Hidden (transparent) text to maintain layout
                                      'Checkout Cash ${invoiceController.salesData.value?.byABA} \$',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white.withOpacity(0.1),
                                      child: Text(
                                        'Checkout Cash **** \$',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant.warning,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
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
                    Icons.monetization_on_rounded,
                    color: ColorConstant.warning,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (!isPasswordVerified) {
                            // Show password dialog if not verified yet
                            _showPasswordDialog(context);
                          } else {
                            // Toggle price visibility if already verified
                            setState(() {
                              showPrice = !showPrice;
                              isPasswordVerified = !showPrice;
                            });
                          }
                        },
                        child: Container(
                          child: isPasswordVerified && showPrice
                              ? Text(
                                  // Show actual price if verified & toggled
                                  'Today\'s sales: ${invoiceController.salesData.value?.today} \$',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstant.warning,
                                  ),
                                )
                              : Stack(
                                  // Show blurred price otherwise
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      // Hidden (transparent) text to maintain layout
                                      'Today\'s sales: ${invoiceController.salesData.value?.today} \$',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white.withOpacity(0.1),
                                      child: Text(
                                        'Today\'s sales: **** \$',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: ColorConstant.warning,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
  
            Container(
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
                  Row(
                    children: [
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
                ],
              ),
            ),
          ],
        ));
  }

  void _showPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enter Password"),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(hintText: "Password"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (passwordController.text == correctPassword) {
                setState(() {
                  isPasswordVerified = true;
                  showPrice =
                      true;
                      passwordController.text= '';
                });
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Incorrect password")),
                );
              }
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }
}
