import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_practicekiya/models/general_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/maincategory_model.dart';
import '../routes/app_routes.dart';
import '../services/remote_services.dart';
import '../utils/theme.dart';

class DashboardController extends GetxController {
  var tabIndex = 0.obs;
  StreamController<String> refreshStreamController =
      StreamController.broadcast();

  void changeTabIndex(int index) {
    if (index == 4) {
      tabIndex.value = 2;
    } else {
      tabIndex.value = index;
    }

    if (index == 0) {
      refreshStreamController.sink.add("HOME");
    } else if (index == 1) {
      refreshStreamController.sink.add("OFFER");
    } else if (index == 2) {
      refreshStreamController.sink.add("PLAN");
    } else if (index == 4) {
      refreshStreamController.sink.add("PLANCARD");
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addSubscriptionRating(String subscriptionid, String rating) async {
    try {
      showLoader();

      MainCategoryModel? model = await RemoteServices.instance
          .addSubscriptionRating(subscriptionid, rating);

      if (model!.status!) {
        hideLoader();
        Get.back();
      }
    } finally {
      hideLoader();
    }
  }

  void exitDialog(BuildContext context) {
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
              "Exit",
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: kPrimaryColor),
              textAlign: TextAlign.left,
            ),
            content: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20),
                  child: Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Text('Are you sure you want to exit PracticeKiya?',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: kTextColor))),
                ),
              ],
            )),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      SystemNavigator.pop();
                    },
                    child: Container(
                      height: 35,
                      width: 100,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: boxDecorationValidTill(
                          kPrimaryColorDark, kPrimaryColorDarkLight, 10),
                      child: const Center(
                        child: Text(
                          "Exit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 35,
                      width: 100,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: boxDecorationRectBorder(
                          Colors.white, Colors.white, kDarkBlueColor),
                      child: const Center(
                        child: Text(
                          "Cancel",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: kDarkBlueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        }));
  }
}
