import 'package:foodapp/dtos/requests/coupon/coupon_request.dart';
import 'package:foodapp/dtos/requests/product/get_product_request.dart';
import 'package:foodapp/dtos/requests/user/login_request.dart';
import 'package:foodapp/dtos/requests/user/register_request.dart';
import 'package:foodapp/dtos/responses/api_response.dart';
import 'package:foodapp/dtos/responses/coupon/coupon.dart';
import 'package:foodapp/dtos/responses/product/product_list.dart';
import 'package:foodapp/dtos/responses/product/product.dart';
import 'package:foodapp/enums/http_method.dart';
import 'package:foodapp/dtos/responses/product/product.dart';
import 'package:foodapp/services/api_constants.dart';
import 'package:foodapp/repositories/cart_repository.dart';
import 'package:foodapp/services/base_service.dart';
import 'package:flutter/foundation.dart';

class CouponService extends BaseService {
  Future<double> calculateCoupon(CouponRequest couponRequest) async {
    final String apiUrl = '${APIConstants.baseUrl}/coupons/calculate';
    final ApiResponse response = await request(
      apiUrl: apiUrl,
      method: HttpMethod.GET,
      requestData: couponRequest.toJson(),
    );
    return response.data['result'] ?? 0;
  }

}
