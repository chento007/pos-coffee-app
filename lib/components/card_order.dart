import 'package:coffee_app/core/values/color_const.dart';
import 'package:flutter/material.dart';
import 'package:coffee_app/app/models/invoice_detail.dart';
import 'package:coffee_app/components/quantity_selector.dart';

class CardOrder extends StatelessWidget {
  final InvoiceDetail invoiceDetail;
  final int qty;
  final VoidCallback handleRemoveItem;
  final VoidCallback incrementQuantity;
  final VoidCallback decrementQuantity;
  final VoidCallback handleEdit;

  const CardOrder(
      {super.key,
      required this.invoiceDetail,
      required this.handleRemoveItem,
      required this.incrementQuantity,
      required this.qty,
      required this.decrementQuantity,
      required this.handleEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              invoiceDetail.product.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: handleRemoveItem,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFF45A58),
                              borderRadius: BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "\$ ${invoiceDetail.unitPrice}  ",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "( Discount ${invoiceDetail.discount}% )",
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstant.discount),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                  ColorConstant.discount),
                            ),
                            onPressed: handleEdit,
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: ColorConstant.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: ColorConstant.white,
                                  ),
                                ),
                              ],
                            )),
                        QuantitySelector(
                          quantity: qty,
                          incrementQuantity: incrementQuantity,
                          decrementQuantity: decrementQuantity,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
