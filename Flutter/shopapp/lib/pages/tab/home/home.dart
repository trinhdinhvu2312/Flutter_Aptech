import 'package:flutter/material.dart';
import 'package:foodapp/dtos/requests/category/get_category_request.dart';
import 'package:foodapp/dtos/requests/product/get_product_request.dart';
import 'package:foodapp/dtos/responses/product/product.dart';
import 'package:foodapp/dtos/responses/category/category.dart';
import 'package:foodapp/dtos/responses/product/product.dart';
import 'package:foodapp/pages/tab/home/grid_item.dart';
import 'package:foodapp/services/category_service.dart';
import 'package:foodapp/services/product_service.dart';
import 'package:foodapp/services/user_service.dart';
import 'package:foodapp/utils/app_colors.dart';
import 'package:foodapp/utils/utility.dart';
import 'package:foodapp/widgets/loading.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert' as convert;
import 'package:foodapp/pages/app_routes.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ProductService productService;
  late CategoryService categoryService;
  late UserService userService;

  int page = 0;
  int limit = 20;
  Category? selectedCategory;
  String keyword = '';
  final int crossAxisCount = 2;
  late int? userId;

  @override
  void initState() {
    super.initState();
    productService = GetIt.instance<ProductService>();
    categoryService = GetIt.instance<CategoryService>();
    userService = GetIt.instance<UserService>();
    userService.getLoginUserId().then((userIdValue) {
      setState(() {
        userId = userIdValue;
      });
    });
  }
  void _like({required bool isLiked, required int productId}) {
    productService.like(isLiked: isLiked, productId: productId);
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = Utility.screenWidth(context);
    final screenHeight = Utility.screenHeight(context);
    /*24 is for notification bar on Android*/
    final double itemHeight = (screenHeight - kToolbarHeight - 24) / 2.5;
    final double itemWidth = screenWidth / 2;
    return Container(
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0), // Add border radius
                              borderSide: BorderSide(color: AppColors.primaryColor), // Set border color
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          // Handle search button tap
                        },
                      ),
                    ],
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        FutureBuilder<List<Category>>(
                          future: categoryService.getCategories(
                              GetCategoryRequest(page: page, limit: limit)
                          ), // Assuming getCategories() returns a Future<List<Category>>
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Expanded(child: Loading(size: 50,));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final List<Category> categories = snapshot.data as List<Category>;
                              return Expanded(child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedCategory = null; // Set selectedCategory to null when "All" is tapped
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: selectedCategory == null ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                          'All',
                                        style: TextStyle(color: selectedCategory == null ? Colors.white : Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8), // Adjust the spacing as needed
                                  ...categories.map((category) {
                                    final isSelected = selectedCategory?.id == category.id;
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = category;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                        margin: EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppColors.primaryColor : AppColors.primaryColor.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(category.name,
                                          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ))
                              ;
                            }
                          },
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.15, // Adjust the top position
              child: FutureBuilder<dynamic>(
                future: productService.getProducts(GetProductRequest(
                    page: page,
                    limit: limit,
                    keyword: keyword,
                    categoryId: selectedCategory?.id ?? 0
                )), // Call your API here
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading(); // Show loading indicator while waiting for data
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}')); // Show error message if there's an error`
                  } else {
                    // Data fetched successfully, display ListView
                    List<Product> products = snapshot.data!.products; // Extract products from the response
                    if (products.isEmpty) {
                      return Container(
                        color: Colors.white, // Set container color
                        child: Center(
                          child: Text(
                            'No data found',
                            style: TextStyle(
                              color: Colors.red, // Set text color to red
                              fontSize: 24, // Set font size to 24 (adjust as needed)
                              fontWeight: FontWeight.bold, // Optionally, set font weight to bold
                            ),
                          ),
                        ),
                      );
                    }
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.builder(
                        shrinkWrap: true, // Allow the GridView to occupy only the space it needs
                        //physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //childAspectRatio: 2/2.7,
                          childAspectRatio: (itemWidth / itemHeight),
                          //mainAxisExtent: screenHeight,
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 10, // Spacing between columns
                          mainAxisSpacing: 10, // Spacing between rows
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          Product product = products[index];
                          bool isLiked = false;
                          product.favorites.forEach((favorite) {
                            if (favorite.userId == userId) {
                              isLiked = true;
                              return;  // Kết thúc vòng lặp nếu tìm thấy
                            }
                          });
                          product.isLiked = isLiked;
                          return GridItem(
                              product: products[index],
                              like: _like,
                              onTap: () {
                                int productId = product.id;
                                print('navigate to detail_product, productId: ${productId}');
                                context.go('/${AppRoutes.detailProduct}', extra: {'productId': productId});
                              },
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            )
            ,
          ],
        ),
      ),
    );
  }
}