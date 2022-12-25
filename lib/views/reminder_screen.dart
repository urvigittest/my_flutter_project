import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_practicekiya/controllers/home_controller.dart';

import 'package:flutter_practicekiya/models/maincategory_model.dart';
import 'package:flutter_practicekiya/models/orderhistory_screen.dart';
import 'package:flutter_practicekiya/utils/functions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../controllers/payment_controller.dart';
import '../routes/app_routes.dart';
import '../services/remote_services.dart';
import '../utils/notifier_helper.dart';
import '../utils/theme.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key? key}) : super(key: key);

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  PaymentController? paymentController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime? dateTimeStr;

  TextEditingController? titleController,
      messageController,
      reminderTimeController;
  final GlobalKey<FormState> reminderFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    paymentController = Get.find<PaymentController>();

    titleController = TextEditingController();
    messageController = TextEditingController();
    reminderTimeController = TextEditingController();
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
                  Form(
                      key: reminderFormKey,
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
                              paymentController!.appBar(false, 'Reminder',
                                  kPrimaryColorDark, context, scaffoldKey),
                            ]),
                          ),
                          Expanded(
                            // flex: 1,
                            child: Column(children: [
                              // TextButton(
                              //     onPressed: () {
                              //       DatePicker.showDateTimePicker(
                              //         context,
                              //         showTitleActions: true,
                              //         minTime: DateTime.now(),
                              //         maxTime: DateTime(3000, 6, 7),
                              //         onChanged: (date) {
                              //           print('change $date');
                              //         },
                              //         onConfirm: (date) {
                              //           print('confirm $date');
                              //           setState(() {
                              //             dateTimeStr =
                              //                 Jiffy(date, "yyyy-MM-dd HH:mm:ss")
                              //                     .format("dd-MM-yyyy h:mm a");
                              //           });
                              //         },
                              //         currentTime: DateTime.now(),
                              //         locale: LocaleType.en,
                              //       );
                              //     },
                              //     child: const Text(
                              //       'Select Reminder Date And Time',
                              //       style: TextStyle(color: Colors.blue),
                              //     )),
                              // Text(
                              //   dateTimeStr!,
                              //   style: TextStyle(
                              //       color: kPrimaryColor,
                              //       fontWeight: FontWeight.bold),
                              // ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Date Time',
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
                                          controller: reminderTimeController,
                                          readOnly: true,
                                          onTap: () {
                                            DatePicker.showDateTimePicker(
                                              context,
                                              showTitleActions: true,
                                              minTime: DateTime.now(),
                                              maxTime: DateTime.now(),
                                              // maxTime: DateTime(3000, 6, 7),
                                              onChanged: (date) {
                                                print('change $date');
                                              },
                                              onConfirm: (date) {
                                                print('confirm $date');
                                                setState(() {
                                                  dateTimeStr = date;
                                                  reminderTimeController!
                                                      .text = Jiffy(date,
                                                          "yyyy-MM-dd HH:mm:ss")
                                                      .format(
                                                          "dd-MM-yyyy h:mm a");
                                                });
                                              },
                                              currentTime: DateTime.now(),
                                              locale: LocaleType.en,
                                            );
                                          },
                                          keyboardType:
                                              TextInputType.streetAddress,
                                          autofocus: false,
                                          style: TextStyle(fontSize: 14.sp),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please select date time";
                                            }
                                          },
                                          decoration: const InputDecoration(
                                              hintText: 'Date Time',
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
                                        'Title',
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
                                          controller: titleController,
                                          keyboardType:
                                              TextInputType.streetAddress,
                                          autofocus: false,
                                          style: TextStyle(fontSize: 14.sp),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please title";
                                            }
                                          },
                                          decoration: const InputDecoration(
                                              hintText: 'Title',
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
                                        'Message',
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
                                          controller: messageController,
                                          keyboardType:
                                              TextInputType.streetAddress,
                                          autofocus: false,
                                          style: TextStyle(fontSize: 14.sp),
                                          maxLength: 50,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please message";
                                            }
                                          },
                                          decoration: const InputDecoration(
                                              hintText: 'Message',
                                              hintStyle: TextStyle(
                                                  color: kSecondaryColor)),
                                        ),
                                      ))
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  final isValid =
                                      reminderFormKey.currentState!.validate();
                                  if (!isValid) {
                                    return;
                                  }
                                  print(DateTime.now()
                                      .millisecondsSinceEpoch
                                      .remainder(100000));

                                  NotifyHelper.instance.scheduledNotification(
                                    // int.parse(Jiffy(
                                    //         dateTimeStr, "yyyy-MM-dd HH:mm:ss")
                                    //     .format("HH")),
                                    // int.parse(Jiffy(
                                    //         dateTimeStr, "yyyy-MM-dd HH:mm:ss")
                                    // .format("mm")),
                                    dateTimeStr!,
                                    titleController!.text,
                                    messageController!.text,
                                    DateTime.now()
                                        .millisecondsSinceEpoch
                                        .remainder(100000),
                                    "",
                                  );

                                  showFlutterToast('Reminder is set');
                                  Get.back();
                                },
                                child: Container(
                                  height: 45,
                                  margin: const EdgeInsets.only(
                                      top: 12, bottom: 12, right: 20, left: 20),
                                  decoration: boxDecorationValidTill(
                                      kPrimaryColor, kPrimaryColorLight, 50),
                                  child: Center(
                                    child: Text(
                                      'Set Reminder',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }

  Widget itemWidget(OrderHistoryData model, int index) {
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Container(
                height: 25,
                width: 25,
                margin: const EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: boxDecorationStep(kPrimaryColorDarkLight,
                    kPrimaryColorDark, kPrimaryColorDark),
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '#' + model.id.toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: kDarkBlueColor,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '₹' + model.totalAmount!.toStringAsFixed(2) + '/-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    showFlutterToast('in progress');
                  },
                  child: Container(
                    height: 25,
                    margin: const EdgeInsets.only(
                        top: 2, bottom: 2, right: 2, left: 2),
                    decoration: boxDecorationValidTill(
                        kPrimaryColor, kPrimaryColor, 20),
                    child: Center(
                      child: Text(
                        'Invoice',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
