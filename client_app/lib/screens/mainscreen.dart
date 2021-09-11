import 'dart:async';
import 'dart:io';

import 'package:client_app/brand_colors.dart';
import 'package:client_app/data_provider/appdata.dart';
import 'package:client_app/datamodels/direction_details.dart';
import 'package:client_app/datamodels/direction_model.dart';
import 'package:client_app/datamodels/driversnearby.dart';
import 'package:client_app/helper/geofirehelper.dart';
import 'package:client_app/helper/helpermethods.dart';
import 'package:client_app/methods/cameraPosition.dart';
import 'package:client_app/methods/currentFirebaseuser.dart';
import 'package:client_app/methods/networkconnectivitycheck.dart';
import 'package:client_app/methods/sign_out.dart';
import 'package:client_app/screens/loginscreen.dart';
import 'package:client_app/screens/searchscreen.dart';
import 'package:client_app/styles/styles.dart';
import 'package:client_app/widgets/app_divider.dart';
import 'package:client_app/widgets/buttons.dart';
import 'package:client_app/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String id = 'mainscreen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  double searchHeight = Platform.isAndroid ? 275 : 300;
  double rideDetails = 0;
  double requestDetails = 0;

  double mapPaddingBottom = 0;

  // Geolocator
  var geolocator = Geolocator();
  late Position currentPosition;
  late GoogleMapController mapController;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = Set<Polyline>();
  Set<Marker> _marker = {};
  Set<Circle> _circle = {};
  late BitmapDescriptor driversNeabyIcon;
  DirectionsDetails? tripDetails;
  bool drawerOpener = true;

  late DatabaseReference rideRef;

  bool driversByKeysLoaded = false;

  void positionLocator() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await HelperMethods.findCordinateAddress(position, context);
    print(address);
    beginGeofireListener();
  }

  void showDetails() async {
    setState(() {
      searchHeight = 0;
      rideDetails = Platform.isAndroid ? 235 : 260;
      mapPaddingBottom = Platform.isAndroid ? 280 : 270;
      drawerOpener = false;
    });
  }

  void showRequestWidget() {
    setState(() {
      rideDetails = 0;
      requestDetails = Platform.isAndroid ? 195 : 220;
      mapPaddingBottom = Platform.isAndroid ? 200 : 190;

      drawerOpener = true;
    });

    createRideRequest();
  }

  void cancelRide() {
    setState(() {
      polylineCoordinates.clear();
      _polylines.clear();
      _marker.clear();
      _circle.clear();
      searchHeight = Platform.isAndroid ? 275 : 300;
      rideDetails = 0;
      requestDetails = 0;
      mapPaddingBottom = Platform.isAndroid ? 200 : 190;
      drawerOpener = true;
    });

    rideRef.remove();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //HelperMethods.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        width: 250.0,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 160.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: <Widget>[
                      // logo
                      Image.asset(
                        "images/user_icon.png",
                        height: 60,
                        width: 60,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "McLean",
                            style: TextStyle(
                                fontSize: 20, fontFamily: "Brand-Bold"),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text("View Profile"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AppDivider(),
              SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Icon(Icons.card_giftcard_outlined),
                title: Text(
                  "Free Rides",
                  style: kDrawerItemStyle,
                ),
              ),
              ListTile(
                leading: Icon(Icons.credit_card_outlined),
                title: Text(
                  "Payments",
                  style: kDrawerItemStyle,
                ),
              ),
              ListTile(
                leading: Icon(Icons.history_outlined),
                title: Text(
                  "History",
                  style: kDrawerItemStyle,
                ),
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text(
                  "About",
                  style: kDrawerItemStyle,
                ),
              ),
              ListTile(
                leading: Icon(Icons.support_outlined),
                title: Text(
                  "Support",
                  style: kDrawerItemStyle,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Check for network availability
                  checkConnectivity(context);
                  signOut(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.id, (route) => false);
                },
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text(
                    "Sign Out",
                    style: kDrawerItemStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingBottom),
            initialCameraPosition: googlePlex,
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: _polylines,
            markers: _marker,
            circles: _circle,
            compassEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;

              setState(() {
                mapPaddingBottom = (Platform.isAndroid) ? 280 : 270;
              });
              positionLocator();
              //setPolylines();
            },
          ),
          // Hamburger
          Positioned(
            top: 44,
            left: 20,
            child: GestureDetector(
              onTap: () {
                if (drawerOpener) {
                  scaffoldKey.currentState!.openDrawer();
                } else {
                  resetApp();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(
                    (drawerOpener) ? Icons.menu : Icons.arrow_back,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          // Search
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 160),
              curve: Curves.easeIn,
              child: Container(
                height: searchHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 5.0),
                      Text(
                        "Hey Wadup",
                        style: TextStyle(fontSize: 10),
                      ),
                      Text("Where To",
                          style: TextStyle(
                              fontSize: 18.0, fontFamily: "Brand-Bold")),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          var response = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScreenScreen()));
                          // setPolylines();
                          if (response == "getDirection") {
                            await getDirections();
                            showDetails();
                          }
                        },
                        child: Container(
                          //Search panel
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.search_off_outlined,
                                    color: Colors.blueAccent),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text("Find Destination")
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.home_outlined,
                              color: BrandColors.colorDimText),
                          SizedBox(width: 12),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(Provider.of<AppData>(context)
                                            // ignore: unnecessary_null_comparison
                                            .pickupAddress !=
                                        null
                                    ? Provider.of<AppData>(context)
                                        .pickupAddress
                                        .placeName
                                        .toString()
                                    : "Add Home"),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "Your Residential Address",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: BrandColors.colorDimText),
                                ),
                              ]),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      AppDivider(),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.work_outlined,
                              color: BrandColors.colorDimText),
                          SizedBox(width: 12),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Add Work Address"),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "Tour work address",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: BrandColors.colorDimText),
                                ),
                              ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Ride Details
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 160),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                height: rideDetails,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        // color: BrandColors.colorAccent1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22, vertical: 18),
                          child: Row(
                            children: [
                              Icon(Icons.motorcycle, size: 50),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Okada',
                                    style: TextStyle(
                                        fontSize: 16, fontFamily: 'Brand-Bold'),
                                  ),
                                  Text(
                                    (tripDetails != null)
                                        ? tripDetails!.distanceText.toString()
                                        : '',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: BrandColors.colorTextLight),
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(
                                (tripDetails != null)
                                    ? '${HelperMethods.estimateFares(tripDetails!).toString()} \ADA'
                                    : '',
                                style: TextStyle(
                                    fontSize: 15, fontFamily: 'Brand-Bold'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.moneyBillAlt,
                              size: 18,
                              color: BrandColors.colorTextLight,
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Text('COTI PAY'),
                            SizedBox(width: 5),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: BrandColors.colorTextLight,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 22,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showRequestWidget();
                        },
                        child: Text('Request Ride'),
                        style: Buttons.raisedButton,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Request ride widget
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: AnimatedSize(
              vsync: this,
              duration: new Duration(milliseconds: 160),
              curve: Curves.easeIn,
              child: Container(
                height: requestDetails,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 250.0,
                        child: TextLiquidFill(
                          text: 'Requesting a ride .......',
                          waveColor: BrandColors.colorTextSemiLight,
                          boxBackgroundColor: Colors.white,
                          textStyle: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                          boxHeight: 40.0,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              width: 1, color: BrandColors.colorLightGrayFair),
                        ),
                        child: GestureDetector(
                            onTap: () {
                              cancelRide();
                            },
                            child: Icon(
                              Icons.close,
                              size: 25,
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text("Cancel",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getDirections() async {
    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    var pickupLatLng = LatLng(pickup.latitude, pickup.longitude);
    var destinationLatLng = LatLng(destination.latitude, destination.longitude);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog("Please wait ....."));

    var thisDetails = await HelperMethods.getDirectionDetails(
        pickupLatLng, destinationLatLng);
    setState(() {
      tripDetails = thisDetails;
    });
    Navigator.pop(context);
    PolylinePoints polylinePoints = new PolylinePoints();
    // decode polyline points
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails!.encodedPoints);
    polylineCoordinates.clear();
    // polyline points decoded to polylineCoordinates
    if (results.isNotEmpty) {
      // draw polyline on map
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    _polylines.clear();

    setState(() {
      Polyline polyline = new Polyline(
        polylineId: PolylineId('polyid'),
        color: Colors.green,
        points: polylineCoordinates,
        jointType: JointType.round,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      _polylines.add(polyline);
    });

    // fitting polyline
    //   // fitting polyine to map
    LatLngBounds bounds;
    if (pickupLatLng.latitude > destinationLatLng.latitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
          northeast:
              LatLng(pickupLatLng.latitude, destinationLatLng.longitude));
    } else if (pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, pickupLatLng.longitude));
    } else {
      bounds =
          LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    }
    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));

    // Markers
    Marker pickUpMarker = new Marker(
      markerId: MarkerId('pickup'),
      position: pickupLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: pickup.placeName, snippet: 'My Location'),
    );
    Marker destinationUpMarker = new Marker(
      markerId: MarkerId('destination'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      infoWindow:
          InfoWindow(title: destination.placeName, snippet: 'My Destination'),
    );

    setState(() {
      _marker.add(pickUpMarker);
      _marker.add(destinationUpMarker);
    });

    Circle pickupCircle = Circle(
      circleId: CircleId('pickup'),
      strokeColor: Colors.green,
      strokeWidth: 3,
      radius: 12,
      center: pickupLatLng,
      fillColor: BrandColors.colorGreen,
    );
    Circle destinationCircle = Circle(
      circleId: CircleId('destination'),
      strokeColor: BrandColors.colorAccentPurple,
      strokeWidth: 3,
      radius: 12,
      center: destinationLatLng,
      fillColor: BrandColors.colorAccentPurple,
    );

    setState(() {
      _circle.add(pickupCircle);
      _circle.add(destinationCircle);
    });
  }

  void createRideRequest() {
    rideRef = FirebaseDatabase.instance.reference().child('rideRequest').push();
    var pickup = Provider.of<AppData>(context, listen: false).pickupAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    Map pickUpMap = {
      'latitude': pickup.latitude.toString(),
      'longitude': pickup.longitude.toString(),
    };
    Map destinationUpMap = {
      'latitude': destination.latitude.toString(),
      'longitude': destination.longitude.toString(),
    };
    Map rideMap = {
      'created_at': DateTime.now().toString(),
      'rider_name': currentUserInfo.fullName,
      'rider_phoneNumber': currentUserInfo.phone,
      'pickup_address': pickup.placeName,
      'destinationAddress': destination.placeName,
      'location': pickUpMap,
      'destination': destinationUpMap,
      'payment_method': 'card',
      'driver_id': 'waiting',
    };

    rideRef.set(rideMap);
  }

  resetApp() {
    setState(() {
      polylineCoordinates.clear();
      _polylines.clear();
      _marker.clear();
      _circle.clear();
      rideDetails = 0;
      searchHeight = Platform.isAndroid ? 275 : 300;
      mapPaddingBottom = Platform.isAndroid ? 280 : 270;
      drawerOpener = true;
    });
    positionLocator();
  }

  void beginGeofireListener() {
    Geofire.initialize('DriversOnline');
    Geofire.queryAtLocation(
            currentPosition.latitude, currentPosition.longitude, 15)!
        .listen((map) {
      {
        print(map);
        if (map != null) {
          var callBack = map['callBack'];

          //latitude will be retrieved from map['latitude']
          //longitude will be retrieved from map['longitude']

          switch (callBack) {
            case Geofire.onKeyEntered:
              // Retrieve nearby drivers
              DriversNearby driversNearby = DriversNearby();
              driversNearby.key = map['key'];
              driversNearby.latitude = map['latitude'];
              driversNearby.longitude = map['longitude'];

              GeofireHelper.driversNearbyList.add(driversNearby);

              if (driversByKeysLoaded) {
                updateDriversOnMap();
              }
              break;

            case Geofire.onKeyExited:
              GeofireHelper.removeFromList(map['key']);
              updateDriversOnMap();
              break;

            case Geofire.onKeyMoved:
              // Update your key's location
              DriversNearby driversNearby = DriversNearby();
              driversNearby.key = map['key'];
              driversNearby.latitude = map['latitude'];
              driversNearby.longitude = map['longitude'];
              GeofireHelper.updateNearbyLocation(driversNearby);
              updateDriversOnMap();
              break;

            case Geofire.onGeoQueryReady:
              // All Intial Data is loaded
              driversByKeysLoaded = true;
              updateDriversOnMap();
              break;
          }
        }
      }
    });
  }

  void updateDriversOnMap() {
    setState(() {
      _marker.clear();
    });

    Set<Marker> tempMarker = Set<Marker>();
    for (DriversNearby driver in GeofireHelper.driversNearbyList) {
      LatLng driverPosition = LatLng(driver.latitude, driver.longitude);
      Marker thisMarker = Marker(
        markerId: MarkerId('drivers${driver.key}'),
        position: driverPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        rotation: HelperMethods.generateRandomNumber(360),
      );
      tempMarker.add(thisMarker);
    }
    setState(() {
      _marker = tempMarker;
    });
  }
}
