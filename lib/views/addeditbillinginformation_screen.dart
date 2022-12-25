import 'package:flutter/material.dart';

import 'package:flutter_practicekiya/controllers/payment_controller.dart';
import 'package:flutter_practicekiya/models/billinglist_model.dart';

import 'package:flutter_practicekiya/utils/functions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../utils/theme.dart';

class AddEditBillingInformationScreen extends StatefulWidget {
  const AddEditBillingInformationScreen({Key? key}) : super(key: key);

  @override
  State<AddEditBillingInformationScreen> createState() =>
      _AddEditBillingInformationScreenState();
}

class _AddEditBillingInformationScreenState
    extends State<AddEditBillingInformationScreen> {
  PaymentController? paymentController;
  String? subscriptionId, subscriptionName, screen, isEdit;
  BillingInformationData? billingData;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    paymentController = Get.find<PaymentController>();

    // subscriptionId = GetIt.I<Map<String, dynamic>>(
    //     instanceName: "selected_subscription")['subscriptionId'];
    // subscriptionName = GetIt.I<Map<String, dynamic>>(
    //     instanceName: "selected_subscription")['subscriptionName'];
    // screen = GetIt.I<Map<String, dynamic>>(
    //     instanceName: "selected_subscription")['screen'];

    isEdit = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_billing")['isEdit'];

    if (isEdit == '1') {
      billingData = GetIt.I<Map<String, dynamic>>(
          instanceName: "selected_billing")['billingData'];

      paymentController!.fullnameController!.text = billingData!.fullname!;
      paymentController!.mobileController!.text = billingData!.mobile!;
      paymentController!.emailController!.text = billingData!.email!;
      paymentController!.addressoneController!.text = billingData!.addressOne!;
      paymentController!.addresstwoController!.text = billingData!.addressTwo!;
      paymentController!.addressthreeController!.text =
          billingData!.addressThree!;
      paymentController!.pincodeController!.text = billingData!.pincode!;
    }

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   paymentController!.getBillingList();
    // });
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
                          paymentController!.appBar(
                              false,
                              isEdit == '1'
                                  ? 'Edit Billing Information'
                                  : 'Add Billing Information',
                              kPrimaryColorDark,
                              context,
                              scaffoldKey),
                        ]),
                      ),
                      Expanded(
                        // flex: 1,
                        child: Form(
                          key: paymentController!.billingFormKey,
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
                                        'Address 1',
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
                                          style: TextStyle(fontSize: 14.sp),
                                          validator: (value) {
                                            return validateAddress1(value!);
                                          },
                                          decoration: const InputDecoration(
                                              hintText: 'Address 1',
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
                                        'Address 2',
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
                                              .addresstwoController,
                                          keyboardType:
                                              TextInputType.streetAddress,
                                          autofocus: false,
                                          style: TextStyle(fontSize: 14.sp),
                                          validator: (value) {
                                            return validateAddress2(value!);
                                          },
                                          decoration: const InputDecoration(
                                              hintText: 'Address 2',
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
                                        'Address 3',
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
                                              .addressthreeController,
                                          keyboardType:
                                              TextInputType.streetAddress,
                                          autofocus: false,
                                          style: TextStyle(fontSize: 14.sp),
                                          validator: (value) {
                                            return validateAddress3(value!);
                                          },
                                          decoration: const InputDecoration(
                                              hintText: 'Address 3',
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
                                        'Pincode',
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
                                              .pincodeController,
                                          keyboardType: TextInputType.number,
                                          autofocus: false,
                                          style: TextStyle(fontSize: 14.sp),
                                          validator: (value) {
                                            return validatePincode(value!);
                                          },
                                          decoration: const InputDecoration(
                                              hintText: 'Pincode',
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
                          if (isEdit == '1') {
                            paymentController!.checkBilling(
                                isEdit!, billingData!.id.toString());
                          } else {
                            paymentController!.checkBilling(isEdit!, '');
                          }
                        },
                        child: Container(
                          height: 45,
                          margin: const EdgeInsets.only(
                              top: 12, bottom: 12, right: 20, left: 20),
                          decoration: boxDecorationValidTill(
                              kPrimaryColor, kPrimaryColorLight, 50),
                          child: Center(
                            child: Text(
                              isEdit == '1'
                                  ? "Edit Billing Information"
                                  : "Add Billing Information",
                              style: TextStyle(
                                fontSize: 14.sp,
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
