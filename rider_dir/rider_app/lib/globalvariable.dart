import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

User? currentFirebaseUser = FirebaseAuth.instance.currentUser;

late StreamSubscription<Position> homeTabPositionStream;

var availabilityTitle = "READY RIDE";
Color availabilityColor = Colors.yellowAccent;
