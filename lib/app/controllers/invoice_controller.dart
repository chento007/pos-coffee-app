import 'package:coffee_app/app/models/dto/invoice-item.dto.dart';
import 'package:coffee_app/app/models/dto/invoice.dto.dart';
import 'package:coffee_app/app/models/invoice.dart';
import 'package:coffee_app/app/models/invoice_detail.dart';
import 'package:coffee_app/app/notification/toast_notification.dart';
import 'package:coffee_app/app/response/response_item.dart';
import 'package:coffee_app/app/services/invoice_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InvoiceController extends GetxController {
  var invoice = Rx<Invoice?>(null);
  var invoiceDetails = <InvoiceDetail>[].obs;
  final InvoiceService invoiceService = InvoiceService();

  var isLoading = false.obs;
  var invoiceDashboard = <Invoice>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;
  var pageSize = 10;

  var take = 10.obs;
  var page = 1.obs;
  var totalPage = 1.obs;
  var itemCount = 1.obs;
  var pageCount = 1.obs;
  var search = ''.obs;
  var hasPreviousPage = false.obs;
  var hasNextPage = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    try {
      isLoading(true);

      ResponseEntity<Invoice> fetchedProducts =
          await invoiceService.fetchInvoices(
        page: page.value,
        take: take.value,
        search: search.value,
      );

      itemCount.value = fetchedProducts.itemCount;
      pageCount.value = fetchedProducts.pageCount;
      hasPreviousPage.value = fetchedProducts.hasPreviousPage;
      hasNextPage.value = fetchedProducts.hasNextPage;
      invoiceDashboard.assignAll(fetchedProducts.items);
    } catch (e) {
      print('Error fetching invoice: $e');
    } finally {
      isLoading(false);
    }
  }

  void addInvoiceDetail(InvoiceDetail detail, int index) {
    bool exists = invoiceDetails.any(
        (existingDetail) => existingDetail.product.id == detail.product.id);

    invoiceDetails.add(detail);

    update();
  }

  void checkout() async {
    if (invoiceDetails.isEmpty) {
      Get.snackbar("Error", "Invoice is empty!");
      return;
    }

    double totalAmount = getTotalPaymentUSD();

    InvoiceDto invoiceDto = InvoiceDto(
      totalAmount: totalAmount,
      discount: invoice?.value?.discount,
      items: invoiceDetails
          .map((detail) => InvoiceItemDto(
                productId: detail.product.id,
                quantity: detail.quantity,
                discount: detail.discount,
                unitPrice: detail.unitPrice,
                totalPrice: detail.subTotal,
              ))
          .toList(),
    );

    try {
      bool isCreated = await invoiceService.insertInvoice(invoiceDto);
      if (isCreated) {
        ToastNotification.success(
          Get.context!,
          title: "Checkout successfully",
          description: "Invoice added successfully!",
        );
        clearInvoice();
        await fetchInvoices();
      } else {
        Get.snackbar("Failure", "Invoice creation failed!");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: ${e.toString()}");
    } finally {
      // Any cleanup if necessary
    }
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchInvoices();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchInvoices();
    }
  }

  void onChangeSearchTitle() {
    fetchInvoices();
  }

  void removeInvoiceDetail(InvoiceDetail detail) {
    invoiceDetails.remove(detail);
  }

  void removeInvoiceDetailById(int id) {
    invoiceDetails.removeWhere((detail) => detail.id == id);
  }

  void clearInvoice() {
    invoice.value = null;
    invoiceDetails.clear();
  }

  void updateInvoice(Invoice newInvoice) {
    invoice.value = newInvoice;
  }

  double getSubTotal() {
    double subTotal = 0;
    for (var detail in invoiceDetails) {
      subTotal += detail.subTotal;
    }
    return double.parse(subTotal.toStringAsFixed(2));
  }

  double applyDiscountToAll() {
    double totalDiscount = 0;
    for (var detail in invoiceDetails) {
      double productDiscount = detail.subTotal * (detail.discount / 100);
      totalDiscount += productDiscount;
    }
    return double.parse(totalDiscount.toStringAsFixed(2));
  }

  double getDiscountAmount() {
    return applyDiscountToAll();
  }

  double getTotalPaymentUSD() {
    double subTotal = getSubTotal();
    double totalDiscount = applyDiscountToAll();
    double totalPayment = subTotal - totalDiscount;
    return double.parse(totalPayment.toStringAsFixed(2));
  }

  String getTotalPaymentRiel() {
    double totalUSD = getTotalPaymentUSD();
    const exchangeRate = 4100;
    double totalRiel = totalUSD * exchangeRate;

    // Format with thousands separator
    final formatter = NumberFormat("#,###.##");
    return formatter.format(totalRiel);
  }

  void increaseQuantity(int index) {
    if (index < 0 || index >= invoiceDetails.length) {
      return;
    }

    var detail = invoiceDetails[index];

    detail.quantity += 1;
    detail.subTotal = detail.quantity * detail.unitPrice;

    invoiceDetails[index] = detail;

    update();
  }

  void decreaseQuantity(int index) {
    if (index < 0 || index >= invoiceDetails.length) {
      print("Invalid index");
      return;
    }

    var detail = invoiceDetails[index];

    if (detail.quantity > 1) {
      detail.quantity -= 1;
      detail.subTotal = detail.quantity * detail.unitPrice;

      invoiceDetails[index] = detail;

      update();
    }
  }

  void updateOrderItem(int index, double price, double discount) {
    var detail = invoiceDetails[index];

    detail.unitPrice = price;
    detail.discount = discount;

    invoiceDetails[index] = detail;
    update();
  }

  void updateOrderAllDiscountItem(double discount) {
    for (var i = 0; i < invoiceDetails.length; i++) {
      var detail = invoiceDetails[i];
      detail.discount = discount;
      invoiceDetails[i] = detail;
    }
    update();
  }
}
