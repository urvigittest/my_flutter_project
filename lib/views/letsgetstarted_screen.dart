import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/utils/preferences.dart';
import 'package:flutter_practicekiya/utils/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class LetsGetStartedScreen extends StatelessWidget {
  const LetsGetStartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Prefs.prefs.setLetsStart('1');

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            flex: 8,
            child: Container(
              // height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/letsgetstarted.png'),
                    fit: BoxFit.cover),
              ),
            )),
        Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: Text(
                    'The Best Online Exam App',
                    textScaleFactor: 1,
                    style: TextStyle(
                        color: kPrimaryColorDark,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    'Practice Kiya is online education',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2),
                  child: Text(
                    'platform for Student',
                    style: TextStyle(
                      color: kTextColor,
                      fontSize: 12.sp,
                    ),
                  ),
                )
              ],
            )),
        GestureDetector(
          onTap: () {
            Get.offAndToNamed(AppRoutes.login);
          },
          child: Container(
            height: 50,
            margin:
                const EdgeInsets.only(top: 12, bottom: 12, right: 20, left: 20),
            decoration: boxDecorationRect(kPrimaryColor, kPrimaryColorLight),
            child: Center(
              child: Text(
                "Let's Get Started",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
