import 'package:coffee_app/app/controllers/invoice_controller.dart';
import 'package:coffee_app/components/button/button_order_product.dart';
import 'package:coffee_app/components/card_order.dart';
import 'package:coffee_app/components/popup/cashInputDialog.dart';
import 'package:coffee_app/components/popup/confirm_check_out_aba.dart';
import 'package:coffee_app/components/popup/confirm_clear_dialog.dart';
import 'package:coffee_app/components/popup/edit_order_item_dialog.dart';
import 'package:coffee_app/components/popup/edit_order_items_dialog.dart';
import 'package:coffee_app/core/utils/screen_type_device.dart';
import 'package:coffee_app/core/values/color_const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderProduct extends StatelessWidget {
  final InvoiceController invoiceController = Get.put(InvoiceController());

  @override
  Widget build(BuildContext context) {
    // Determine the screen type
    final isPhone = ScreenTypeDevice.isPhone(context);
    final isTablet = ScreenTypeDevice.isTablet(context);
    final isDesktop = ScreenTypeDevice.isDesktop(context);

    // Dynamic values for responsive design
    final double padding = isPhone
        ? 4.0 // Further reduced from 6.0
        : isTablet
            ? 8.0 // Further reduced from 10.0
            : isDesktop
                ? 10.0 // Further reduced from 12.0
                : 2.0; // Further reduced for extra small devices from 3.0

    final double fontSize = isPhone
        ? 10.0 // Further reduced from 12.0
        : isTablet
            ? 12.0 // Further reduced from 14.0
            : isDesktop
                ? 14.0 // Further reduced from 16.0
                : 8.0; // Further reduced for extra small devices from 10.0

    return Obx(() {
      return Center(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: invoiceController.invoiceDetails.length,
                  itemBuilder: (context, index) => CardOrder(
                    order: index + 1,
                    qty: invoiceController.invoiceDetails[index].quantity,
                    handleRemoveItem: () {
                      invoiceController.removeInvoiceDetail(
                          invoiceController.invoiceDetails[index]);
                    },
                    invoiceDetail: invoiceController.invoiceDetails[index],
                    decrementQuantity: () {
                      invoiceController.decreaseQuantity(index);
                    },
                    incrementQuantity: () {
                      invoiceController.increaseQuantity(index);
                    },
                    handleEdit: () {
                      showDialog(
                        context: context,
                        builder: (context) => EditOrderItemDialog(
                          index: index,
                          discount:
                              invoiceController.invoiceDetails[index].discount,
                          price:
                              invoiceController.invoiceDetails[index].unitPrice,
                          onUpdate: (p0) {},
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.all(padding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFFECEBE9),
                    width: isPhone ? 2.0 : (isTablet ? 3.0 : 4.0),
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Subtotal section
                    _buildSummaryRow(
                      "Sub total",
                      "\$ ${invoiceController.getSubTotal()}",
                      fontSize,
                    ),
                    SizedBox(height: isPhone ? 8 : 12),
                    // Discount section
                    _buildSummaryRow(
                      "Discount amount",
                      "\$ ${invoiceController.getDiscountAmount()}",
                      fontSize,
                    ),
                    Divider(color: Colors.black),
                    SizedBox(height: isPhone ? 8 : 12),
                    // Total payment in USD
                    _buildSummaryRow(
                      "Total Payment Dollar (\$)",
                      "\$ ${invoiceController.getTotalPaymentUSD()}",
                      fontSize,
                    ),
                    // Total payment in Riel
                    _buildSummaryRow(
                      "Total Payment Riel  (\៛)",
                      "${invoiceController.getTotalPaymentRiel()}",
                      fontSize,
                    ),
                    SizedBox(height: isPhone ? 16 : 24),
                    _buildButtonRow(context, isPhone, isTablet, isDesktop),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Helper widget to build a row for summary items
  Widget _buildSummaryRow(String label, String value, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // Helper widget to build action buttons
  Widget _buildButtonRow(
      BuildContext context, bool isPhone, bool isTablet, bool isDesktop) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ButtonOrderProduct(
                onPressed: () {
                  // Show confirmation dialog
                  ConfirmClearDialog.show(context);
                },
                title: "Clear all",
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                ),
                buttonColor: Colors.redAccent,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: ButtonOrderProduct(
                buttonColor: ColorConstant.warning,
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => EditOrderItemsDialog(
                      onUpdate: (p0) {},
                    ),
                  );
                },
                title: "Discount all",
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            invoiceController.invoiceDetails.isNotEmpty
                ? Expanded(
                    child: ButtonOrderProduct(
                      buttonColor: ColorConstant.saveGreen,
                      icon: Icon(Icons.price_check_rounded),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => CashInputDialog(
                            totalDollar: invoiceController.getTotalPaymentUSD(),
                            totalRiel: invoiceController.getTotalPaymentRiel(),
                            onConfirm: (dollar, riel) {
                              // Handle the confirmed input values
                              print("Dollar: $dollar, Riel: $riel");
                            },
                          ),
                        );
                      },
                      title: "Checkout Cash",
                    ),
                  )
                : const SizedBox(),
            SizedBox(
              width: 10,
            ),
            invoiceController.invoiceDetails.isNotEmpty
                ? Expanded(
                    child: ButtonOrderProduct(
                      buttonColor: ColorConstant.saveGreen,
                      icon: Icon(Icons.sim_card_rounded),
                      onPressed: () {
                        ConfirmCheckOutAba.show(context);
                      },
                      title: "Checkout ABA",
                    ),
                  )
                : SizedBox(),
          ],
        ),
        // Fallback if no invoice details

        const SizedBox(height: 10),
      ],
    );
  }
}
