import 'package:coffee_app/components/button_quantity.dart';
import 'package:coffee_app/core/utils/screen_type_device.dart';
import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback incrementQuantity;
  final VoidCallback decrementQuantity;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.incrementQuantity,
    required this.decrementQuantity,
  });

  @override
  Widget build(BuildContext context) {
    double widthCont = 125;
    double fontSizePrice = 15;
    double heightBtnQty = 35;
    double widthBtnQty = 35;
    if (ScreenTypeDevice.isExtraSmall(context)) {
      widthCont = 125;
    } else if (ScreenTypeDevice.isPhone(context)) {
      widthCont = 125;
    } else if (ScreenTypeDevice.isTablet(context)) {
      widthCont = 125;
    } else if (ScreenTypeDevice.isDesktop(context)) {
      widthCont = 100;
      widthBtnQty = 30;
      heightBtnQty = 30;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      width: widthCont,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ButtonQuantity(
            icon: Icons.remove,
            onPressed: decrementQuantity,
            width: widthBtnQty,
            height: heightBtnQty,
          ),
          Flexible(
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSizePrice,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ButtonQuantity(
            icon: Icons.add,
            onPressed: incrementQuantity,
            width: widthBtnQty,
            height: heightBtnQty,
          ),
        ],
      ),
    );
  }
}
