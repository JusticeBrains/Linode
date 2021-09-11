// user authentication

import 'package:client_app/methods/input.dart';
import 'package:client_app/methods/toastmessages.dart';
import 'package:client_app/screens/mainscreen.dart';
import 'package:client_app/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
// add user method
Future<void> addNewUser(BuildContext context) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog("Registering ....."));
  try {
    User? userCredential = (await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((err) {
      Navigator.pop(context);
      PlatformException thisErr = err;
      displayToastMessage(thisErr.toString(), context);
    }))
        .user;
    Navigator.pop(context);
    // check if credentials not null
    if (userCredential != null) {
      // Save  user data to database
      Map userMap = {
        'fullname': nameTextEditingController.text,
        'email': emailTextEditingController.text,
        'phone': phonenumberTextEditingController.text,
        'password': passwordTextEditingController.hashCode,
      };
      displayToastMessage("Registration Successfull", context);
      DatabaseReference databaseReference = FirebaseDatabase.instance
          .reference()
          .child('users/${userCredential.uid}');
      databaseReference.set(userMap);

      // Send user to main screen
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.id, (route) => false);
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      displayToastMessage("The password provided is too weak.", context);
    } else if (e.code == 'email-already-in-use') {
      displayToastMessage(
          "The account already exists for that email.", context);
    }
  } catch (e) {
    displayToastMessage(e.toString(), context);
  }
}
