import 'package:client_app/brand_colors.dart';
import 'package:client_app/data_provider/appdata.dart';
import 'package:client_app/datamodels/address.dart';
import 'package:client_app/datamodels/predictions.dart';
import 'package:client_app/helper/requesthelper.dart';
import 'package:client_app/secret.dart';
import 'package:client_app/widgets/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PredictionTile extends StatelessWidget {
  final Prediction? prediction;
  PredictionTile({this.prediction});

  // Make places clickable
  Future<void> getPlaceDetails(String placeID, context) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog("Please wait"));
    String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$mapKey";
    var responses = await RequestHelper.getRequest(url);
    Navigator.pop(context);
    if (responses == 'failed') {
      return;
    }
    if (responses['status'] == 'OK') {
      // retrieve details of a place
      Address thisPlace = Address();
      thisPlace.placeName = responses['result']['name'];
      thisPlace.placeId = placeID;
      thisPlace.latitude = responses['result']['geometry']['location']['lat'];
      thisPlace.longitude = responses['result']['geometry']['location']['lng'];

      Provider.of<AppData>(context, listen: false)
          .updateDestinationAddress(thisPlace);
      print(thisPlace.placeName);

      Navigator.pop(context, 'getDirection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        getPlaceDetails(prediction!.placeId, context);
      },
      child: Container(
        child: Column(
          children: [
            Row(
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                Icon(
                  Icons.location_on,
                  color: BrandColors.colorDimText,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        prediction!.mainText.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 12, color: BrandColors.colorDimText),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        prediction!.secondaryText.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 12, color: BrandColors.colorDimText),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
