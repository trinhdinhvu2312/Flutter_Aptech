import 'package:flutter/material.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          _buildOrderItem(
            productImage: 'https://via.placeholder.com/150',
            productName: 'Product 1',
            quantity: 2,
            totalPrice: 200.0,
            status: 'Delivered',
            statusColor: Colors.green,
          ),
          _buildOrderItem(
            productImage: 'https://via.placeholder.com/150',
            productName: 'Product 2',
            quantity: 1,
            totalPrice: 100.0,
            status: 'Pending',
            statusColor: Colors.blue,
          ),
          // Add more order items as needed
        ],
      ),
    );
  }

  Widget _buildOrderItem({
    required String productImage,
    required String productName,
    required int quantity,
    required double totalPrice,
    required String status,
    required Color statusColor,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Image.network(
            productImage,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(productName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quantity: $quantity'),
              Text('Total Price: $totalPrice'),
            ],
          ),
          trailing: Text(
            status,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}
