import 'package:client_app/methods/toastmessages.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

Future<void> checkConnectivity(BuildContext context) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult != ConnectivityResult.mobile &&
      connectivityResult != ConnectivityResult.wifi) {
    displayToastMessage("No internet connection", context);
  }
}
