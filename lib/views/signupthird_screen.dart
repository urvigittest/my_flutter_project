import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/controllers/login_controller.dart';
import 'package:flutter_practicekiya/utils/theme.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../utils/functions.dart';

class SignUpThirdScreen extends StatefulWidget {
  const SignUpThirdScreen({Key? key}) : super(key: key);

  @override
  State<SignUpThirdScreen> createState() => _SignUpThirdScreenState();
}

class _SignUpThirdScreenState extends State<SignUpThirdScreen> {
  LoginController? loginController;

  String countryCode = 'in';
  String flag = '';

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
    flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
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
                  Form(
                    key: loginController!.loginThreeFormKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 50, right: 10, left: 10),
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
                                  kPrimaryColorDarkLight,
                                  kPrimaryColorDark,
                                  kPrimaryColorDark),
                              child: const Text(
                                '3',
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
                              decoration: boxDecorationStep(Colors.white,
                                  Colors.white, kPrimaryColorDark),
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
                                  child: const Text(
                                    'Complete Profile',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 20),
                                  child: const Text(
                                    "Fill-Up Your Personal Information",
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  child: TextFormField(
                                    controller:
                                        loginController!.fnameController,
                                    readOnly: screen == 'Gmail' ? true : false,
                                    keyboardType: TextInputType.name,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    autofocus: false,
                                    style: const TextStyle(fontSize: 14),
                                    validator: (value) {
                                      return validateFname(value!);
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'First Name',
                                        hintStyle:
                                            TextStyle(color: kSecondaryColor)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  child: TextFormField(
                                    controller:
                                        loginController!.lnameController,
                                    readOnly: screen == 'Gmail' ? true : false,
                                    keyboardType: TextInputType.name,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    autofocus: false,
                                    style: const TextStyle(fontSize: 14),
                                    validator: (value) {
                                      return validateLname(value!);
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Last Name',
                                        hintStyle:
                                            TextStyle(color: kSecondaryColor)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  child: TextFormField(
                                    controller:
                                        loginController!.emailController,
                                    readOnly: screen == 'Gmail' ? true : false,
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    style: const TextStyle(fontSize: 14),
                                    validator: (value) {
                                      return validateEmail(value!);
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Email Address',
                                        hintStyle:
                                            TextStyle(color: kSecondaryColor)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  child: TextFormField(
                                    controller:
                                        loginController!.mobileController,
                                    readOnly: screen == 'Gmail' ? false : true,
                                    keyboardType: TextInputType.phone,
                                    autofocus: false,
                                    style: const TextStyle(fontSize: 14),
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
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                        hintStyle: const TextStyle(
                                            color: kSecondaryColor)),
                                  ),
                                ),
                              ],
                            )),
                        GestureDetector(
                          onTap: () {
                            loginController!.checkSignUpThree(
                                screen!,
                                mobileemail!,
                                userid!,
                                loginController!.loginThreeFormKey);
                          },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.only(
                                top: 12, bottom: 12, right: 20, left: 20),
                            decoration: boxDecorationRect(
                                kPrimaryColor, kPrimaryColorLight),
                            child: const Center(
                              child: Text(
                                "Next",
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
    );
  }
}
