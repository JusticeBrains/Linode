import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rider_app/globalvariable.dart';
import 'package:rider_app/screens/login.dart';
import 'package:rider_app/screens/mainscreen.dart';
import 'package:rider_app/screens/signup.dart';
import 'package:rider_app/screens/vehicleinfo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  // ignore: await_only_futures
  currentFirebaseUser = await FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver App',
      theme: ThemeData(
        fontFamily: 'Brand-Reqular',
        primarySwatch: Colors.blue,
      ),
      initialRoute:
          (currentFirebaseUser == null) ? LoginScreen.id : MainScreen.id,
      routes: {
        MainScreen.id: (context) => MainScreen(),
        SignUp.id: (context) => SignUp(),
        LoginScreen.id: (context) => LoginScreen(),
        Motorinfo.id: (context) => Motorinfo(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
