import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static display({String text, bool positive}) {
    Fluttertoast.showToast(
      msg: "$text",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: positive == null
          ? Colors.black
          : positive ? Colors.teal[300] : Colors.redAccent[200],
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }
}
