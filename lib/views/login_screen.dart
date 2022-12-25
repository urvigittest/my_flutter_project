import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/login_controller.dart';
import '../routes/app_routes.dart';
import '../utils/functions.dart';
import '../utils/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController? loginController;
  DashboardController? dashboardController;
  @override
  void initState() {
    super.initState();
    loginController = Get.find<LoginController>();
    dashboardController = Get.find<DashboardController>();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        dashboardController!.exitDialog(context);
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
                      key: loginController!.loginFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              flex: 5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(
                                        top: 0, bottom: 0, right: 0, left: 0),
                                    width: 200,
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/app_logo.png'),
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 50,
                                        ),
                                        alignment: Alignment.center,
                                        child: Text('Login',
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                color: Colors.black)),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: TextFormField(
                                      controller:
                                          loginController!.mobileController,
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(fontSize: 14.sp),
                                      validator: (value) {
                                        return validateMobileOrEmail(value!);
                                      },
                                      decoration: const InputDecoration(
                                          hintText:
                                              'Mobile Number / Email Address',
                                          hintStyle: TextStyle(
                                              color: kSecondaryColor)),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      loginController!.checkLogin();
                                    },
                                    child: Container(
                                      height: 50,
                                      margin: const EdgeInsets.all(15),
                                      decoration: boxDecorationRect(
                                          kPrimaryColor, kPrimaryColorLight),
                                      child: Center(
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    child: Text(
                                      "Don't have an account? ",
                                      style: TextStyle(
                                        color: kTextColor,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(AppRoutes.signupone);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      child: Text(
                                        'Sign up',
                                        style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
