import 'package:foodapp/dtos/requests/category/get_category_request.dart';
import 'package:foodapp/dtos/requests/order/insert_order_request.dart';
import 'package:foodapp/dtos/responses/api_response.dart';
import 'package:foodapp/dtos/responses/order/order.dart';
import 'package:foodapp/enums/http_method.dart';
import 'package:foodapp/services/api_constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'base_service.dart';

class OrderService extends BaseService {
  Future<ApiResponse> createOrder(InsertOrderRequest insertOrderRequest) async {
    final String apiUrl = '${APIConstants.baseUrl}/orders';
    final Map<String, dynamic> requestData = insertOrderRequest.toJson();
    String jwtToken = await tokenRepository.getJwtToken();
    final ApiResponse response = await request(
      apiUrl: apiUrl,
      method: HttpMethod.POST,
      requestData: requestData,
      token: jwtToken
    );
    return response;
  }
  Future<List<Order>> getMyOrders() async {
    final String apiUrl = '${APIConstants.baseUrl}/orders/user/0';
    String jwtToken = await tokenRepository.getJwtToken();
    final ApiResponse response = await request(
        apiUrl: apiUrl,
        method: HttpMethod.GET,
        //requestData: requestData,
        token: jwtToken
    );
    return  (response.data as List).map((jsonItem) {
      return Order.fromJson(jsonItem);
    }).toList();
  }
  Future<ApiResponse> cancelOrder(int orderId) async {
    final String apiUrl = '${APIConstants.baseUrl}/orders/cancel/${orderId}';
    String jwtToken = await tokenRepository.getJwtToken();
    final ApiResponse response = await request(
        apiUrl: apiUrl,
        method: HttpMethod.PUT,
        token: jwtToken
    );
    return response;
  }
}

