import 'package:coffee_app/app/controllers/invoice_controller.dart';
import 'package:coffee_app/app/models/category.dart';
import 'package:coffee_app/app/models/invoice_detail.dart';
import 'package:coffee_app/app/pages/category_page.dart';
import 'package:coffee_app/app/pages/invoice_page.dart';
import 'package:coffee_app/app/pages/role_page.dart';
import 'package:coffee_app/components/widget/dropdown_employee_management.dart';
import 'package:coffee_app/components/widget/dropdown_product_management.dart';
import 'package:coffee_app/core/values/color_const.dart';
import 'package:coffee_app/core/values/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:coffee_app/app/controllers/category_controller.dart';
import 'package:coffee_app/app/controllers/product_controller.dart';
import 'package:coffee_app/app/controllers/user_controller.dart';
import 'package:coffee_app/app/pages/dashboard_page.dart';
import 'package:coffee_app/app/pages/employee_page.dart';
import 'package:coffee_app/app/pages/report_page.dart';
import 'package:coffee_app/components/order_product.dart';
import 'package:coffee_app/components/product_card.dart';
import 'package:coffee_app/components/text/current_date_action.dart';
import 'package:coffee_app/core/utils/screen_type_device.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int selected = 0;
  final PageController _pageController = PageController();
  final ProductController productController = Get.put(ProductController());
  final UserController userController = Get.put(UserController());
  final CategoryController categoryController = Get.put(CategoryController());
  final InvoiceController invoiceController = Get.put(InvoiceController());
  TabController? _tabController;

  final _selectedColor = const Color(0xff1a73e8);
  final _unselectedColor = const Color(0xff5f6368);

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    ever(categoryController.categories, (List<Category> categories) {
      if (categories.isNotEmpty) {
        productController.fetchProductsByCategory(categories.first.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int crossAxisCount = _calculateCrossAxisCount(context);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(() => _buildBody(crossAxisCount)),
      drawer: _buildDrawer(),
    );
  }

  /// Calculates cross-axis count based on device type.
  int _calculateCrossAxisCount(BuildContext context) {
    if (ScreenTypeDevice.isExtraSmall(context)) return 2;
    if (ScreenTypeDevice.isPhone(context)) return 2;
    if (ScreenTypeDevice.isTablet(context)) return 3;
    return 4; // For Desktop
  }

  /// Builds the app bar with title and actions.
  AppBar _buildAppBar() {
    return AppBar(
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            PROJECT_NAME,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: const [CurrentDateTimeAction()],
      centerTitle: true,
      backgroundColor: ColorConstant.primary,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  /// Builds the body of the page.
  Widget _buildBody(int crossAxisCount) {
    if (categoryController.isLoading.value ||
        productController.isLoading.value ||
        userController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categoryController.categories.isEmpty) {
      return const Center(child: Text('No products available'));
    } else {
      _tabController = TabController(
        length: categoryController.categories.length,
        vsync: this,
      );
    }
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {},
      children: [
        _buildProductTabView(crossAxisCount),
        const ReportPage(),
        DashboardPage(),
        CategoryPage(),
        InvoicePage(),
        EmployeePage(),
        RolePage()
      ],
    );
  }

  /// Builds the product tab view.
  Widget _buildProductTabView(int crossAxisCount) {
    final List<Tab> tabs = categoryController.categories
        .map((element) => Tab(text: element.name))
        .toList();

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(
          () {
            return SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      color: const Color(0xFFECEBE9),
                      child: Column(
                        children: [
                          TabBar(
                            controller: _tabController,
                            tabs: tabs,
                            labelColor: _selectedColor,
                            indicatorColor: _selectedColor,
                            unselectedLabelColor: _unselectedColor,
                            onTap: (value) {
                              productController.fetchProductsByCategory(
                                  categoryController.categories[value].id);
                            },
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: categoryController.categories
                                  .map((category) => _buildProductGridView(
                                        category,
                                        crossAxisCount,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: SizedBox(child: OrderProduct()),
                  ),
                ],
              ),
            );
          },
        ));
  }

  /// Builds a grid view for products.
  Widget _buildProductGridView(Category category, int crossAxisCount) {
    return Obx(() {
      // Show loading indicator if still loading
      if (productController.isProductByCategoryLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      // Show error message if there was an error
      if (productController.hasError.value) {
        return Center(
          child: Text(
            'An error occurred: ${productController.errorMessage.value}',
          ),
        );
      }

      // Show message if no products are available
      if (productController.products.isEmpty) {
        return const Center(child: Text("No product available"));
      }

      // Show the grid of products
      return AlignedGridView.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemCount: productController.products.length,
        itemBuilder: (context, index) {
          final product = productController.products[index];
          return ProductCard(
            handleClickAddProduct: () {
              invoiceController.addInvoiceDetail(
                  InvoiceDetail(
                    id: 1,
                    quantity: 1,
                    discount: 0.0,
                    unitPrice: product.price,
                    subTotal: product.price,
                    product: product,
                  ),
                  index);
            },
            title: product.name,
            price: product.price.toString(),
            discount: product.name,
          );
        },
      );
    });
  }

  /// Builds the navigation drawer.
  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: ColorConstant.primary,
            ),
            accountName: const Text(
              "Chea Chento",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: const Text(
              "Position - Full-Stack Developer",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            currentAccountPicture: Image.network(
              "https://as2.ftcdn.net/v2/jpg/02/14/34/09/1000_F_214340987_iYuLVLrP61oepILx6yiUTOO7xsdvmX9K.jpg",
            ),
          ),
          _buildDrawerItem(Icons.home, "Home", () {
            _pageController.jumpToPage(0);
          }),
          _buildDrawerItem(Icons.data_exploration_rounded, "Report", () {
            _pageController.jumpToPage(1);
          }),
          DropdownProductManagement(pageController: _pageController),
          DropdownEmployeeManagement(pageController: _pageController),
          _buildDrawerItem(Icons.logout, "Logout", () {
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  /// Builds a single drawer item.
  ListTile _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
    );
  }
}
