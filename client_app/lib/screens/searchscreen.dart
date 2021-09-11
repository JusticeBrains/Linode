import 'package:client_app/brand_colors.dart';
import 'package:client_app/data_provider/appdata.dart';
import 'package:client_app/datamodels/predictions.dart';
import 'package:client_app/helper/requesthelper.dart';
import 'package:client_app/methods/input.dart';
import 'package:client_app/widgets/app_divider.dart';
import 'package:client_app/widgets/prediction_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../secret.dart';

class ScreenScreen extends StatefulWidget {
  const ScreenScreen({Key? key}) : super(key: key);

  @override
  _ScreenScreenState createState() => _ScreenScreenState();
}

class _ScreenScreenState extends State<ScreenScreen> {
  var focusDestination = FocusNode();

  bool focused = false;
  void setFocus() {
    if (!focused) {
      FocusScope.of(context).requestFocus(focusDestination);
      focused = true;
    }
  }

  List<Prediction> destinationPredictionList = [];
  void searchPlace(String placeName) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:gh';

    if (placeName.length > 2) {
      var responses = await RequestHelper.getRequest(url);

      if (responses == 'failed') {
        return;
      }
      if (responses['status'] == 'OK') {
        var jsonPredictions = responses['predictions'];

        var thisList = (jsonPredictions as List)
            .map((e) => Prediction.fromJson(e))
            .toList();
        setState(() {
          destinationPredictionList = thisList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String address =
        Provider.of<AppData>(context).pickupAddress.placeName ?? '';
    pickUpEditingController.text = address;

    setFocus();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 240,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ]),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 24, top: 48, right: 24, bottom: 20),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        Stack(children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.arrow_back)),
                          Center(
                            child: Text(
                              "Set Destination",
                              style: TextStyle(
                                  fontSize: 20, fontFamily: "Brand-Bold"),
                            ),
                          ),
                        ]),
                        SizedBox(
                          height: 18,
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'images/pickicon.png',
                              height: 16,
                              width: 16,
                            ),
                            SizedBox(
                              width: 18.0,
                            ),
                            Expanded(
                              child: Container(
                                child: TextField(
                                  controller: pickUpEditingController,
                                  decoration: InputDecoration(
                                    hintText: 'Pickup Joint',
                                    fillColor: BrandColors.colorLightGrayFair,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.blue.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(15),
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'images/desticon.png',
                              height: 16,
                              width: 16,
                            ),
                            SizedBox(
                              width: 18.0,
                            ),
                            Expanded(
                              child: Container(
                                child: TextField(
                                  onChanged: (value) {
                                    searchPlace(value);
                                  },
                                  focusNode: focusDestination,
                                  controller: destinationTextEditingController,
                                  decoration: InputDecoration(
                                    hintText: 'Where To',
                                    fillColor: BrandColors.colorLightGrayFair,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.blue.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(15),
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                (destinationPredictionList.length > 0)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListView.separated(
                          padding: EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return PredictionTile(
                              prediction: destinationPredictionList[index],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              AppDivider(),
                          itemCount: destinationPredictionList.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
