import 'package:flutter/material.dart';
import 'package:rider_app/brand_colors.dart';
import 'package:rider_app/widgets/buttons.dart';

class OnlineConfirmation extends StatelessWidget {
  // const OnlineConfirmation({Key? key}) : super(key: key);

  late var title;
  late var subtile;
  late var onPressed;

  OnlineConfirmation({this.title, this.subtile, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white30,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 18,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      height: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 24,
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 22,
                  fontFamily: "Brand Bold",
                  color: BrandColors.colorText),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              subtile,
              textAlign: TextAlign.center,
              style: TextStyle(color: BrandColors.colorTextLight),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Back"),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey,
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                        textStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    child: ElevatedButton(
                      onPressed: onPressed,
                      child: Text("Confirm"),
                      style: Buttons.raisedButton,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
