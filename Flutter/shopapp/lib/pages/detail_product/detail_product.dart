import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:foodapp/dtos/responses/product/product.dart';
import 'package:foodapp/dtos/responses/product_image/product_image.dart';
import 'package:foodapp/enums/popup_type.dart';
import 'package:foodapp/pages/detail_product/detail_product_sheet.dart';
import 'package:foodapp/services/product_service.dart';
import 'package:foodapp/utils/app_colors.dart';
import 'package:foodapp/utils/utility.dart';
import 'package:foodapp/widgets/loading.dart';
import 'package:foodapp/widgets/transparent_appbar.dart';
import 'package:get_it/get_it.dart'; // Import the carousel_slider package
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:foodapp/pages/app_routes.dart';

class DetailProduct extends StatefulWidget {
  final int productId;

  const DetailProduct({
    super.key,
    required this.productId,
  });

  @override
  _DetailProductState createState() => _DetailProductState();
}


class _DetailProductState extends State<DetailProduct> {
  late ProductService productService;
  bool isBottomSheetVisible = false;
  int itemCount = 1; // Initial count
  Product _product = Product.empty;

  @override
  void initState() {
    super.initState();
    productService = GetIt.instance<ProductService>();
  }
  void _toggleBottomSheet() {
    setState(() {
      isBottomSheetVisible = !isBottomSheetVisible;
    });
  }
  void _addToCart() {
    productService.addToCart(productId: _product.id, itemCount: itemCount);
  }

  void _increaseCount() {
    setState(() {
      itemCount++;
    });
  }

  void _decreaseCount() {
    if (itemCount > 1) {
      setState(() {
        itemCount--;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TransparentAppBar(
        title: 'Detail product',
        onBack: () {
          context.go('/${AppRoutes.appTab}');
;
        },
      ),
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<dynamic>(
              future: productService.getProductById(widget.productId), // Call your API here
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loading(); // Show loading indicator while waiting for data
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}')); // Show error message if there's an error`
                } else {
                  // Data fetched successfully, display ListView
                  _product = snapshot.data!; // Extract products from the response
                  List<ProductImage> productImages = _product.productImages;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CarouselSlider(
                          items: productImages.map((productImage) {
                            return Image.network(
                              productImage.imageUrl,
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                          options: CarouselOptions(
                            aspectRatio: 16 / 9,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration: Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                          ),

                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _product.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Price: \$'+'${_product.price}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _product.description,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(Icons.star, color: AppColors.primaryColor),
                                  Icon(Icons.star, color: AppColors.primaryColor),
                                  Icon(Icons.star, color: AppColors.primaryColor),
                                  Icon(Icons.star_half, color: AppColors.primaryColor),
                                  Icon(Icons.star_border, color: AppColors.primaryColor),
                                  SizedBox(width: 8),
                                  Text(
                                    '4.5 (1234 reviews)',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'User Comments:',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 8),
                              ..._product.comments.map((comment) => Container(
                                padding: EdgeInsets.only(top: 10),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${comment.user.fullName}',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.bold
                                          )),
                                      Text('${comment.content}',
                                          style: Theme.of(context).textTheme.bodySmall),
                                      Text(DateFormat('dd-MM-yyyy HH:mm:ss').format(comment.createdAt)),
                                    ]
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            isBottomSheetVisible == true ? Container() : Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    productService.isCartEmpty.then((isEmpty) {
                      if (!isEmpty) {
                        context.go('/${AppRoutes.confirmOrder}');
                      } else {
                        Utility.alert(
                            context: context,
                            message: 'Your orders is empty. Please add items before proceeding.',
                            popupType: PopupType.failure,
                            onOkPressed: () {
                              // Optional action on OK pressed
                            }
                        );
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.8), // 50% opacity
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    child: Row(
                      children: [
                        Icon(Icons.shopping_cart, color: Colors.white), // Icon
                        SizedBox(width: 8),
                        Text('Buy Now', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: _toggleBottomSheet,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.8), // 50% opacity
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    child: Row(
                      children: [
                        Icon(Icons.add_shopping_cart, color: Colors.white), // Icon
                        SizedBox(width: 8),
                        Text('Cart', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white, // Set text color to white
                            fontWeight: FontWeight.bold
                        ),),
                      ],
                    ),
                  ),
                ),
              ],
            )),
            isBottomSheetVisible == true ? Positioned.fill(
              child: Container(
                color: AppColors.primaryColor.withAlpha(50),
              ),
            ):Container(),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ProductDetailsSheet(
                    product: _product,
                    isBottomSheetVisible: isBottomSheetVisible,
                    toggleBottomSheet: _toggleBottomSheet,
                    decreaseCount: _decreaseCount,
                    increaseCount: _increaseCount,
                    addToCart: _addToCart,
                    itemCount: itemCount
                )
            )
          ],
        ),
      ),
    );
  }
}
