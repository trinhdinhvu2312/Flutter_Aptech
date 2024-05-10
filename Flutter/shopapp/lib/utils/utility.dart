import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodapp/enums/popup_type.dart';
import 'package:foodapp/services/api_constants.dart';
import 'package:foodapp/widgets/info_popup.dart';

class Utility {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

  static String get osName {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isWindows) {
      return 'windows';
    } else if (Platform.isMacOS) {
      return 'macos';
    } else if (Platform.isLinux) {
      return 'linux';
    } else {
      return 'unknown';
    }
  }
  static String getProductImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return '${APIConstants.baseUrl}/products/images/notfound.jpeg';
    }

    if (!imageUrl.contains('http')) {
      return '${APIConstants.baseUrl}/products/images/$imageUrl';
    }

    return imageUrl;
  }
  static String getUserProfileImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return '${APIConstants.baseUrl}/users/profile-images/default-profile-image.jpeg';
    }

    if (!imageUrl.contains('http')) {
      return '${APIConstants.baseUrl}/users/profile-images/$imageUrl';
    }

    return imageUrl;
  }

  static void alert({
    required BuildContext context,
    required String message,
    required PopupType popupType,
    required Function onOkPressed // action when press ok
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InfoPopup(
          popupType: popupType,
          message: message,
          onOkPressed: onOkPressed,
        );
      },
    );
  }
  static void confirm({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmActionText,
    required String cancelActionText,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              // Đóng dialog
              Navigator.of(context).pop();
            },
            child: Text(cancelActionText),
          ),
          TextButton(
            onPressed: () {
              // Xử lý hành động khi bấm Yes và đóng dialog
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text(confirmActionText),
          ),
        ],
      ),
    );
  }

}
