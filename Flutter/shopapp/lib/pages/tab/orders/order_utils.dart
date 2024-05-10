import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status) {
    case 'delivered':
      return Colors.green;
    case 'processing':
      return Colors.orange;
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.black;
  }
}
