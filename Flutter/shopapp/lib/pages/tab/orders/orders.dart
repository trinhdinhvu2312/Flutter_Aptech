import 'package:flutter/material.dart';
import 'package:foodapp/dtos/responses/order/order.dart';
import 'package:foodapp/pages/app_routes.dart';
import 'package:foodapp/pages/tab/orders/order_utils.dart';
import 'package:foodapp/services/order_service.dart';
import 'package:foodapp/widgets/loading.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  late OrderService orderService;
  @override
  void initState() {
    super.initState();
    orderService = GetIt.instance<OrderService>();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<Order>>(
          future: orderService.getMyOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading(size: 50,);
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final List<Order> orders = snapshot.data as List<Order>;
              if (orders.isEmpty) {
                return Center(
                  child: Text(
                    "No order found. You must order first.",
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  Order order = orders[index];
                  Color statusColor = getStatusColor(order.status);
                  return InkWell(
                    onTap: () {
                      context.go('/${AppRoutes.orderDetail}', extra: {'order': order});
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: statusColor), // Màu viền dựa trên trạng thái
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${order.id.toString()}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Order Date: ${DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate)}', // Format ngày giờ phút
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Total Amount: \$${order.totalMoney.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.purple), // Màu tím cho tổng số tiền
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Status: ${order.status}',
                            style: TextStyle(color: statusColor),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }}
      ),
    );
  }
}

