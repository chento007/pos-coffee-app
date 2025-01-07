import 'package:coffee_app/app/models/product.dart';
import 'package:coffee_app/app/notification/toast_notification.dart';
import 'package:coffee_app/app/response/response_item.dart';
import 'package:coffee_app/app/services/product_service.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  var isLoading = false.obs;
  var isProductByCategoryLoading = false.obs;
  var createdLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var searchText = ''.obs;
  var products = <Product>[].obs;
  var productDashboard = <Product>[].obs;

  // Pagination variables
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var pageSize = 10; // Number of items per page

  var take = 10.obs;
  var page = 1.obs;
  var totalPage = 1.obs;
  var itemCount = 1.obs;
  var pageCount = 1.obs;
  var search = ''.obs;
  var hasPreviousPage = false.obs;
  var hasNextPage = false.obs;

  // The service instance for API calls
  final ProductService apiService = ProductService();

  @override
  void onInit() {
    super.onInit();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    try {
      createdLoading(true);

      ResponseEntity<Product> fetchedProducts = await apiService.fetchProducts(
        page: page.value,
        take: take.value,
        search: search.value,
      );

      itemCount.value = fetchedProducts.itemCount;
      pageCount.value = fetchedProducts.pageCount;
      hasPreviousPage.value = fetchedProducts.hasPreviousPage;
      hasNextPage.value = fetchedProducts.hasNextPage;

      productDashboard.assignAll(fetchedProducts.items);
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      createdLoading(false);
    }
  }

  // Fetch products by category
  Future<void> fetchProductsByCategory(int categoryId) async {
    try {
      createdLoading(true);
      List<Product> fetchedProducts =
          await apiService.fetchProductsByCategory(categoryId);

      products.assignAll(fetchedProducts);
    } catch (e) {
      print("error : $e");
      hasError(true);
      print("error: $e");
      errorMessage.value = e.toString();
    } finally {
      createdLoading(false);
    }
  }

  Future<void> insertProduct(
    String name,
    String description,
    double price,
    int categoryId,
  ) async {
    try {
      createdLoading(true);

      bool isCreated =
          await apiService.insertProduct(name, description, price, categoryId);

      if (isCreated) {
        Get.snackbar("Success", "Product added successfully!");
        fetchProduct();
      } else {
        Get.snackbar("Failure", "Product creation failed!");
      }
    } catch (e) {
      hasError(true);
      errorMessage.value = e.toString();
      Get.snackbar("Error", errorMessage.value); // Show error message
    } finally {
      createdLoading(false);
    }
  }

  // Insert a new product
  Future<void> updateStatus(int id) async {
    try {
      createdLoading(true);

      bool isCreated = await apiService.updateStatus(id);

      if (isCreated) {
        // Fetch products again after successful creation
        ToastNotification.success(
          Get.context!,
          title: "Updated successfully",
          description: "You have been update successfully.",
        );
        fetchProduct();
      } else {
        Get.snackbar("Failure", "Update product failed!");
      }
    } catch (e) {
      hasError(true);
      errorMessage.value = e.toString();
      Get.snackbar("Error", errorMessage.value); // Show error message
    } finally {
      createdLoading(false);
    }
  }

  Future<void> updatePopular(int id) async {
    try {
      createdLoading(true);

      bool isCreated = await apiService.updatePopular(id);

      if (isCreated) {
        ToastNotification.success(
          Get.context!,
          title: "Updated successfully",
          description: "You have been update successfully.",
        );
        fetchProduct();
      } else {
        Get.snackbar("Failure", "Update product failed!");
      }
    } catch (e) {
      hasError(true);
      errorMessage.value = e.toString();
      Get.snackbar("Error", errorMessage.value);
    } finally {
      createdLoading(false);
    }
  }

  Future<void> deleteById(int id) async {
    try {
      createdLoading(true);

      await apiService.deleteById(id);

      ToastNotification.success(
        Get.context!,
        title: "Delete successfully",
        description: "You have been delete successfully.",
      ); // Show success message
      fetchProduct();
    } catch (e) {
      hasError(true);
      errorMessage.value = e.toString();
      Get.snackbar("Error", errorMessage.value); // Show error message
    } finally {
      createdLoading(false);
    }
  }

  // Insert a new product
  Future<void> updateProduct(
    int id,
    String name,
    String description,
    double price,
    int categoryId,
  ) async {
    try {
      createdLoading(true);

      bool isCreated = await apiService.update(
        id,
        name,
        description,
        price,
        categoryId,
      );

      if (isCreated) {
        ToastNotification.success(
          Get.context!,
          title: "Add successfully",
          description: "You have been add successfully.",
        );
        fetchProduct();
      } else {
        Get.snackbar("Failure", "Product creation failed!");
      }
    } catch (e) {
      hasError(true);
      errorMessage.value = e.toString();
      Get.snackbar("Error", errorMessage.value);
    } finally {
      createdLoading(false);
    }
  }

  // Handle page changes
  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchProduct();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchProduct();
    }
  }

  void onChangeSearchTitle() {
    fetchProduct();
  }
}
