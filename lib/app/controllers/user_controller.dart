import 'package:coffee_app/app/models/user.dart';
import 'package:coffee_app/app/notification/toast_notification.dart';
import 'package:coffee_app/app/response/response_item.dart';
import 'package:coffee_app/app/services/user_service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var isLoading = false.obs;
  var dashboardLoading = false.obs;

  var users = <User>[].obs;

  var take = 10.obs;
  var page = 1.obs;
  var totalPage = 1.obs;
  var itemCount = 1.obs;
  var pageCount = 1.obs;
  var search = ''.obs;
  var hasPreviousPage = false.obs;
  var hasNextPage = false.obs;

  final UserService apiService = UserService();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      dashboardLoading(true);
      users.clear();

      ResponseEntity<User> fetchedUsers = await apiService.fetchUsers(
        page: page.value,
        take: take.value,
        search: search.value,
      );
      itemCount.value = fetchedUsers.itemCount;
      pageCount.value = fetchedUsers.pageCount;
      hasPreviousPage.value = fetchedUsers.hasPreviousPage;
      hasNextPage.value = fetchedUsers.hasNextPage;
      users.assignAll(fetchedUsers.items);
    } catch (e) {
      ToastNotification.success(
        Get.context!,
        title: "User updated successfully",
        description: "You have been update successfully.",
      );    } finally {
      dashboardLoading(false);
    }
  }

  Future<void> updateUser(
    int id,
    String username,
    String phone,
    String email,
    List<int> roleIds,
  ) async {
    try {
      dashboardLoading(true);

      bool isCreated =
          await apiService.update(id, username, phone, email, roleIds);

      if (isCreated) {
        ToastNotification.success(
          Get.context!,
          title: "User updated successfully",
          description: "You have been update successfully.",
        );

        fetchUsers();
      } else {
        Get.snackbar("Failure", "Product creation failed!");
      }
    } catch (e) {
      ToastNotification.success(
        Get.context!,
        title: "User updated successfully",
        description: "You have been update successfully.",
      );
    } finally {
      dashboardLoading(false);
    }
  }

  Future<void> updateStatus(int id) async {
    try {
      dashboardLoading(true);

      bool isCreated = await apiService.updateStatus(id);

      if (isCreated) {
        ToastNotification.success(
          Get.context!,
          title: "User updated successfully",
          description: "You have been update successfully.",
        );
        fetchUsers();
      } else {
        Get.snackbar("Failure", "Update product failed!");
      }
    } catch (e) {
      ToastNotification.error(
        Get.context!,
        title: "Updated failed",
        description: "Update fail",
      );
    } finally {
      dashboardLoading(false);
    }
  }

  Future<void> insertUser(
    String username,
    String email,
    String password,
    String confirmedPassword,
    String phone,
    List<int> roleIds,
  ) async {
    try {
      dashboardLoading(true);

      bool isCreated = await apiService.insertUser(
        username,
        email,
        password,
        confirmedPassword,
        phone,
        roleIds,
      );

      if (isCreated) {
        ToastNotification.success(
          Get.context!,
          title: "Create user successfully",
          description: "You have been create successfully.",
        );
        fetchUsers();
      } else {
        Get.snackbar("Failure", "Product creation failed!");
      }
    } catch (e) {
      ToastNotification.error(
        Get.context!,
        title: "Create failed",
        description: "Create fail",
      );
    } finally {
      dashboardLoading(false);
    }
  }
}
