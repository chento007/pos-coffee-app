import 'package:coffee_app/app/models/role.dart';
import 'package:coffee_app/app/response/response_item.dart';
import 'package:coffee_app/app/services/role_service.dart';
import 'package:get/get.dart';

class RoleController extends GetxController {
  var isLoading = false.obs;
  var dashboardLoading = false.obs;

  var roles = <Role>[].obs;

  var take = 10.obs;
  var page = 1.obs;
  var totalPage = 1.obs;
  var itemCount = 1.obs;
  var pageCount = 1.obs;
  var search = ''.obs;
  var hasPreviousPage = false.obs;
  var hasNextPage = false.obs;

  final RoleService apiService = RoleService();

  @override
  void onInit() {
    super.onInit();
    fetchRoles();
  }

  Future<void> fetchRoles() async {
    try {
      dashboardLoading(true);
      roles.clear();

      ResponseEntity<Role> fetchedRoles = await apiService.fetchRoles(
        page: page.value,
        take: take.value,
        search: search.value,
      );
      itemCount.value = fetchedRoles.itemCount;
      pageCount.value = fetchedRoles.pageCount;
      hasPreviousPage.value = fetchedRoles.hasPreviousPage;
      hasNextPage.value = fetchedRoles.hasNextPage;
      print("roles: $roles");
      roles.assignAll(fetchedRoles.items);
    } catch (e) {
      print('Error while getting users data: $e');
    } finally {
      dashboardLoading(false);
    }
  }

  
}
