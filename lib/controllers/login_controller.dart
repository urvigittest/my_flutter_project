import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/models/login_model.dart';
import 'package:flutter_practicekiya/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:platform_device_id/platform_device_id.dart';
import '../models/general_model.dart';
import '../models/idstringname_model.dart';
import '../models/maincategory_model.dart';
import '../services/remote_services.dart';
import '../utils/functions.dart';
import '../utils/preferences.dart';
import '../utils/theme.dart';

class LoginController extends GetxController {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> loginOneFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> loginThreeFormKey = GlobalKey<FormState>();

  TextEditingController? emailController,
      mobileController,
      fnameController,
      lnameController,
      searchController;

  final RxBool obscureText = true.obs;
  Prefs prefs = Prefs.prefs;

  String otpCode = "";

  var isLoading = true.obs;

  // RxList<IdStringNameModel>? pickUpList = <IdStringNameModel>[].obs;
  // var pickUpList = List<IdStringNameModel>[].obs;

  // var products = List<IdStringNameModel>().obs;

  List<IdStringNameModel> pickUpList =
      List<IdStringNameModel>.empty(growable: true).obs;

  List<MainCategoryData> mainCategoryList =
      List<MainCategoryData>.empty(growable: true).obs;

  ScrollController controller = ScrollController();

  dynamic androidInfo;
  dynamic iosInfo;
  dynamic release;
  dynamic sdkInt;
  dynamic uniqueNumber;
  dynamic batteryLevel;
  dynamic version;
  dynamic buildNumber;
  dynamic manufacturer;
  dynamic model;
  dynamic appName;
  dynamic packageName;

  final count = 0.obs;

  List<MainCategoryData> selectedCategoryList =
      List<MainCategoryData>.empty(growable: true).obs;

  String firebaseToken = '';

  var loginModel = LoginModel().obs;
  String? userid = '';

  RxBool onNotification = false.obs; // our observable
  RxBool onDarkTheme = false.obs; // our observable

  final ImagePicker picker = ImagePicker();
  XFile? fileremove;

  @override
  void onInit() {
    super.onInit();
    initPlatformState();
    _getPrefsData();
    emailController = TextEditingController();
    mobileController = TextEditingController();
    fnameController = TextEditingController();
    lnameController = TextEditingController();
    searchController = TextEditingController();
  }

  @override
  void onClose() {
    // emailController!.dispose();
    // mobileController!.dispose();
    // fnameController!.dispose();
    // lnameController!.dispose();
    // searchController!.dispose();
    clearData();
  }

  void toggleNotification() {
    onNotification.value = onNotification.value ? false : true;

    getNotificationOnOff(onNotification.value ? '1' : '0');
  }

  void toggleDarkTheme() {
    onDarkTheme.value = onDarkTheme.value ? false : true;
  }

  Future _getPrefsData() async {
    firebaseToken = await Prefs.prefs.getFirebaseToken();
  }

  void clearData() {
    emailController!.clear();
    mobileController!.clear();
    fnameController!.clear();
    lnameController!.clear();
    otpCode = '';
  }

  void setValues() async {
    LoginModel loginModel =
        LoginModel.fromJson(await prefs.getLoginData("login"));

    userid = loginModel.data!.id.toString();
    fnameController!.text = loginModel.data!.firstname.toString();
    lnameController!.text = loginModel.data!.lastname.toString();
    emailController!.text = loginModel.data!.email.toString();
    mobileController!.text = loginModel.data!.mobile.toString();
  }

  Future<void> initPlatformState() async {
    if (Platform.isAndroid) {
      androidInfo = await DeviceInfoPlugin().androidInfo;
      uniqueNumber = await PlatformDeviceId.getDeviceId;
      release = androidInfo.version.release;
      sdkInt = androidInfo.version.sdkInt;
      manufacturer = androidInfo.manufacturer;
      model = androidInfo.model;

      if (kDebugMode) {
        print(uniqueNumber);
      }
    }

    if (Platform.isIOS) {
      iosInfo = await DeviceInfoPlugin().iosInfo;
      uniqueNumber = await PlatformDeviceId.getDeviceId;
      release = iosInfo.systemName;
      sdkInt = iosInfo.systemVersion;
      manufacturer = iosInfo.name;
      model = iosInfo.model;
      uniqueNumber = iosInfo.identifierForVendor;
    }
  }

  void checkLogin() {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    sendOTP('Login', '', '1', false);
  }

  void checkSignUp() {
    final isValid = loginOneFormKey.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      sendOTP('Signup', '', '0', false);
    }
  }

  void checkSignUpTwo(String screen, String mobileemail, String userid) {
    if (otpCode.length != 6) {
      showSnackBar("Invalid OTP", "Please enter OTP properly");
    } else {
      if (screen == 'Login' || userid != '0') {
        loginOTPVerify(screen, mobileemail, otpCode, uniqueNumber.toString(),
            firebaseToken, model.toString(), release.toString(), userid);
      } else if (screen == 'Signup') {
        signupOTPVerify(screen, mobileemail, otpCode, uniqueNumber.toString(),
            firebaseToken, model.toString(), release.toString());
      } else if (screen == 'Gmail') {
        gmailOTPVerify(
            screen,
            mobileemail,
            otpCode,
            uniqueNumber.toString(),
            firebaseToken,
            model.toString(),
            release.toString(),
            fnameController!.text,
            lnameController!.text,
            emailController!.text);
      }
    }
  }

  void checkSignUpThree(String screen, String mobileEmail, String userid,
      GlobalKey<FormState> formKey) {
    final isValid = formKey.currentState!.validate();
    // if (screen == 'Edit') {
    //   isValid = editProfileKey!.currentState!.validate();
    // } else if (screen == 'Profile') {
    //   isValid = loginThreeFormKey.currentState!.validate();
    // } else {
    //   isValid = editProfileKey!.currentState!.validate();
    // }
    if (!isValid) {
      return;
    } else {
      if (screen == 'Gmail') {
        sendOTP(screen, '', '0', false);
      } else {
        fillProfile(screen, mobileEmail, fnameController!.text,
            lnameController!.text, emailController!.text);
      }
    }
  }

  void checkSelectedCategories(String screen) {
    if (selectedCategoryList.isEmpty) {
      return showSnackBar("Goals", 'Select atleast 1 goal');
    } else {
      String categoryids = '';
      for (int i = 0; i < selectedCategoryList.length; i++) {
        if (categoryids.isEmpty) {
          categoryids = selectedCategoryList[i].categoryid.toString();
        } else {
          categoryids =
              categoryids + ',' + selectedCategoryList[i].categoryid.toString();
        }
      }
      addUserGoalCategories(screen, categoryids);
    }
  }

  void sendOTP(
      String screen, String mobileemail, String isLogin, bool resendOTP) async {
    try {
      showLoader();
      var sendOTP = await RemoteServices.instance
          .sendOTP(screen, mobileController!.text, isLogin);
      if (sendOTP != null) {
        if (sendOTP.status!) {
          // prefs.setLoggedIn('1');
          // prefs.setLoginData('login', loginData);

          if (!resendOTP) {
            getItRegister<Map<String, dynamic>>({
              'screen': screen,
              'userid': sendOTP.userId.toString(),
              'mobileemail': screen == 'Login'
                  ? mobileController!.text
                  : mobileController!.text,
            }, name: "selected_logintype");

            if ((screen == 'Login') && sendOTP.userId.toString() == '0') {
              showSnackBar("User not found", "Invalid Username or Password!");
            } else {
              Get.toNamed(AppRoutes.signupsecond);
            }
          }
        }
      }
    } finally {
      hideLoader();
    }
  }

  void signupOTPVerify(
      String screen,
      String mobileemail,
      String otp,
      String deviceid,
      String firebaseid,
      String modelnumber,
      String androidversion) async {
    try {
      showLoader();
      var loginData = await RemoteServices.instance.signupOTPVerify(
          screen,
          mobileController!.text,
          otp,
          deviceid,
          firebaseid,
          modelnumber,
          androidversion);
      if (loginData != null) {
        if (loginData.status!) {
          prefs.setLoggedIn('1');
          prefs.setLoginData('login', loginData);
          Get.toNamed(AppRoutes.signupthird);
        }
      }
    } finally {
      hideLoader();
    }
  }

  void loginOTPVerify(
    String screen,
    String mobileemail,
    String otp,
    String deviceid,
    String firebaseid,
    String modelnumber,
    String androidversion,
    String userid,
  ) async {
    try {
      showLoader();
      var loginData = await RemoteServices.instance.loginOTPVerify(
        screen,
        mobileemail,
        otp,
        deviceid,
        firebaseid,
        modelnumber,
        androidversion,
        userid,
      );
      if (loginData != null) {
        if (loginData.status!) {
          prefs.setLoggedIn('1');
          prefs.setLoginData('login', loginData);
          if (loginData.data!.mobile == '' ||
              loginData.data!.email == '' ||
              loginData.data!.firstname == '' ||
              loginData.data!.lastname == '') {
            Get.toNamed(AppRoutes.signupthird);
          } else if (loginData.data!.isCategorySelected == 0) {
            Get.toNamed(AppRoutes.signupfourth);
          } else {
            clearData();
            Get.toNamed(AppRoutes.dashboard);
          }
        }
      }
    } finally {
      hideLoader();
    }
  }

  void gmailOTPVerify(
    String screen,
    String mobileemail,
    String otp,
    String deviceid,
    String firebaseid,
    String modelnumber,
    String androidversion,
    String firstname,
    String lastname,
    String email,
  ) async {
    try {
      showLoader();
      var loginData = await RemoteServices.instance.gmailOTPVerify(
        screen,
        mobileemail,
        otp,
        deviceid,
        firebaseid,
        modelnumber,
        androidversion,
        firstname,
        lastname,
        email,
      );
      if (loginData != null) {
        if (loginData.status!) {
          prefs.setLoggedIn('1');
          prefs.setLoginData('login', loginData);
          if (loginData.data!.mobile == '' ||
              loginData.data!.email == '' ||
              loginData.data!.firstname == '' ||
              loginData.data!.lastname == '') {
            Get.toNamed(AppRoutes.signupthird);
          } else if (loginData.data!.isCategorySelected == 0) {
            Get.toNamed(AppRoutes.signupfourth);
          } else {
            clearData();
            Get.toNamed(AppRoutes.dashboard);
          }
        }
      }
    } finally {
      hideLoader();
    }
  }

  void fillProfile(
    String screen,
    String mobileemail,
    String firstname,
    String lastname,
    String email,
  ) async {
    try {
      showLoader();
      var loginData = await RemoteServices.instance
          .fillProfile(screen, mobileemail, firstname, lastname, email);
      if (loginData != null) {
        if (loginData.status!) {
          prefs.setLoggedIn('1');
          prefs.setLoginData('login', loginData);
          if (screen == 'Edit') {
            // clearData();
            Get.toNamed(AppRoutes.dashboard);
          } else if (screen == 'Profile') {
            clearData();
            Get.toNamed(AppRoutes.dashboard);
          } else {
            Get.toNamed(AppRoutes.signupfourth);
          }
        }
      }
    } finally {
      hideLoader();
    }
  }

  void getSelectedCategory(bool isShowLoading) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);
      selectedCategoryList.clear();
      mainCategoryList.clear();
      MainCategoryModel? model =
          await RemoteServices.instance.getSelectedCategory();

      selectedCategoryList.addAll(model!.data!);
      searchMainCategory(true, '');
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void searchMainCategory(bool isShowLoading, String searchkeyword) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);
      mainCategoryList.clear();
      MainCategoryModel? model =
          await RemoteServices.instance.searchMainCategory(searchkeyword);

      selectedCategoryList.toSet().toList();

      print('NOT SELECTED 1');

      if (selectedCategoryList.isNotEmpty) {
        for (int i = 0; i < model!.data!.length; i++) {
          bool isSelected = false;
          for (int j = 0; j < selectedCategoryList.length; j++) {
            if (selectedCategoryList[j].categoryid.toString() ==
                model.data![i].categoryid.toString()) {
              isSelected = true;
            }
          }
          if (!isSelected) {
            mainCategoryList.add(model.data![i]);
          }
        }
      } else {
        mainCategoryList.addAll(model!.data!);
      }
      // // mainCategoryList.toSet().toList();
      // final Map<String, MainCategoryData> profileMap = new Map();
      // mainCategoryList.forEach((item) {
      //   profileMap[item.name!] = item;
      // });
      // mainCategoryList = profileMap.values.toList();
      // print('urvicalled-->' + mainCategoryList.length.toString());
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void addSelectedCategory(int index) async {
    selectedCategoryList.add(mainCategoryList[index]);
    mainCategoryList.removeAt(index);
  }

  void removeSelectedCategory(int index) async {
    mainCategoryList.add(selectedCategoryList[index]);
    selectedCategoryList.removeAt(index);
  }

  void addUserGoalCategories(String screen, String categoryids) async {
    try {
      showLoader();

      var serviceData = await RemoteServices.instance
          .addUserGoalCategories(screen, categoryids);
      if (serviceData != null) {
        if (serviceData.status!) {
          if (screen == 'Edit') {
            Get.back();
          } else {
            clearData();

            Get.toNamed(AppRoutes.dashboard);
          }
        }
      }
    } finally {
      hideLoader();
    }
  }

  // void fetchGoalsList(bool isShowLoading) async {
  //   try {
  //     if (isShowLoading) {
  //       showLoader();
  //     }
  //     isLoading(true);
  //     pickUpList.clear();
  //     List<IdStringNameModel>? model = await RemoteServices.pickUpList(0);
  //     pickUpList.addAll(model!);
  //   } finally {
  //     if (isShowLoading) {
  //       hideLoader();
  //     }
  //     isLoading(false);
  //   }
  // }

  void getProfile() async {
    try {
      showLoader();

      isLoading(true);

      LoginModel? model = await RemoteServices.instance.getProfile();
      loginModel.value = model!;

      onNotification.value = model.data!.isnotificationsend == 1 ? true : false;

      prefs.setLoginData('login', model);
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void getNotificationOnOff(String onoff) async {
    try {
      showLoader();

      isLoading(true);

      MainCategoryModel? model =
          await RemoteServices.instance.getNotificationOnOff(onoff);
    } finally {
      hideLoader();

      isLoading(false);
    }
  }

  void uploadProfileDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: ((BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(15),
            )),
            title: const Text(
              "Upload Profile Photo",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.back();
                      imageSelectorCamera();
                    },
                    child: Container(
                        height: 35,
                        width: 120,
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        decoration: boxDecorationValidTill(
                            kPrimaryColorDark, kPrimaryColorDarkLight, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.camera_enhance_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      imageSelectorGallery();
                    },
                    child: Container(
                      height: 35,
                      width: 120,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: boxDecorationRectBorder(
                          Colors.white, Colors.white, kDarkBlueColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.add_photo_alternate_rounded,
                            size: 20,
                            color: kDarkBlueColor,
                          ),
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: kDarkBlueColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              loginModel.value.data!.image != ''
                  ? SizedBox(
                      height: 10,
                    )
                  : Container(),
              loginModel.value.data!.image != ''
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                            Get.back();
                            getProfilePhotoUpdate(fileremove, '1');
                          },
                          child: Container(
                            height: 35,
                            width: 150,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            decoration: boxDecorationRectBorder(
                                Colors.white, Colors.white, Colors.red),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.remove_circle_rounded,
                                  size: 20,
                                  color: Colors.red,
                                ),
                                Text(
                                  "Remove Photo",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          );
        }));
  }

  imageSelectorCamera() async {
    picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((XFile? value) {
      if (value != null) {
        // fileOne.value = value.obs;
        getProfilePhotoUpdate(value, '0');
      }
    });
  }

  imageSelectorGallery() async {
    picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((XFile? value) {
      if (value != null) {
        // fileOne.value = value.obs;
        getProfilePhotoUpdate(value, '0');
      }
    });
  }

  void getProfilePhotoUpdate(XFile? file, String isRemove) async {
    try {
      showLoader();

      GeneralModel? model =
          await RemoteServices.instance.getProfilePhotoUpdate(file, isRemove);

      getProfile();

      if (model!.status!) {}
    } finally {
      hideLoader();
    }
  }
}
