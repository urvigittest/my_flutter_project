import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/controllers/dashboard_controller.dart';
import 'package:flutter_practicekiya/controllers/login_controller.dart';
import 'package:flutter_practicekiya/controllers/payment_controller.dart';
import 'package:flutter_practicekiya/utils/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../utils/functions.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  LoginController? loginController;
  PaymentController? paymentController;
  DashboardController? dashboardController;
  String countryCode = 'in';
  String flag = '';
  GlobalKey<FormState>? editProfileKey;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    loginController = Get.find<LoginController>();
    paymentController = Get.find<PaymentController>();
    dashboardController = Get.find<DashboardController>();

    editProfileKey = GlobalKey<FormState>();
    loginController!.setValues();
  }

  void editBack() {}

  @override
  Widget build(BuildContext context) {
    flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return WillPopScope(
      onWillPop: () async {
        dashboardController!.tabIndex.value = 0;
        dashboardController!.changeTabIndex(0);
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            alignment: Alignment.center,
            child: Padding(
                padding: const EdgeInsets.all(0),
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/wholeappback.jpg'),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.white,
                      ),
                    ),
                    Form(
                      key: editProfileKey,
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              // border: Border.all(color: kPrimaryColorDark),
                              color: kPrimaryColorDark,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Column(children: [
                              paymentController!.appBar(false, 'Edit Profile',
                                  kPrimaryColorDark, context, scaffoldKey),
                            ]),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                child: TextFormField(
                                  controller: loginController!.fnameController,
                                  keyboardType: TextInputType.name,
                                  textCapitalization: TextCapitalization.words,
                                  autofocus: false,
                                  style: TextStyle(fontSize: 14.sp),
                                  validator: (value) {
                                    return validateFname(value!);
                                  },
                                  decoration: const InputDecoration(
                                      hintText: 'First Name',
                                      labelText: 'First Name',
                                      hintStyle:
                                          TextStyle(color: kSecondaryColor)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                child: TextFormField(
                                  controller: loginController!.lnameController,
                                  keyboardType: TextInputType.name,
                                  textCapitalization: TextCapitalization.words,
                                  autofocus: false,
                                  style: TextStyle(fontSize: 14.sp),
                                  validator: (value) {
                                    return validateLname(value!);
                                  },
                                  decoration: const InputDecoration(
                                      hintText: 'Last Name',
                                      labelText: 'Last Name',
                                      hintStyle:
                                          TextStyle(color: kSecondaryColor)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                child: TextFormField(
                                  controller: loginController!.emailController,
                                  keyboardType: TextInputType.name,
                                  autofocus: false,
                                  style: TextStyle(fontSize: 14.sp),
                                  validator: (value) {
                                    return validateEmail(value!);
                                  },
                                  decoration: const InputDecoration(
                                      hintText: 'Email Address',
                                      labelText: 'Email Address',
                                      hintStyle:
                                          TextStyle(color: kSecondaryColor)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                child: TextFormField(
                                  controller: loginController!.mobileController,
                                  readOnly: true,
                                  keyboardType: TextInputType.phone,
                                  autofocus: false,
                                  style: TextStyle(fontSize: 14.sp),
                                  validator: (value) {
                                    return validateMobile(value!);
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: SizedBox(
                                        width: 70,
                                        child: Row(children: [
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(flag),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              '+91',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Container(
                                            color: kSecondaryColor,
                                            width: 1,
                                            height: 30,
                                            alignment: Alignment.center,
                                          )
                                        ]),
                                      ),
                                      hintText: 'Mobile Number',
                                      labelText: 'Mobile Number',
                                      hintStyle: const TextStyle(
                                          color: kSecondaryColor)),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoutes.editcategory);
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  alignment: Alignment.centerRight,
                                  child: const Text(
                                    'Edit Category',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: kPrimaryColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              loginController!.checkSignUpThree(
                                  'Edit',
                                  loginController!.mobileController!.text,
                                  loginController!.userid!,
                                  editProfileKey!);
                            },
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(
                                  top: 12, bottom: 12, right: 20, left: 20),
                              decoration: boxDecorationRect(
                                  kPrimaryColor, kPrimaryColorLight),
                              child: const Center(
                                child: Text(
                                  "Edit",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
