import 'package:flutter/material.dart';
import 'package:foodapp/dtos/responses/product/product.dart';
import 'package:foodapp/utils/app_colors.dart';
import 'package:foodapp/utils/utility.dart';

class ProductDetailsSheet extends StatefulWidget {
  final Product product;
  final bool isBottomSheetVisible;
  final VoidCallback toggleBottomSheet;
  final VoidCallback addToCart;

  final VoidCallback decreaseCount;
  final VoidCallback increaseCount;
  final int itemCount;

  ProductDetailsSheet({
    required this.product,
    required this.isBottomSheetVisible,
    required this.toggleBottomSheet,
    required this.addToCart,
    required this.decreaseCount,
    required this.increaseCount,
    required this.itemCount,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductDetailsSheet> createState() => _ProductDetailsSheetState();
}

class _ProductDetailsSheetState extends State<ProductDetailsSheet> {

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: widget.isBottomSheetVisible ? Utility.screenHeight(context) * 2/3 : 0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Exit button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: widget.toggleBottomSheet,
                ),
              ],
            ),
            // Product image
            Container(
              width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), // Border radius
              ),
              child: Image.network(
                widget.product.thumbnail,
                fit: BoxFit.cover, // To cover the container
              ),
            ),
            // Replace with your product image URL
            // Count buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: widget.decreaseCount,
                ),
                Text('${widget.itemCount}', style: Theme.of(context).textTheme.bodyMedium),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: widget.increaseCount,
                ),
              ],
            ),
            // Add to Cart button
            InkWell(
              onTap: () {
                widget.addToCart();
                widget.toggleBottomSheet();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor, // 50% opacity
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Text('Add to Cart', style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white, // Set text color to white
                    fontWeight: FontWeight.bold
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
