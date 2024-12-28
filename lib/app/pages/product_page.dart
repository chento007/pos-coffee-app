import 'package:coffee_app/app/controllers/product_controller.dart';
import 'package:coffee_app/app/controllers/user_controller.dart';
import 'package:coffee_app/app/models/product.dart';
import 'package:coffee_app/components/product_card.dart';
import 'package:coffee_app/core/utils/screen_type_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class ProductPage extends StatelessWidget {

  final ProductController productController = Get.put(ProductController());
  final UserController userController = Get.put(UserController());
  final VoidCallback  handleClickAddProduct;
  final List<Product> products;
  final bool isLoading;
  
  ProductPage({
    super.key,
    required this.handleClickAddProduct,
    required this.products,
    required this.isLoading
  });
  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 2;
    if (ScreenTypeDevice.isExtraSmall(context)) {
    } else if (ScreenTypeDevice.isPhone(context)) {
    } else if (ScreenTypeDevice.isTablet(context)) {
      crossAxisCount = 3;
    } else if (ScreenTypeDevice.isDesktop(context)) {
      crossAxisCount = 4;
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
              flex: 12,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Obx(() {
                  if (isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (products.isEmpty) {
                    return const Center(
                      child: Text('No products available'),
                    );
                  }

                  return AlignedGridView.count(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Padding(
                        padding: const EdgeInsets.all(0),
                        child: ProductCard(
                          handleClickAddProduct: handleClickAddProduct,
                          title: product.name,
                          price: product.price.toString(),
                          discount: product.name.toString(),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
