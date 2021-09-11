import 'package:client_app/methods/input.dart';
import 'package:client_app/methods/networkconnectivitycheck.dart';
import 'package:client_app/methods/signin.dart';
import 'package:client_app/methods/toastmessages.dart';
import 'package:client_app/screens/signuppage.dart';
import 'package:client_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  static const String id = 'login';
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 150,
                ),
                Icon(Icons.login_rounded),
                SizedBox(height: 40.0),
                Text(
                  'Sign In As Client',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: "Brand-Bold"),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 14.0,
                      ),
                      ElevatedButton(
                        style: Buttons.raisedButton,
                        child: Text("Log In"),
                        onPressed: () {
                          // method for checking network connectivity
                          checkConnectivity(context);
                          if (!emailTextEditingController.text.contains("@")) {
                            displayToastMessage("Enter a valid email", context);
                            return;
                          }
                          if (passwordTextEditingController.text.length < 8) {
                            displayToastMessage(
                                "Password must be greater than 10", context);
                            return;
                          }
                          loginUser(context);
                        },
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black87)),
                          child: Text("Click Here to Sign Up"),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, SignUp.id, (route) => false);
                          })
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
