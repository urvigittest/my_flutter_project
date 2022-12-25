import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practicekiya/controllers/login_controller.dart';
import 'package:flutter_practicekiya/utils/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';
import '../utils/functions.dart';

class SignUpOneScreen extends StatefulWidget {
  const SignUpOneScreen({Key? key}) : super(key: key);

  @override
  State<SignUpOneScreen> createState() => _SignUpOneScreenState();
}

class _SignUpOneScreenState extends State<SignUpOneScreen> {
  LoginController? loginController;

  String countryCode = 'in';
  String flag = '';

  bool isLoggedInGoogle = false;
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  // User? firebaseUser;

  @override
  void initState() {
    super.initState();
    loginController = Get.find<LoginController>();
    loginController!.clearData();
  }

  loginGoogle() async {
    try {
      await googleSignIn.signIn();
      setState(() {
        // Fluttertoast.showToast(
        //     msg: 'isLoggedInGoogle = true',
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black,
        //     textColor: Colors.white,
        //     fontSize: 14.0);
        isLoggedInGoogle = true;

        print(googleSignIn.currentUser);

        if (googleSignIn.currentUser != null) {
          Get.back();
          getItRegister<Map<String, dynamic>>({
            'screen': 'Gmail',
            'userid': '0',
            'mobileemail': googleSignIn.currentUser!.email,
          }, name: "selected_logintype");
          String s = googleSignIn.currentUser!.displayName!;
          int idx = s.indexOf(" ");

          loginController!.fnameController!.text = s.substring(0, idx).trim();
          loginController!.lnameController!.text = s.substring(idx + 1).trim();
          loginController!.emailController!.text =
              googleSignIn.currentUser!.email;

          Get.toNamed(AppRoutes.signupthird);
        }

        logoutGoogle();

        // getSocialLoginData('G', firebaseUser);
      });
    } catch (err) {
      print(err);
      Fluttertoast.showToast(
          msg: err.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  logoutGoogle() {
    googleSignIn.signOut();
    setState(() {
      // Fluttertoast.showToast(
      //     msg: 'isLoggedInGoogle = false',
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.black,
      //     textColor: Colors.white,
      //     fontSize: 14.0);
      isLoggedInGoogle = false;
    });
  }

  // void getSocialLoginData(String from, User firebaseUser) async {
  //   // ShowLoader();

  //   if (from == 'G') {
  //     logoutGoogle();
  //   }

  //   HttpClient client = new HttpClient();
  //   client.badCertificateCallback =
  //       ((X509Certificate cert, String host, int port) => true);
  //   String url = UrlLinks.sociallogin;

  //   String fname = '', lname = '', email = '';
  //   if (from == 'G') {
  //     email = googleSignIn.currentUser!.email;
  //     String s = googleSignIn.currentUser!.displayName!;
  //     int idx = s.indexOf(" ");
  //     fname = s.substring(0, idx).trim();
  //     lname = s.substring(idx + 1).trim();
  //     // List parts = [s.substring(0,idx).trim(), s.substring(idx+1).trim()];
  //     // fname=parts[0];
  //     // lname=parts[1];
  //   }
  //   // else if(from=='F'){
  //   //   email=userProfile["email"];
  //   //   String s = userProfile["name"];
  //   //   print(s);
  //   //   int idx = s.indexOf(" ");
  //   //   //  List parts = [s.substring(0,idx).trim(), s.substring(idx+1).trim()];
  //   //   fname=s.substring(0,idx).trim();
  //   //   lname=s.substring(idx+1).trim();
  //   // }
  //   else {
  //     // email=authorizationResult.credential.email.toString();
  //     // // String s = authorizationResult.credential.fullName.familyNametoString();
  //     // // print(s);
  //     // // int idx = s.indexOf(" ");
  //     // //  List parts = [s.substring(0,idx).trim(), s.substring(idx+1).trim()];
  //     // fname=authorizationResult.credential.fullName.familyName.toString().trim();
  //     // lname=authorizationResult.credential.fullName.givenName.toString().trim();
  //     email = firebaseUser.email;
  //     String s = firebaseUser.displayName;

  //     print(s);
  //     int idx = s.indexOf(" ");
  //     //  List parts = [s.substring(0,idx).trim(), s.substring(idx+1).trim()];
  //     fname = s.substring(0, idx).trim();
  //     lname = s.substring(idx + 1).trim();

  //     if (fname == 'null') {
  //       fname = '';
  //       lname = '';
  //     }
  //   }

  //   Map map = {
  //     "Email": email,
  //     "FirstName": fname,
  //     "LastName": lname,
  //     "deviceId": uniqueNumber,
  //   };
  //   print(map);

  //   HttpClientRequest request = await client.postUrl(Uri.parse(url));
  //   request.headers.set('content-type', 'application/json');
  //   request.add(utf8.encode(json.encode(map)));
  //   HttpClientResponse response = await request.close();
  //   String reply = await response.transform(utf8.decoder).join();
  //   print(reply);

  //   // HideLoader();

  //   setState(() {
  //     isLoading = false;
  //     LoginModel model = LoginModel.fromJson(json.decode(reply));

  //     if (model.status == true) {
  //       if (model.data.courseID == null || model.data.courseID == 0) {
  //         _prefs.setLoggedIn('1');
  //         _prefs.setLoginData("login", model);
  //         Fluttertoast.showToast(
  //             msg: model.msg.toString(),
  //             toastLength: Toast.LENGTH_SHORT,
  //             gravity: ToastGravity.CENTER,
  //             timeInSecForIosWeb: 1,
  //             backgroundColor: Colors.black,
  //             textColor: Colors.white,
  //             fontSize: 14.0);

  //         Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => EditProfileScreen(
  //                       isLogin: false,
  //                     )));
  //       } else {
  //         _prefs.setLoggedIn('1');
  //         _prefs.setLoginData("login", model);

  //         isLoading = false;
  //         Fluttertoast.showToast(
  //             msg: model.msg.toString(),
  //             toastLength: Toast.LENGTH_SHORT,
  //             gravity: ToastGravity.CENTER,
  //             timeInSecForIosWeb: 1,
  //             backgroundColor: Colors.black,
  //             textColor: Colors.white,
  //             fontSize: 14.0);

  //         Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (context) => DashboardScreen()));
  //       }
  //     } else {
  //       isLoading = false;
  //       final snackBar = SnackBar(
  //           content: Text(
  //         model.msg,
  //         style: TextStyle(
  //             fontSize: 14.0,
  //             fontWeight: FontWeight.w500,
  //             fontFamily: 'Quicksand',
  //             color: Colors.white),
  //       ));
  //       _scaffoldKey.currentState.showSnackBar(snackBar);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // firebaseUser = context.watch<User>();
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
                    key: loginController!.loginOneFormKey,
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
                              decoration: boxDecorationStep(Colors.white,
                                  Colors.white, kPrimaryColorDark),
                              child: const Text(
                                '2',
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
                              decoration: boxDecorationStep(Colors.white,
                                  Colors.white, kPrimaryColorDark),
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
                                  child: Text(
                                    'Enter Mobile Number',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(
                                      left: 20, bottom: 20),
                                  child: Text(
                                    "We'll send an OTP for verification",
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  child: TextFormField(
                                    controller:
                                        loginController!.mobileController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[-,. ]'))
                                    ],
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
                        Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    'Login via ',
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    loginGoogle();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    margin: const EdgeInsets.all(10),
                                    decoration: boxDecorationRect(
                                        Colors.red, Colors.redAccent),
                                    child: Row(children: [
                                      Image.asset(
                                        'assets/images/google.png',
                                        color: Colors.white,
                                        height: 15.h,
                                      ),
                                      Center(
                                        child: Text(
                                          "   Google",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ]),
                                  ),
                                ),
                              ],
                            )),
                        GestureDetector(
                          onTap: () {
                            loginController!.checkSignUp();
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
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
