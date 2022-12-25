import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import '../routes/app_routes.dart';
import '../utils/preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String isLogin = "";
  String letsStart = "";
  Prefs prefs = Prefs.prefs;

  @override
  void initState() {
    _getPrefsData();
    super.initState();
  }

  Future _getPrefsData() async {
    isLogin = await Prefs.prefs.getLoggedIn();
    letsStart = await Prefs.prefs.getLetsStart();
    startTime();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/splash_image_back.gif'),
          fit: BoxFit.contain,
        ),
        color: Colors.white,
      ),
      // child: GifView.asset(
      //   'assets/images/splash_image_back.gif',
      //   loop: false,
      //   // frameRate: 40,
      //   onFinish: () {
      //     // practiceMCQController!.showGif.value = false;
      //   },
      // ),
    );
  }

  startTime() async {
    var _duration = const Duration(seconds: 5);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    prefs.setFirebaseCalled('');
    if (letsStart == '1' && isLogin != '1') {
      Get.offAndToNamed(AppRoutes.login);
    } else if (letsStart == '1' && isLogin == '1') {
      Get.offAndToNamed(AppRoutes.dashboard);
    } else {
      Get.offAndToNamed(AppRoutes.letsgetstarted);
    }
  }

  void getToken() async {
    String? token = await FirebaseMessaging.instance.getToken().then((token) {
      print(token);
      setState(() {
        prefs.setFirebaseToken(token!);
      });
    });
  }
}
