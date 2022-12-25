import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/utils/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/idstringname_model.dart';
import '../views/testmcq_screen.dart';

//VALIDATIONS

String? validateEmail(String value) {
  if (!GetUtils.isEmail(value)) {
    return "Provide valid Email";
  }
  return null;
}

String? validateFname(String value) {
  if (value.isEmpty) {
    return "Enter First Name";
  }
  return null;
}

String? validateLname(String value) {
  if (value.isEmpty) {
    return "Enter Last Name";
  }
  return null;
}

String? validateMobile(String value) {
  if (!GetUtils.isNumericOnly(value)) {
    return "Enter numbers only";
  } else if (value.length != 10) {
    return "Provide valid Mobile Number";
  }
  // if (!GetUtils.isPhoneNumber(value)) {
  //   return "Provide valid Mobile Number";
  // }
  return null;
}

String? validateMobileOrEmail(String value) {
  if (value.isEmpty) {
    return "Enter Mobile Number / Email Address";
  } else if (value.length != 10 && GetUtils.isNumericOnly(value)) {
    return "Provide valid Mobile Number.";
  } else if (!GetUtils.isEmail(value) && !GetUtils.isNumericOnly(value)) {
    return "Provide valid Email Address";
  }
  return null;
}

String? validatePassword(String value) {
  if (value.length < 6) {
    return "Password must be of 6 characters";
  }
  return null;
}

String? validateReportComment(String value) {
  if (value.isEmpty) {
    return "Write report comments";
  }
  return null;
}

String? validateAddress1(String value) {
  if (value.isEmpty) {
    return "Please enter address 1";
  }
  return null;
}

String? validateComments(String value) {
  if (value.isEmpty) {
    return "Please enter comments";
  }
  return null;
}

String? validateAddress2(String value) {
  if (value.isEmpty) {
    return "Please enter address 2";
  }
  return null;
}

String? validateAddress3(String value) {
  if (value.isEmpty) {
    return "Please enter address 3";
  }
  return null;
}

String? validatePincode(String value) {
  if (!GetUtils.isNumericOnly(value) || value.length != 6) {
    return "Provide valid pincode";
  }

  return null;
}

//WIDGETS

void showSnackBar(String title, String content) {
  Get.snackbar(title, content,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
      borderRadius: 5,
      barBlur: 0,
      backgroundColor: kPrimaryColor);
}

void showFlutterToast(String content) {
  Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: kPrimaryColorDark,
      textColor: Colors.white,
      fontSize: 14.sp);
}

Future<void> launchIn(String url) async {
  if (kDebugMode) {
    print(url);
  }
  try {
    Uri uri = Uri.parse(url.replaceAll(' ', '%20'));
    await launchUrl(uri);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

List<IdStringNameModel> getExamType() {
  return [
    IdStringNameModel(id: 1, name: 'Practice'),
    IdStringNameModel(id: 2, name: 'Test series'),
    IdStringNameModel(id: 3, name: 'PYQs'),
  ];
}

void getItRegister<T extends Object>(T t, {String? name}) {
  if (GetIt.I.isRegistered<T>(instanceName: name)) {
    GetIt.I.unregister<T>(instanceName: name);
  }
  GetIt.I.registerSingleton<T>(t, instanceName: name);
}

onSharePage(BuildContext context, String subcategory, String subject) async {
  var link = await createDynamicLink();

  Share.share(
    subcategory + " " + subject + '\n' + '\n' + link,
    subject:
        'PracticeKiya Share ' + subcategory + ' ' + subject + ' ' + ' Details',
  );
}

Future<String> createDynamicLink() async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://practicekiya.page.link',
    link: Uri.parse(
        'https://practicekiya.page.link.com/sharesubjectdetail?subject_id=' +
            "12"),
    androidParameters: AndroidParameters(
      packageName: 'com.practicekiya.app',
    ),
    iosParameters: IosParameters(
      bundleId: 'com.practicekiya.app',
      // appStoreId: '1553862445',
    ),
  );
  var dynamicUrl = await parameters.buildUrl();
  var shortLink = await parameters.buildShortLink();
  var shortUrl = shortLink.shortUrl;

  return shortUrl.toString();
}
