import 'package:coffee_app/app/controllers/invoice_controller.dart';
import 'package:coffee_app/components/calculator/calculator.dart';
import 'package:coffee_app/components/popup/keyboard_input_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CashInputDialog extends StatefulWidget {
  final Function(String dollar, String riel) onConfirm;
  final double totalDollar;
  final String totalRiel;

  const CashInputDialog({
    Key? key,
    required this.onConfirm,
    required this.totalDollar,
    required this.totalRiel,
  }) : super(key: key);

  @override
  State<CashInputDialog> createState() => _CashInputDialogState();
}

class _CashInputDialogState extends State<CashInputDialog> {
  final TextEditingController dollarController = TextEditingController();
  final TextEditingController rielController = TextEditingController();
  final NumberFormat formatter = NumberFormat("#,###");

  double exchangeRate = 4100.0;

  double totalInRiel = 0.0;
  double totalInDollar = 0.0;

  double changeDollar = 0.0;
  double changeRiel = 0.0;
  bool isKeyboardDollar = true;

  void calculateTotals() {
    double inputDollar = double.tryParse(dollarController.text) ?? 0.0;
    double inputRiel = double.tryParse(
          rielController.text.replaceAll(",", ""),
        ) ??
        0.0;

    setState(() {
      totalInRiel = (inputDollar * exchangeRate) + inputRiel;
      totalInDollar = totalInRiel / exchangeRate;
      changeDollar = totalInDollar - widget.totalDollar;
      changeRiel = changeDollar * exchangeRate;
    });
  }

  void formatRielInput(String value) {
    String cleanedValue = value.replaceAll(",", ""); // Remove existing commas
    String formattedValue =
        formatter.format(int.tryParse(cleanedValue) ?? 0); // Format the input
    rielController.value = TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
    calculateTotals();
  }

  void updateDollarInput(String value) {
    setState(() {
      calculateTotals();
      if (value == "Clear") {
        dollarController.clear(); // Clear input
      } else if (value == "." && dollarController.text.contains(".")) {
        return; // Prevent multiple decimals
      } else {
        dollarController.text += value;
      }
    });
  }

  void updateRielInput(String value) {
    setState(() {
      if (value == "X") {
        rielController.clear();
      } else {
        rielController.text += value;
      }
      formatRielInput(rielController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 800,
        height: 600,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Enter Payment",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      'Cash in Dollar (៛)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isKeyboardDollar = true;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              color:
                                  isKeyboardDollar ? Colors.blue : Colors.grey),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              dollarController.text,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cash in Riel (៛)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isKeyboardDollar = false;
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              color: !isKeyboardDollar
                                  ? Colors.blue
                                  : Colors.grey),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              rielController.text,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Display Total in Riel and Dollar
                    Column(
                      children: [
                        Text(
                          "Total Dollar: \$${widget.totalDollar.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Total Riel: ៛${widget.totalRiel}",
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recived in Dollar: \$${dollarController.text}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Recived in Riel: ៛${rielController.text}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Total Recived: ៛${totalInDollar.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Change in Dollar: \$ ${changeDollar.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Change in Riel: ៛${formatter.format(changeRiel)}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text(
                            "Cancel",
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 16),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (dollarController.text.isEmpty &&
                                rielController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Please enter cash in Dollar or Riel!"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            Get.find<InvoiceController>().checkout();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Checkout",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: NumberPad(
                onNumberPress: (value) {
                  if (isKeyboardDollar) {
                    updateDollarInput(value);
                  } else {
                    updateRielInput(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
