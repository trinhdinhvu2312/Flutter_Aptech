import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodapp/dtos/responses/user/user.dart';
import 'package:foodapp/services/user_service.dart';
import 'package:foodapp/utils/app_colors.dart';
import 'package:foodapp/widgets/uibutton.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:foodapp/pages/app_routes.dart';

class Splash extends StatefulWidget {
  Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final List<Map<String, String>> functionalities = [
    {
      'title': 'Quản lý Hàng Tồn Kho',
      'image': 'inventory.png',
      'description': 'Ghi chú về số lượng hàng tồn kho, tổng giá trị và xuất nhập hàng.',
    },
    {
      'title': 'Quản lý Đặt Hàng và Giao Hàng',
      'image': 'order.png',
      'description': 'Hỗ trợ đặt hàng trực tuyến và theo dõi tình trạng đơn đặt hàng.',
    },
    {
      'title': 'Chương Trình Khuyến Mãi và Giảm Giá',
      'image': 'promotion.png',
      'description': 'Tạo chương trình khuyến mãi, giảm giá hoặc quà tặng đặc biệt.',
    },
    {
      'title': 'Tích Hợp Hệ Thống Đánh Giá và Phản Hồi',
      'image': 'feedback.png',
      'description': 'Cho phép khách hàng đánh giá sản phẩm và dịch vụ.',
    },
    {
      'title': 'Tích Hợp Chức Năng Quảng Cáo và Marketing',
      'image': 'marketing.png',
      'description': 'Hiển thị quảng cáo sản phẩm nổi bật và tích hợp tính năng chia sẻ sản phẩm và ưu đãi trên các nền tảng xã hội.',
    },
  ];
  int _currentPage = 0; //private variable

  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        functionalities.length, // Same as itemCount above
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 4),
              height: 10,
              width: _currentPage == index ? 20 : 10,
              decoration: BoxDecoration(
                color: _currentPage == index ? AppColors.primaryColor : Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
      ),
    );
  }
  bool get _isLastItem => _currentPage == functionalities.length - 1;
  late UserService userService;

  @override
  void initState() {
    //33445566, pass: 123456789
    super.initState();
    //inject service
    userService = GetIt.instance<UserService>();
  }

  @override
  //like render() in React Class Component
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    PageController _pageController = PageController(initialPage: 0);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
              // Your custom logic here when page changes
              print('Page $_currentPage selected');
            },
            scrollDirection: Axis.horizontal,
            itemCount: functionalities.length,
            itemBuilder: (context, index) {
              var item = functionalities[index];
              return Container(
                width: screenWidth,
                height: screenHeight,
                padding: const EdgeInsets.all(10.0), // Optional: Adjust padding as needed
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/${item['image']}'),
                      width: 180,
                      height: 180,
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      item['title'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        item['description'] ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenWidth,
              height: screenHeight / 5,
              //color: Colors.deepOrange.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Padding(
                      child: buildDots(),
                      padding: EdgeInsets.all(10),
                    ),
                    CustomButton(
                        text: _isLastItem ? 'Get started':'Next',
                        backgroundColor: _isLastItem ? AppColors.primaryColor : Colors.white,
                        textColor: !_isLastItem ? AppColors.primaryColor: Colors.white,
                        onTap: () async {
                          //last item
                          if (_isLastItem == true) {
                            try {
                              User user = await userService.getUserDetails();
                              if (user.isNotEmpty) {
                                context.go('/${AppRoutes.appTab}');
;
                              } else {
                                // Token is empty or not found
                                context.go('/${AppRoutes.login}');
;
                              }
                            } catch (e) {
                              context.go('/${AppRoutes.login}');
;
                            }
                          } else {
                            _pageController.animateToPage(
                              _currentPage + 1,
                              duration: Duration(milliseconds: 300), // Animation duration
                              curve: Curves.easeInOut, // Animation curve
                            );
                          }
                        },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }
}

