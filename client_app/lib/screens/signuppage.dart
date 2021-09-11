import 'package:client_app/methods/adduser.dart';
import 'package:client_app/methods/input.dart';
import 'package:client_app/methods/networkconnectivitycheck.dart';
import 'package:client_app/methods/toastmessages.dart';
import 'package:client_app/screens/loginscreen.dart';
import 'package:client_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  static const String id = 'signup';

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
                  height: 120,
                ),
                // Image(
                //   image: AssetImage('images/logo.png'),
                //   width: 100,
                //   height: 100,
                //   alignment: Alignment.center,
                // ),
                Icon(
                  Icons.login_rounded,
                ),
                SizedBox(height: 40.0),
                Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: "Brand-Bold"),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      // Full Name
                      TextField(
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Email
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
                      // PhoneNumber
                      TextField(
                        controller: phonenumberTextEditingController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Password
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
                        child: Text("Sign Up"),
                        onPressed: () async {
                          // Check for network availability
                          checkConnectivity(context);
                          if (nameTextEditingController.text.length < 3) {
                            displayToastMessage("Name too short!!!", context);
                            return;
                          }

                          if (!emailTextEditingController.text.contains("@")) {
                            displayToastMessage("Enter a valid email", context);
                            return;
                          }
                          if (phonenumberTextEditingController.text.length <
                              10) {
                            displayToastMessage(
                                "Provide a valid phone number", context);
                            return;
                          }
                          if (passwordTextEditingController.text.length < 10) {
                            displayToastMessage(
                                "Password must be greater than 10", context);
                            return;
                          }
                          addNewUser(context);
                        },
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black87)),
                          child: Text("Already Have An Account Log in Here"),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, LoginScreen.id, (route) => false);
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
