import 'package:flutter/material.dart';

import 'package:flutter_practicekiya/controllers/payment_controller.dart';
import 'package:flutter_practicekiya/models/billinglist_model.dart';

import 'package:flutter_practicekiya/utils/functions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../utils/theme.dart';

class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({Key? key}) : super(key: key);

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  PaymentController? paymentController;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> contactFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    paymentController = Get.find<PaymentController>();
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
                        decoration: const BoxDecoration(
                          // border: Border.all(color: kPrimaryColorDark),
                          color: kPrimaryColorDark,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(children: [
                          paymentController!.appBar(false, 'Help & Support',
                              kPrimaryColorDark, context, scaffoldKey),
                        ]),
                      ),
                      Expanded(
                        // flex: 1,
                        child: Form(
                          key: contactFormKey,
                          child: ListView(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Full Name',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: kTextColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      child: TextFormField(
                                        controller: paymentController!
                                            .fullnameController,
                                        keyboardType: TextInputType.name,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        autofocus: false,
                                        style: TextStyle(fontSize: 14.sp),
                                        validator: (value) {
                                          return validateFname(value!);
                                        },
                                        decoration: const InputDecoration(
                                            hintText: 'Full Name',
                                            hintStyle: TextStyle(
                                                color: kSecondaryColor)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Contact No.',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: kTextColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        child: TextFormField(
                                          controller: paymentController!
                                              .mobileController,
                                          keyboardType: TextInputType.phone,
                                          autofocus: false,
                                          style: TextStyle(fontSize: 14.sp),
                                          validator: (value) {
                                            return validateMobile(value!);
                                          },
                                          decoration: InputDecoration(
                                              prefixIcon: SizedBox(
                                                width: 50,
                                                child: Row(children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
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
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Email ID',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: kTextColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        child: TextFormField(
                                          controller: paymentController!
                                              .emailController,
                                          keyboardType: TextInputType.name,
                                          autofocus: false,
                                          style: TextStyle(fontSize: 14.sp),
                                          validator: (value) {
                                            return validateEmail(value!);
                                          },
                                          decoration: const InputDecoration(
                                              hintText: 'Email Address',
                                              hintStyle: TextStyle(
                                                  color: kSecondaryColor)),
                                        ),
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Comments',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: kTextColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 10),
                                        child: TextFormField(
                                          controller: paymentController!
                                              .addressoneController,
                                          keyboardType:
                                              TextInputType.streetAddress,
                                          autofocus: false,
                                          maxLines: 10,
                                          minLines: 5,
                                          style: TextStyle(fontSize: 14.sp),
                                          validator: (value) {
                                            return validateComments(value!);
                                          },
                                          decoration: const InputDecoration(
                                              hintText: 'Comments',
                                              hintStyle: TextStyle(
                                                  color: kSecondaryColor)),
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          final isValid =
                              contactFormKey.currentState!.validate();
                          if (!isValid) {
                            return;
                          }
                          paymentController!.addContactInfo(
                              paymentController!.fullnameController!.text,
                              paymentController!.mobileController!.text,
                              paymentController!.emailController!.text,
                              paymentController!.addressoneController!.text);
                        },
                        child: Container(
                          height: 45,
                          margin: const EdgeInsets.only(
                              top: 12, bottom: 12, right: 20, left: 20),
                          decoration: boxDecorationValidTill(
                              kPrimaryColor, kPrimaryColorLight, 50),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Send Us Message',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: Image(
                                    color: Colors.white,
                                    image: AssetImage(
                                      'assets/images/send.png',
                                    ),
                                  ),
                                ),
                              ]),
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
