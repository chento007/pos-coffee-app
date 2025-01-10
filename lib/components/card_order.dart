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
  final int order;

  const CardOrder(
      {super.key,
      required this.order,
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
        padding: const EdgeInsets.all(3),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            "${order}. ${invoiceDetail.product.name} ",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "\$ ${invoiceDetail.unitPrice} (${invoiceDetail.discount}%)",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
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
                                size: 18,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: handleEdit,
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                              bottom: 5
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: ColorConstant.white,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Edit",
                                  style: TextStyle(
                                    color: ColorConstant.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
