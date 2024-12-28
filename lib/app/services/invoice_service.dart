import 'dart:convert';
import 'package:coffee_app/app/models/dto/invoice.dto.dart';
import 'package:coffee_app/app/models/invoice.dart';
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
      print("DioError: $e");
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

    // Print the full response for debugging
    print("response.data: ${response.data}");

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

          print("invoice response: ${productResponse.items}");
          return productResponse;
        } catch (e) {
          print("Error during deserialization: $e");
          throw Exception('Error fetching products');
        }
      } else {
        print("Error: data is not a List, it's of type: ${data.runtimeType}");
        throw Exception('Invalid response format');
      }
    } else {
      print("Error: Data is null or status code is not 200");
      throw Exception('Error fetching products');
    }
  }
}
