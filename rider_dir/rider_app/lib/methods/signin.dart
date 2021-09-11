import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/methods/input.dart';
import 'package:rider_app/methods/toastmessages.dart';
import 'package:rider_app/screens/mainscreen.dart';
import 'package:rider_app/widgets/progress_dialog.dart';

// final FirebaseAuth auth = FirebaseAuth.instance;
void loginUser(BuildContext context) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog("Logging you in"));
  try {
    User? userCredential = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
    )
            .catchError((err) {
      Navigator.pop(context);
    }))
        .user;
    Navigator.pop(context);
    if (userCredential != null) {
      DatabaseReference databaseReference = FirebaseDatabase.instance
          .reference()
          .child('drivers/${userCredential.uid}');
      databaseReference.once().then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          displayToastMessage("Logged Successfully", context);
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.id, (route) => false);
        }
      });
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      Navigator.pop(context);
      displayToastMessage("No user found for that email.", context);
    } else if (e.code == 'wrong-password') {
      Navigator.pop(context);
      displayToastMessage("Wrong password provided for that user.", context);
    }
  }
}
