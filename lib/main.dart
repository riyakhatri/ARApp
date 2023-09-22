import 'dart:io';

import 'package:cam/auth/login_screen.dart';
import 'firebase_options.dart';
import 'package:cam/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cam/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyAtBAwiJepuN1vYGZkxLnFdThXgzL1_MYk",
              appId: "1:948681925565:android:10ca93d54b1cd1050d28d4",
              messagingSenderId: "948681925565",
              projectId: "sem7-c0462"))
      : await Firebase.initializeApp();
  // Obtain a list of the available cameras on the device.
  runApp(const MyApp());
}

var user = FirebaseAuth.instance.currentUser;

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return GetMaterialApp(
        theme: ThemeData(appBarTheme: const AppBarTheme(elevation: 0.0)),
        debugShowCheckedModeBanner: false,
        title: 'Camera App',
        home: user == null ? const LoginScreen() : const MainPage(),
        // home: MainPage(),
      );
    }));
  }
}
