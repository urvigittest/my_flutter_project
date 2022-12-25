import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'utils/notifier_helper.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotifyHelper.instance.initializeNotification();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
  configLoading();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  print("message recieved _firebaseMessagingBackgroundHandler");

  // print(message.notification.body);
  // print(message.data.values);
  // print(message.data);
}

void configLoading() {
  EasyLoading.instance

    // ..displayDuration = const Duration(milliseconds: 2000)
    // ..indicatorType = EasyLoadingIndicatorType.dualRing
    // ..loadingStyle = EasyLoadingStyle.light
    // ..indicatorColor = kPrimaryColor
    // ..backgroundColor = kPrimaryColorDark
    // ..indicatorSize = 45.0
    // ..radius = 10.0
    // ..userInteractions = false
    // ..dismissOnTap = false
    // ..customAnimation = CustomAnimation();
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ripple
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = kPrimaryColor
    ..backgroundColor = kPrimaryColorDark
    ..indicatorColor = kPrimaryColor
    ..textColor = kPrimaryColor
    ..maskColor = kPrimaryColorDark.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();
  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          builder: EasyLoading.init(builder: (context1, child1) {
            return MediaQuery(
                data: MediaQuery.of(context1).copyWith(
                  textScaleFactor: 1.0,
                ),
                child: child1!);
          }),

          debugShowCheckedModeBanner: false,
          initialRoute: AppRoutes.root,
          title: 'PracticeKiya',
          theme: theme(),
          getPages: AppPages.pages,

          // darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.red),
          // themeMode: ThemeMode.dark,

          // highContrastTheme: ThemeData(
          //   brightness: Brightness.light,
          //   /* light theme settings */
          // ),
          // darkTheme: ThemeData(
          //   brightness: Brightness.dark,
          //   /* dark theme settings */
          // ),

          /* ThemeMode.system to follow system theme, 
         ThemeMode.light for light theme, 
         ThemeMode.dark for dark theme
      */
        );
      },
    );
  }
}
