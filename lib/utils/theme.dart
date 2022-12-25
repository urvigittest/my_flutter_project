import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

const kPrimaryColor = Color(0XFFF2620F);
const kPrimaryColorLight = Color(0XFFf59157);
const kPrimaryColorLightest = Color(0XFFfcdfcf);
const kPrimaryColorDark = Color(0XFF0B3D76);
const kPrimaryColorDarkLight = Color.fromARGB(255, 66, 109, 159);
const kSecondaryColor = Color(0xFFcdcdcd);
const kTextColor = Color(0xFF757575);
const kErrorColor = Color(0xFFEF5350);
const kHintColor = Color(0x99282828);
const kDarkBlueColor = Color(0xFF2A50FF);
const kBlueColor = Color(0xFF6AAFEF);
const kLightBlueColor = Color(0xFFE4F2FF);
const kYellowColor = Color(0xFFFCD03C);
const kLightYellowColor = Color(0xFFFFF5D2);
const kPurpleColor = Color(0xFFB99EE3);
const kLightPurpleColor = Color(0xFFF4ECFF);
const kBackgroundColor = Color.fromRGBO(246, 248, 255, 0.86);
const kChartGreenColor = Color(0xFF8DE88F);
const kChartOrangeColor = Color(0xFFF48D52);

class CustomColors {
  static final Color firebaseNavy = Color(0xFF2C384A);
  static final Color firebaseOrange = Color(0xFFF57C00);
  static final Color firebaseAmber = Color(0xFFFFA000);
  static final Color firebaseYellow = Color(0xFFFFCA28);
  static final Color firebaseGrey = Color(0xFFECEFF1);
  static final Color googleBackground = Color(0xFF4285F4);
}

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Cambria",
    primaryColor: kPrimaryColor,
    primaryColorDark: kPrimaryColorDark,
    // textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

void showLoader() {
  EasyLoading.show(
    status: 'loading...',
    maskType: EasyLoadingMaskType.custom,
  );
}

void hideLoader() {
  EasyLoading.dismiss();
}

OutlineInputBorder tranparentBorder() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      borderSide: BorderSide(color: Colors.transparent, width: 1));
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder underlineInputBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        // borderSide: BorderSide(color: kSecondaryColor, width: 1)
        borderSide: BorderSide(color: kSecondaryColor, width: 1));
  }

  OutlineInputBorder underlineErrorBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        // borderSide: BorderSide(color: kErrorColor, width: 1)
        borderSide: BorderSide(color: kSecondaryColor, width: 1));
  }

  OutlineInputBorder underlineFocusedBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        // borderSide: BorderSide(color: kPrimaryColor, width: 1)
        borderSide: BorderSide(color: kSecondaryColor, width: 1));
  }

  return InputDecorationTheme(
    enabledBorder: underlineInputBorder(),
    border: underlineInputBorder(),
    errorBorder: underlineErrorBorder(),
    focusedBorder: underlineFocusedBorder(),
    focusedErrorBorder: underlineInputBorder(),

    // fillColor: Colors.white,
    // filled: true,

    contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
    hintStyle: const TextStyle(fontSize: 14),
    errorStyle: const TextStyle(fontSize: 10),
    errorMaxLines: 1,
    labelStyle: const TextStyle(color: kTextColor, fontSize: 14),
  );
}

BoxDecoration boxDecorationRect(Color color1, Color color2) {
  BoxDecoration boxdecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color1,
        color2,
      ],
    ),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    boxShadow: const <BoxShadow>[
      BoxShadow(
          color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 0.25))
    ],
    // color: color
  );
  return boxdecoration;
}

BoxDecoration boxDecorationStep(Color color1, Color color2, Color color3) {
  BoxDecoration boxdecoration = BoxDecoration(
    gradient: RadialGradient(
      colors: [
        color1,
        color2,
      ],
    ),
    border: Border.all(color: color3),
    borderRadius: const BorderRadius.all(Radius.circular(100)),
    // boxShadow: const <BoxShadow>[
    //   BoxShadow(
    //       color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 0.25))
    // ],
  );
  return boxdecoration;
}

BoxDecoration boxDecorationTab(Color color1, Color color2) {
  BoxDecoration boxdecoration = BoxDecoration(
    gradient: RadialGradient(
      colors: [
        color1,
        color2,
      ],
    ),
    border: Border.all(color: kPrimaryColorDark),
    borderRadius: const BorderRadius.all(Radius.circular(15)),
    // boxShadow: const <BoxShadow>[
    //   BoxShadow(
    //       color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 0.25))
    // ],
  );
  return boxdecoration;
}

BoxDecoration boxDecorationRectBorder(
    Color color1, Color color2, Color borderColor) {
  BoxDecoration boxdecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color1,
        color2,
      ],
    ),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    border: Border.all(color: borderColor, width: 0.5),
  );
  return boxdecoration;
}

BoxDecoration boxDecorationValidTill(
    Color color1, Color color2, double radius) {
  BoxDecoration boxdecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        color1,
        color2,
      ],
    ),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
  return boxdecoration;
}

BoxDecoration boxDecorationRevise(Color color1, Color color2, double radius) {
  BoxDecoration boxdecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [
        color1,
        color2,
      ],
    ),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
  return boxdecoration;
}

BoxDecoration boxDecorationDialog(
    Color color1, Color color2, Color borderColor) {
  BoxDecoration boxdecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color1,
        color2,
      ],
    ),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    border: Border.all(color: borderColor, width: 1),
  );
  return boxdecoration;
}
