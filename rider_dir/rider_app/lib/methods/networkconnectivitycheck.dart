import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/methods/toastmessages.dart';

Future<void> checkConnectivity(BuildContext context) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.mobile &&
      connectivityResult != ConnectivityResult.wifi) {
    displayToastMessage("No internet connection", context);
  }
}
