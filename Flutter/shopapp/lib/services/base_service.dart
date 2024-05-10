import 'package:foodapp/dtos/responses/api_response.dart';
import 'package:foodapp/exceptions/custom_exception.dart';
import 'package:foodapp/enums/http_method.dart';
import 'package:foodapp/repositories/auth_repository.dart';
import 'package:foodapp/repositories/cart_repository.dart';
import 'package:foodapp/repositories/token_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:foodapp/extensions/custon_string.dart';
class BaseService {
  final TokenRepository tokenRepository = TokenRepository();
  final AuthRepository authRepository = AuthRepository();
  final CartRepository cartRepository = CartRepository();

  Future<ApiResponse> request({
    required String apiUrl,
    required HttpMethod method,
    Map<String, dynamic>? requestData,
    String? token, // Optional token parameter
  }) async {
    int errorStatusCode = 200;
    try {
      late http.Response response;

      // Define default headers
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      };

      // Add Bearer token to headers if provided
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
      // Perform HTTP request based on method
      switch (method) {
        case HttpMethod.GET:
          response = await http.get(
            Uri.parse(apiUrl).replace(queryParameters: requestData),
            headers: headers,
          );
          break;
        case HttpMethod.POST:
          response = await http.post(
            Uri.parse(apiUrl),
            headers: headers,
            body: convert.jsonEncode(requestData),
          );
          break;
        case HttpMethod.PUT:
          response = await http.put(
            Uri.parse(apiUrl),
            headers: headers,
            body: convert.jsonEncode(requestData),
          );
          break;
        case HttpMethod.DELETE:
          response = await http.delete(
            Uri.parse(apiUrl),
            headers: headers,
          );
          break;
      }

      if (response.statusCode == 200) {
        // Parse the response JSON
        final ApiResponse responseData = ApiResponse.fromJson(
          convert.jsonDecode(response.body),
        );
        return responseData;
      } else {
        errorStatusCode = response.statusCode;
        throw CustomException(
            statusCode: errorStatusCode,
            message: convert.jsonDecode(response.body)['message']?.toUtf8() ?? ''
        );
      }
    } catch (e) {
      throw CustomException(
          statusCode: (e is CustomException && e.statusCode == errorStatusCode) ?
          errorStatusCode:
          CustomException.INTERNAL_SERVER_ERROR,
          message: e.toString()
      );
    }
  }
}