import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/models/blog_model.dart';
import 'package:flutter_practicekiya/models/general_model.dart';
import 'package:flutter_practicekiya/models/home_model.dart';
import 'package:flutter_practicekiya/models/maincategory_model.dart';
import 'package:flutter_practicekiya/models/notificationlist_model.dart';

import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../models/idstringname_model.dart';
import '../services/remote_services.dart';

import '../utils/preferences.dart';
import '../utils/theme.dart';

List<IdStringNameModel> getStaticCourse() {
  return [
    IdStringNameModel(id: 1, name: 'Gate 1'),
    IdStringNameModel(id: 2, name: 'Gate 2'),
    IdStringNameModel(id: 3, name: 'Gate 3'),
  ];
}

class HomeController extends GetxController {
  final RxBool obscureText = true.obs;
  Prefs prefs = Prefs.prefs;

  var isLoading = true.obs;

  List<IdStringNameModel> pickUpList =
      List<IdStringNameModel>.empty(growable: true).obs;

  var sliderController =
      PageController(viewportFraction: 1, keepPage: true).obs;

  // List<IdStringNameModel> selectedCourseList = getStaticCourse().obs;
  RxList<SelectedCategoryList> selectedCourseList =
      List<SelectedCategoryList>.empty(growable: true).obs;
  RxInt? selectedCourseId = 0.obs;

  RxInt? totalPractice = 0.obs;
  RxInt? totalPyq = 0.obs;
  RxInt? totalTest = 0.obs;

  void setSelected(int value) {
    print('CALLEDDDDDDDDDDDDDDDDDD');
    // if (value == 111111) {
    //   value = 0;
    //   print('VALUEEE->' + value.toString());
    // }
    selectedCourseId!.value = value;
    print('VALUEEE selectedCourseId->' + selectedCourseId!.value.toString());
    prefs.setDefaultGoal(selectedCourseId!.value.toString());
    changeType(selectedTypeId);
  }

  RxString selectedTypeId = '1'.obs;

  RxList<GetSlider> sliderData = List<GetSlider>.empty(growable: true).obs;
  RxList<Subcategory> subCategoryList =
      List<Subcategory>.empty(growable: true).obs;

  RxList<MainCategoryData> blogList =
      List<MainCategoryData>.empty(growable: true).obs;

  var blogData = BlogData().obs;

  RxList<NotificationData> notificationList =
      List<NotificationData>.empty(growable: true).obs;

  @override
  void onInit() {
    super.onInit();
    getPrefs();
  }

  void getPrefs() async {
    String goalid = await prefs.getDefaultGoal();
    selectedCourseId!.value = int.parse(goalid);
  }

  // // void ChangeColor() {
  // //   if (sliderController.page == 2) {
  // //     color.value = Colors.green;
  // //   } else if (sliderController.page == 3) {
  // //     color.value = Colors.yellow;
  // //   } else {
  // //     color.value = Colors.red;
  // //   }
  // // }

  // void ChangeColor() {
  //   print(sliderController.page!.round());
  //   if (sliderController.page!.round() == 2) {
  //     numnnn.value = 23;
  //   } else if (sliderController.page!.round() == 3) {
  //     numnnn.value = 45;
  //   } else {
  //     numnnn.value = 2;
  //   }
  // }

  void changeType(RxString typeId) {
    selectedTypeId.value = typeId.value;
    print('CALED HOME type');
    if (selectedTypeId.value == '1') {
      getExamsByType(true, 'practice', selectedCourseId!.value.toString());
    } else if (selectedTypeId.value == '2') {
      getExamsByType(true, 'test', selectedCourseId!.value.toString());
    } else if (selectedTypeId.value == '3') {
      getExamsByType(true, 'pyq', selectedCourseId!.value.toString());
    }
    // fetchGoalsList(true);
  }

  @override
  void onClose() {}

  void getHomeData(bool isShowLoading) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);
      sliderData.clear();
      subCategoryList.clear();
      selectedCourseList.clear();
      SelectedCategoryList categoryList = SelectedCategoryList();
      categoryList.categoryId = 0;
      categoryList.categoryName = 'All';
      selectedCourseList.add(categoryList);

      String goalid = await prefs.getDefaultGoal();
      print('goalid->' + goalid);
      if (goalid == '0' || goalid == '') {
        goalid = await prefs.getDefaultGoal();

        selectedCourseId!.value = 0;
        print('goalid in side ->' + selectedCourseId.toString());
      }
      HomeModel? model = await RemoteServices.instance.getHomeData(goalid);
      sliderData.addAll(model!.getSlider!);
      subCategoryList.addAll(model.subcategory!);

      selectedCourseList.addAll(model.selectedCategoryList!);
      SelectedCategoryList categoryList1 = SelectedCategoryList();
      categoryList1.categoryId = 111111;
      categoryList1.categoryName = '+ Add New';
      selectedCourseList.add(categoryList1);

      totalPractice!.value = model.userSubscription!.totalPractice!;
      totalPyq!.value = model.userSubscription!.totalPyq!;
      totalTest!.value = model.userSubscription!.totalTest!;
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getExamsByType(bool isShowLoading, String type, String goalid) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      subCategoryList.clear();
      HomeModel? model = await RemoteServices.instance
          .getExamsByType(type, goalid == '0' ? '' : goalid);

      subCategoryList.addAll(model!.subcategory!);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getBlogList(bool isShowLoading) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      blogList.clear();
      MainCategoryModel? model = await RemoteServices.instance.getBlogList();

      blogList.addAll(model!.data!);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getBlogDetails(bool isShowLoading, String blogid) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);

      BlogModel? model = await RemoteServices.instance.getBlogDetails(blogid);
      blogData.value = model!.data!;
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void fetchGoalsList(bool isShowLoading) async {
    try {
      if (isShowLoading) {
        showLoader();
      }
      isLoading(true);
      pickUpList.clear();
      List<IdStringNameModel>? model = await RemoteServices.pickUpList(0);
      pickUpList.addAll(model!);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getNotificationList(bool isShowLoading, int page) async {
    try {
      if (isShowLoading) {
        showLoader();
        isLoading(true);
        notificationList.clear();
      }

      NotificationListModel? model =
          await RemoteServices.instance.getNotificationList(page);

      notificationList.addAll(model!.data!);
    } finally {
      if (isShowLoading) {
        hideLoader();
      }
      isLoading(false);
    }
  }

  void getNotificationRead(String id) async {
    try {
      showLoader();

      GeneralModel? model =
          await RemoteServices.instance.getNotificationRead(id);
    } finally {
      hideLoader();

      isLoading(false);
    }
  }
}
