import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
}
