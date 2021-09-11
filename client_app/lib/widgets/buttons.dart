import 'package:flutter/material.dart';

class Buttons {
  static ButtonStyle raisedButton = ElevatedButton.styleFrom(
      onPrimary: Colors.white,
      minimumSize: Size(300, 50),
      padding: EdgeInsets.symmetric(horizontal: 16),
      primary: Colors.greenAccent,
      shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(24))));
}
