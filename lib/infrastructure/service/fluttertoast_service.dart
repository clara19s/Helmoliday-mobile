import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../service/toast_service.dart';

class FluttertoastService implements IToastService {
  @override
  void showMessage(ToastMessage message) {
    Color backgroundColor;

    switch (message.type) {
      case ToastType.success:
        backgroundColor = Colors.green;
        break;
      case ToastType.error:
        backgroundColor = Colors.red;
        break;
      case ToastType.warning:
        backgroundColor = Colors.orange;
        break;
      case ToastType.info:
        backgroundColor = Colors.blue;
        break;
    }

    Fluttertoast.showToast(
      msg: message.text,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
    );
  }
}