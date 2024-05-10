import 'package:foodapp/dtos/requests/category/get_category_request.dart';
import 'package:foodapp/dtos/responses/api_response.dart';
import 'package:foodapp/dtos/responses/category/category.dart';
import 'package:foodapp/enums/http_method.dart';
import 'package:foodapp/services/api_constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'base_service.dart';

class CategoryService extends BaseService {
  Future<List<Category>> getCategories(GetCategoryRequest getCategoryRequest) async {
    final String apiUrl = '${APIConstants.baseUrl}/categories';
    final ApiResponse response = await request(
      apiUrl: apiUrl,
      method: HttpMethod.GET,
      requestData: getCategoryRequest.toJson(),
    );
    return  (response.data as List).map((jsonItem) {
      return Category.fromJson(jsonItem);
    }).toList();
  }
}

