import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:rider_app/globalvariable.dart';
import 'package:rider_app/methods/input.dart';
import 'package:rider_app/screens/mainscreen.dart';
import 'package:rider_app/screens/vehicleinfo.dart';

void profileUpdate(context) {
  String id = currentFirebaseUser!.uid;
  DatabaseReference databaseReference =
      FirebaseDatabase.instance.reference().child('drivers/$id/motor_details');

  Map map = {
    'motor_model': motorModelTextEditingController.text,
    'motor_color': motorColorrTextEditingController.text,
    'motor_number': motorNumberTextEditingController.text,
  };

  databaseReference.set(map);

  Navigator.pushNamedAndRemoveUntil(context, MainScreen.id, (route) => false);
}
