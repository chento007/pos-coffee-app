import 'dart:convert';
import 'package:coffee_app/app/models/dto/invoice.dto.dart';
import 'package:coffee_app/app/models/invoice.dart';
import 'package:coffee_app/app/models/sale_date.dart';
import 'package:coffee_app/app/response/response_item.dart';
import 'package:coffee_app/core/values/constant.dart';
import 'package:dio/dio.dart';
import 'auth_interceptor.dart';

class InvoiceService {
  late Dio api;

  InvoiceService() {
    api = Dio();
    api.interceptors.add(AuthInterceptor());
  }

  Future<bool> insertInvoice(InvoiceDto invoiceDto) async {
    var data = json.encode(invoiceDto.toJson());

    try {
      final response = await api.post('$BASE_URL/api/invoices', data: data);
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
            'Failed to create invoice. Status code: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Failed to send data: ${e.message}');
    }
  }

  Future<ResponseEntity<Invoice>> fetchInvoices({
    int page = 1,
    int take = 10,
    String search = '',
    String order = 'DESC',
  }) async {
    final response = await api.get(
      '$BASE_URL/api/invoices',
      queryParameters: {
        'page': page,
        'take': take,
        'order': order,
      },
    );

    // Check if the 'data' field exists and is not null
    if (response.statusCode == 200 && response.data['data'] != null) {
      // Parse the response and handle the items correctly
      var data = response.data['data'];
      if (data is List) {
        try {
          // Deserialize the data to the ResponseEntity
          ResponseEntity<Invoice> productResponse =
              ResponseEntity<Invoice>.fromJson(
            response.data,
            (json) => Invoice.fromJson(json as Map<String, dynamic>),
          );

          return productResponse;
        } catch (e) {
          throw Exception('Error fetching products');
        }
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Error fetching products');
    }
  }

  Future<SalesData> findDaily() async {
  try {
    // Make the API call
    final response = await api.get(
      '$BASE_URL/api/invoices/sales-summary',
    );

    // Check if the response is successful
    if (response.statusCode == 200) {
      // Parse the response body as JSON
      final Map<String, dynamic> jsonData = response.data;

      // Deserialize JSON into a SalesData object
      return SalesData.fromJson(jsonData);
    } else {
      // Handle non-200 status codes
      throw Exception('Failed to fetch sales summary: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any other exceptions
    throw Exception('Error fetching sales summary');
  }
}

}
