import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practicekiya/controllers/login_controller.dart';
import 'package:flutter_practicekiya/utils/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SignUpSecondScreen extends StatefulWidget {
  const SignUpSecondScreen({Key? key}) : super(key: key);

  @override
  State<SignUpSecondScreen> createState() => _SignUpSecondScreenState();
}

class _SignUpSecondScreenState extends State<SignUpSecondScreen> {
  LoginController? loginController;

  String? screen, userid, mobileemail;

  @override
  void initState() {
    super.initState();
    loginController = Get.find<LoginController>();

    screen = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_logintype")['screen'];
    userid = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_logintype")['userid'];
    mobileemail = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_logintype")['mobileemail'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Column(
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(top: 50, right: 10, left: 10),
                        child: Row(children: [
                          Container(
                            height: 25,
                            alignment: Alignment.center,
                            width: 25,
                            decoration: boxDecorationStep(
                                kPrimaryColorDarkLight,
                                kPrimaryColorDark,
                                kPrimaryColorDark),
                            child: const Text(
                              '1',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            color: kPrimaryColor,
                            height: 1,
                            alignment: Alignment.center,
                          )),
                          Container(
                            height: 25,
                            alignment: Alignment.center,
                            width: 25,
                            decoration: boxDecorationStep(
                                kPrimaryColorDarkLight,
                                kPrimaryColorDark,
                                kPrimaryColorDark),
                            child: const Text(
                              '2',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            color: kPrimaryColor,
                            height: 1,
                            alignment: Alignment.center,
                          )),
                          Container(
                            height: 25,
                            alignment: Alignment.center,
                            width: 25,
                            decoration: boxDecorationStep(
                                Colors.white, Colors.white, kPrimaryColorDark),
                            child: const Text(
                              '3',
                              style: TextStyle(
                                  color: kPrimaryColorDark,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(
                              child: Container(
                            color: kPrimaryColor,
                            height: 1,
                            alignment: Alignment.center,
                          )),
                          Container(
                            height: 25,
                            alignment: Alignment.center,
                            width: 25,
                            decoration: boxDecorationStep(
                                Colors.white, Colors.white, kPrimaryColorDark),
                            child: const Text(
                              '4',
                              style: TextStyle(
                                  color: kPrimaryColorDark,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                          flex: 10,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(
                                    bottom: 10, top: 60, left: 20),
                                child: Text(
                                  'Verify OTP',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(
                                        left: 20, bottom: 20),
                                    child: Text(
                                      "We've sent it on " + mobileemail!,
                                      style: TextStyle(
                                        color: kTextColor,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, bottom: 20),
                                      child: Text(
                                        'CHANGE MOBILE NO.',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: kDarkBlueColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                child: PinFieldAutoFill(
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[-,. ]'))
                                    ],
                                    codeLength: 6,
                                    decoration: BoxLooseDecoration(
                                      strokeColorBuilder: PinListenColorBuilder(
                                          kPrimaryColor, kSecondaryColor),
                                    ),
                                    currentCode: loginController!.otpCode,
                                    onCodeChanged: (code) {
                                      loginController!.otpCode = code!;
                                    }),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(0),
                                    child: Text(
                                      "Dind't received the OTP?  ",
                                      style: TextStyle(
                                        color: kTextColor,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      loginController!.sendOTP(screen!, '',
                                          screen == 'Login' ? '1' : '0', true);
                                    },
                                    child: Text(
                                      'RESEND OTP',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: kPrimaryColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(0),
                                child: Text(
                                  'Having Issue? Write to us on ',
                                  style: TextStyle(
                                    color: kTextColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'help@emailaddress.com',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: kPrimaryColorDark,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          )),
                      GestureDetector(
                        onTap: () {
                          loginController!
                              .checkSignUpTwo(screen!, mobileemail!, userid!);
                        },
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.only(
                              top: 12, bottom: 12, right: 20, left: 20),
                          decoration: boxDecorationRect(
                              kPrimaryColor, kPrimaryColorLight),
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
