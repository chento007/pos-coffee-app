import 'package:coffee_app/app/models/category.dart';
import 'package:coffee_app/app/response/response_item.dart';
import 'package:coffee_app/app/services/category_service.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var isLoading = false.obs;
  var categories = <Category>[].obs;
  var categoriesDashboard = <Category>[].obs;
  var search = ''.obs;
  var dashboardLoading = false.obs;
  var currentPage = 1.obs;

  var totalPage = 1.obs;
  var itemCount = 1.obs;
  var pageCount = 1.obs;
  var hasPreviousPage = false.obs;
  var hasNextPage = false.obs;
  var take = 10.obs;
  var page = 1.obs;

  final CategoryService apiService = CategoryService();

  // Define the default category
  final Category defaultCategory = Category(
    id: -1,
    uuid: 'default-popular-uuid',
    createdAt: DateTime.now().toIso8601String(),
    updatedAt: DateTime.now().toIso8601String(),
    deletedAt: null,
    status: true, // Set the default status
    name: "Popular",
    description: "This is a default category for popular items",
  );

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchCategoriesDashboard();
  }

  // Fetch categories with pagination support
  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      ResponseEntity<Category> fetchedCategories =
          await apiService.fetchCategories(
        page: page.value,
        take: take.value,
      );

      // Update the category list
      if (page.value == 1) {
        categories.clear();
        categoriesDashboard.clear();
        categories.add(defaultCategory);
      }
      categories.addAll(fetchedCategories.items);
      categoriesDashboard.addAll(fetchedCategories.items);

      totalPage.value = page.value;
      currentPage.value = page.value;
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> insertCategory(String name, String description) async {
    try {
      dashboardLoading(true);
      bool created = await apiService.createCategory(name, description);
      if (created) {
        await fetchCategoriesDashboard();
      }
    } catch (e) {
      print(e);
    } finally {
      dashboardLoading(false);
    }
  }

  Future<void> fetchCategoriesDashboard() async {
    try {
      dashboardLoading(true);
      categoriesDashboard.clear();

      ResponseEntity<Category> fetchedCategories =
          await apiService.fetchCategories(
        page: page.value,
        take: take.value,
        search: search.value,
      );

      itemCount.value = fetchedCategories.itemCount;
      pageCount.value = fetchedCategories.pageCount;
      hasPreviousPage.value = fetchedCategories.hasPreviousPage;
      hasNextPage.value = fetchedCategories.hasNextPage;

      categoriesDashboard.addAll(fetchedCategories.items);

      categories.clear();
      categories.add(defaultCategory);
      categories.addAll(fetchedCategories.items);
    } catch (e) {
      print(e);
    } finally {
      dashboardLoading(false);
    }
  }

  Future<void> updateStatus(int id) async {
    try {
      bool status = await apiService.updateStatus(id);

      if (status) {
        Get.snackbar("Success", "Update status successfully!");
        await fetchCategoriesDashboard();
      } else {
        Get.snackbar("Failed", "Update status Failed!");
      }
    } catch (e) {
      print(e);
    } finally {
      dashboardLoading(false);
    }
  }

  Future<void> updateCategory(int id, String name, String description) async {
    try {
      dashboardLoading(true);

      bool isCreated = await apiService.update(
        id,
        name,
        description,
      );

      if (isCreated) {
        // Fetch products again after successful creation
        Get.snackbar(
            "Update", "Product added successfully!"); // Show success message
        fetchCategoriesDashboard();
      } else {
        Get.snackbar("Failure", "Product creation failed!");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString()); // Show error message
    } finally {
      dashboardLoading(false);
    }
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      page.value = page.value + 1;
      fetchCategories();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      page.value = page.value - 1;
      fetchCategories();
    }
  }

  void onChangeSearchTitle() {
    fetchCategoriesDashboard();
  }

  void updateLimit() {
    fetchCategoriesDashboard();
  }
}
