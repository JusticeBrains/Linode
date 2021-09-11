import 'dart:math';

import 'package:client_app/data_provider/appdata.dart';
import 'package:client_app/datamodels/address.dart';
import 'package:client_app/datamodels/direction_details.dart';
import 'package:client_app/datamodels/user.dart';
import 'package:client_app/helper/requesthelper.dart';
import 'package:client_app/methods/currentFirebaseuser.dart';
import 'package:client_app/secret.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HelperMethods {
  static Future<String> findCordinateAddress(Position position, context) async {
    String placeAddress = '';
    // Network connectivity check
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];
      // Address pickUpAddress;
      // pickUpAddress.longitude = position.longitude;
      // pickUpAddress.latitude = position.longitude;
      // pickUpAddress.placeName = placeAddress;

      double piclon = position.longitude;
      double picklat = position.latitude;
      String placName = placeAddress;
      Address pickUpAddress = new Address(
          placeFormattedAddres: placeAddress,
          placeName: placName,
          latitude: picklat,
          longitude: piclon);

      Provider.of<AppData>(context, listen: false)
          .updatePickupAddress(pickUpAddress);
    }
    return placeAddress;
  }

  static Future<DirectionsDetails?> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&key=$mapKey';
    var response = await RequestHelper.getRequest(url);
    if (response == 'failed') {
      return null;
    }
    DirectionsDetails directionsDetails = new DirectionsDetails();

    if ((response['routes'] as List).isNotEmpty) {
      directionsDetails.distanceText =
          response['routes'][0]['legs'][0]['distance']['text'];
      directionsDetails.distanceValue =
          response['routes'][0]['legs'][0]['distance']['value'];
      directionsDetails.durationText =
          response['routes'][0]['legs'][0]['duration']['text'];
      directionsDetails.durationValue =
          response['routes'][0]['legs'][0]['duration']['value'];
      directionsDetails.encodedPoints =
          response['routes'][0]['overview_polyline']['points'];
    }
    return directionsDetails;
  }

  static Future<DirectionsDetails?> getDirectionDetail(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&key=$mapKey';
    var response = await Dio().get(url);

    var res = response.data;
    if ((res['routes'] as List).isEmpty) return null;
    DirectionsDetails directionsDetails = new DirectionsDetails();
    directionsDetails.distanceText =
        res['routes'][0]['legs'][0]['distance']['text'];
    directionsDetails.distanceValue =
        res['routes'][0]['legs'][0]['distance']['value'];
    directionsDetails.durationText =
        res['routes'][0]['legs'][0]['duration']['text'];
    directionsDetails.durationValue =
        res['routes'][0]['legs'][0]['distance']['value'];
    directionsDetails.encodedPoints =
        res['routes'][0]['overview_polyline']['points'];
    return directionsDetails;
  }

  static Future<DirectionDetails?> getDirectionsDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&key=$mapKey';

    var response = await RequestHelper.getRequest(url);

    if (response == 'failed') {
      return null;
    }

    String duraText = response['routes'][0]['legs'][0]['duration']['text'];
    int duraValue = response['routes'][0]['legs'][0]['duration']['value'];

    String disText = response['routes'][0]['legs'][0]['distance']['text'];
    int disValue = response['routes'][0]['legs'][0]['distance']['value'];
    String enPoints = response['routes'][0]['overview_polyline']['points'];

    DirectionDetails directionDetails = DirectionDetails(
        distanceText: disText,
        durationText: duraText,
        distanceValue: disValue,
        durationValue: duraValue,
        encodedPoints: enPoints);
    return directionDetails;
  }

  static int estimateFares(DirectionsDetails details) {
    // per km = 0.2 ADA
    // per minute = 0. 4 ADA
    // base fare = 2.5 ADA

    double baseFare = 2.5;
    double distanceFare =
        (details.distanceValue / 1000) * 0.2; // convert meters to km
    double durationFare =
        (details.durationValue / 60) * 0.4; // convert seconds to minutes

    double totalFare = baseFare + distanceFare + durationFare;
    return totalFare.truncate();
  }

  static void getCurrentUserInfo() async {
    currentFirebaseUser = await FirebaseAuth.instance;
    String userId = currentFirebaseUser.currentUser!.uid;

    DatabaseReference userRef =
        FirebaseDatabase.instance.reference().child('users/$userId');
    userRef.once().then((DataSnapshot dataSnapshot) {
      if (dataSnapshot.value != null) {
        currentUserInfo = UserInfor.fromSnapshot(dataSnapshot);
        print('My name is ${currentUserInfo.fullName}');
      }
    });
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);
    return randInt.toDouble();
  }
}
