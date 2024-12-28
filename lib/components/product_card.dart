import 'package:coffee_app/core/utils/screen_type_device.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final String title;
  final String price;
  final String discount;
  final VoidCallback  handleClickAddProduct;

  const ProductCard({
    required this.title,
    required this.price,
    required this.discount,
    required this.handleClickAddProduct,
    super.key,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int quantity = 1;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 2;
    double heightCont = 220;
    double fontSizeTitle = 16;
    double fontSizePrice = 16;
    double imageHeight = 100;
    if (ScreenTypeDevice.isExtraSmall(context)) {
      fontSizeTitle = 12;
      fontSizePrice = 12;
    } else if (ScreenTypeDevice.isPhone(context)) {
    } else if (ScreenTypeDevice.isTablet(context)) {
      crossAxisCount = 2;
    } else if (ScreenTypeDevice.isDesktop(context)) {
      crossAxisCount = 2;
      fontSizePrice = 17;
      heightCont = 290;
      fontSizeTitle = 18;
      imageHeight = 190;
    }

    return InkWell(
      onTap: widget.handleClickAddProduct,
      child: Card(
        elevation: 4,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.all(3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: fontSizeTitle,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.price} \$",
                          style: TextStyle(
                            fontSize: fontSizePrice,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
