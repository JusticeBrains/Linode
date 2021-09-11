import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

displayToastMessage(String msg, BuildContext context) {
  Fluttertoast.showToast(msg: msg);
}
