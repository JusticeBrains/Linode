import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rider_app/brand_colors.dart';
import 'package:rider_app/globalvariable.dart';
import 'package:rider_app/methods/cameraPosition.dart';
import 'package:rider_app/widgets/buttons.dart';
import 'package:rider_app/widgets/onlineConfirmatin.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late GoogleMapController googleMapController;
  Completer<GoogleMapController> _completer = Completer();

  late Position currentPosition;
  String pathToReference = 'DriversOnline';

  late DatabaseReference tripRequestRef;

  bool isAvailable = false;

  void getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    LatLng pos = LatLng(position.latitude, position.longitude);
    googleMapController.animateCamera(CameraUpdate.newLatLng(pos));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
            padding: EdgeInsets.only(top: 135),
            initialCameraPosition: googlePlex,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _completer.complete(controller);
              googleMapController = controller;

              getCurrentPosition();
            }),
        Container(
          height: 135,
          width: double.infinity,
          color: Colors.green[400],
        ),
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      isDismissible: false,
                      context: context,
                      builder: (BuildContext context) => OnlineConfirmation(
                            title:
                                (!isAvailable) ? "READY DRIVE" : "TAKE A BREAK",
                            subtile: (isAvailable)
                                ? "NOT READY TO ACCEPT RIDE REQUEST"
                                : "READY TO DRIVE",
                            onPressed: () {
                              if (!isAvailable) {
                                driverOnline();
                                getCurrentPosition();
                                Navigator.pop(context);
                                setState(() {
                                  availabilityTitle = "TAKE A BREAK";
                                  isAvailable = true;
                                });
                              } else {
                                takeBreak();
                                Navigator.pop(context);
                                setState(() {
                                  availabilityTitle = "READY DRIVE";
                                  isAvailable = false;
                                });
                              }
                            },
                          ));
                },
                child: Text(availabilityTitle),
                style: Buttons.raisedButton,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void driverOnline() {
    Geofire.initialize('DriversOnline');

    Geofire.setLocation(currentFirebaseUser!.uid, currentPosition.latitude,
        currentPosition.longitude);

    tripRequestRef = FirebaseDatabase.instance
        .reference()
        .child("drivers/${currentFirebaseUser!.uid}/newtrip");
    tripRequestRef.set("waiting");
    tripRequestRef.onValue.listen((event) {});
  }

  void takeBreak() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    tripRequestRef.onDisconnect();
    tripRequestRef.remove();
  }

  void getLocationUpdate() {
    homeTabPositionStream =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      Geofire.setLocation(
          currentFirebaseUser!.uid, position.latitude, position.longitude);

      LatLng pos = LatLng(position.latitude, position.longitude);
      googleMapController.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }
}
