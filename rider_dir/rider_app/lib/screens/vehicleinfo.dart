import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rider_app/methods/input.dart';
import 'package:rider_app/methods/profileupdate.dart';
import 'package:rider_app/methods/toastmessages.dart';
import 'package:rider_app/screens/mainscreen.dart';
import 'package:rider_app/widgets/buttons.dart';
import 'package:rider_app/widgets/progress_dialog.dart';

class Motorinfo extends StatelessWidget {
  const Motorinfo({Key? key}) : super(key: key);

  static const String id = 'motorinfo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Icon(
                    Icons.motorcycle_rounded,
                    size: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text("Enter vehicle details"),
                        SizedBox(
                          height: 25,
                        ),
                        TextField(
                          controller: motorModelTextEditingController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Motor model',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                          ),
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(height: 10.0),
                        TextField(
                          controller: motorColorrTextEditingController,
                          decoration: InputDecoration(
                            labelText: "Motor Color",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                          ),
                          style: TextStyle(fontSize: 14.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextField(
                          controller: motorNumberTextEditingController,
                          maxLength: 12,
                          decoration: InputDecoration(
                            counterText: "",
                            labelText: 'Motor Number',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (motorModelTextEditingController.text.length <
                                3) {
                              displayToastMessage(
                                  "Specify a valid model number", context);
                            }
                            if (motorColorrTextEditingController.text.length <
                                3) {
                              displayToastMessage(
                                  "Please, provide a valid motor color",
                                  context);
                            }
                            if (motorNumberTextEditingController.text.length <
                                3) {
                              displayToastMessage(
                                  "Plese provide a valid motor number",
                                  context);
                            }

                            profileUpdate(context);
                            // Navigator.pushNamedAndRemoveUntil(
                            //     context, MainScreen.id, (route) => false);
                          },
                          style: Buttons.raisedButton,
                          child: Text("CONTINUE"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
