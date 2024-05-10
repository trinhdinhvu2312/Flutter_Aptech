import 'package:flutter/material.dart';
import 'package:foodapp/dtos/responses/product/product_list.dart';
import 'package:foodapp/dtos/responses/product/product.dart';
import 'package:foodapp/services/product_service.dart';
import 'package:foodapp/utils/app_colors.dart';
import 'package:foodapp/widgets/loading.dart';
import 'package:get_it/get_it.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late ProductService productService;


  @override
  void initState() {
    super.initState();
    productService = GetIt.instance<ProductService>();

  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: productService.findFavoriteProductsByUserId(), // Call the productService to fetch data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading(size: 50);
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Show an error message if fetching data fails
        } else {
          List<Product> productResponses = snapshot.data as List<Product> ; // Extract products from the response
          if (productResponses.isNotEmpty) {
            // If products exist, return a ListView to display them
            return ListView.builder(
              itemCount: productResponses.length,
              itemBuilder: (context, index) {
                Product product = productResponses[index];
                // Return a ListTile for each product
                return Container(
                  padding: EdgeInsets.all(8), // Add padding for spacing
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Leading widget (image)
                      SizedBox(
                        width: 100, // Set a fixed width for the image
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10), // Set border radius to 10
                          child: Image.network(
                            product.thumbnail,
                            fit: BoxFit.cover, // Adjust image fit as needed
                          ),
                        ),
                      ),
                      // Spacer for spacing between image and text
                      SizedBox(width: 8),
                      // Text content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '\$${product.price}', // Assuming price is stored as a double
                                  style: TextStyle(color: AppColors.primaryColor), // Set price text color to red
                                ),
                              ],
                            ),
                            SizedBox(height: 4), // Add vertical spacing
                            Text(product.description),
                            // Add more details or customize the content as needed
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            // If no products are returned, display a message indicating so
            return Center(child: Text('No products found.'));
          }
        }
      },
    );
  }
}
