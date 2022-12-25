import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_practicekiya/models/billinglist_model.dart';
import 'package:flutter_practicekiya/models/blog_model.dart';
import 'package:flutter_practicekiya/models/cart_model.dart';
import 'package:flutter_practicekiya/models/chapter_model.dart';
import 'package:flutter_practicekiya/models/competitive_model.dart';
import 'package:flutter_practicekiya/models/couponlist_model.dart';
import 'package:flutter_practicekiya/models/home_model.dart';
import 'package:flutter_practicekiya/models/idstringname_model.dart';
import 'package:flutter_practicekiya/models/maincategory_model.dart';
import 'package:flutter_practicekiya/models/notificationlist_model.dart';
import 'package:flutter_practicekiya/models/orderhistory_screen.dart';
import 'package:flutter_practicekiya/models/practicemcq_model.dart';
import 'package:flutter_practicekiya/models/practicetopicleaderboard_model.dart';
import 'package:flutter_practicekiya/models/questionwise_model.dart';
import 'package:flutter_practicekiya/models/scorecard_model.dart';
import 'package:flutter_practicekiya/models/sendotp_model.dart';
import 'package:flutter_practicekiya/models/subject_model.dart';
import 'package:flutter_practicekiya/models/subjectanalysis_model.dart';
import 'package:flutter_practicekiya/models/subjectdetails_model.dart';
import 'package:flutter_practicekiya/models/testmcq_model.dart';
import 'package:flutter_practicekiya/models/testsubject_model.dart';
import 'package:flutter_practicekiya/models/testtopic_model.dart';
import 'package:flutter_practicekiya/models/topic_model.dart';
import 'package:flutter_practicekiya/models/topicanaysis_model.dart';
import 'package:flutter_practicekiya/models/topicwise_model.dart';
import 'package:flutter_practicekiya/utils/preferences.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/beforesubmit_model.dart';
import '../models/couponapply_model.dart';
import '../models/general_model.dart';
import '../models/login_model.dart';
import '../routes/app_routes.dart';
import '../utils/functions.dart';
import '../views/testmcq_screen.dart';

class RemoteServices {
  static final keyyyy = GlobalKey();

  static var client = http.Client();

  static String mainLink = "http://3.6.36.232/practice_kiya/api/v1/";
  static String imageMainLink = "http://3.6.36.232/practice_kiya/storage/";

  // static String mainLink = "http://192.168.1.169/practice_kiya/api/v1/";
  // static String imageMainLink = "http://192.168.1.169/practice_kiya/storage/";

  final Prefs prefs = Prefs();

  RemoteServices._privateConstructor();

  static final RemoteServices _instance = RemoteServices._privateConstructor();

  static RemoteServices get instance {
    return _instance;
  }

  void getStaticLogout() {
    prefs.getAllPrefsClear();
    Get.offAndToNamed(AppRoutes.login);
  }

  Future<Map<String, String>> apiHeader() async {
    String? apitoken = await prefs.getApiToken();
    if (kDebugMode) {
      print(apitoken);
    }

    Map<String, String> apiHeader = {
      'Authorization': 'Bearer $apitoken',
    };
    return apiHeader;
  }

  Future<int?> getRefreshToken() async {
    String? apitoken = await prefs.getApiToken();
    Map<String, String> header = await apiHeader();

    var response = await client.post(Uri.parse(mainLink + 'update_profile'),
        body: {
          'api_token': apitoken,
        },
        headers: header);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      Map decodedResponse = json.decode(jsonString);

      var apitoken = decodedResponse['api_token'].toString();
      prefs.setApiToken(apitoken);
      return response.statusCode;
    } else if (response.statusCode == 403) {
      // prefs.getAllPrefsClear();
      // Get.offAndToNamed(AppRoutes.login);
      getStaticLogout();
      return null;
    } else {
      showSnackBar("Error!", "Something went wrong");
      return null;
    }
  }

  static Future<List<IdStringNameModel>?> pickUpList(int page) async {
    // return StaticDataListClass.getGoals();
    var response = await client.get(
      Uri.parse(
          'https://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline'),
    );
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return idStringNameModelFromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<SendOtpModel?> sendOTP(
      String screen, String mobileemail, String isLogin) async {
    var response = await client.post(Uri.parse(mainLink + 'send_otp'), body: {
      'mobile': mobileemail,
      'is_login': isLogin,
    });
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    SendOtpModel sendOtpModel = sendOtpModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (decodedResponse['status']) {
        if (!(screen == 'Login' && sendOtpModel.userId.toString() == '0')) {
          showSnackBar("OTP Send", sendOtpModel.message!);
        }

        return sendOtpModel;
      }
      showSnackBar("Error", "Invalid Username or Password!");
      return null;
    } else {
      showSnackBar("Error!", sendOtpModel.message!);
      return null;
    }
  }

  Future<LoginModel?> signupOTPVerify(
    String screen,
    String mobileemail,
    String otp,
    String deviceid,
    String firebaseid,
    String modelnumber,
    String androidversion,
  ) async {
    var response =
        await client.post(Uri.parse(mainLink + 'register_verify_otp'), body: {
      'mobile': mobileemail,
      'otp': otp,
      'device_id': deviceid,
      'firebase_id': firebaseid,
      'model_number': modelnumber,
      'android_version': androidversion
    });
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    LoginModel loginModel = loginModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (decodedResponse['status']) {
        showSnackBar("OTP Send", loginModel.message!);
        prefs.setApiToken(loginModel.apiToken!);

        return loginModel;
      }
      showSnackBar("", loginModel.message!);

      return null;
    } else {
      showSnackBar("", loginModel.message!);
      return null;
    }
  }

  Future<LoginModel?> gmailOTPVerify(
    String screen,
    String mobileemail,
    String otp,
    String deviceid,
    String firebaseid,
    String modelnumber,
    String androidversion,
    String firstname,
    String lastname,
    String email,
  ) async {
    var response =
        await client.post(Uri.parse(mainLink + 'login_with_gmail'), body: {
      'mobile': mobileemail,
      'otp': otp,
      'device_id': deviceid,
      'firebase_id': firebaseid,
      'model_number': modelnumber,
      'android_version': androidversion,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
    });
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    LoginModel loginModel = loginModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (decodedResponse['status']) {
        showSnackBar("OTP", loginModel.message!);
        prefs.setApiToken(loginModel.apiToken!);

        return loginModel;
      }
      showSnackBar("", loginModel.message!);

      return null;
    } else {
      showSnackBar("", loginModel.message!);
      return null;
    }
  }

  Future<LoginModel?> loginOTPVerify(
    String screen,
    String mobileemail,
    String otp,
    String deviceid,
    String firebaseid,
    String modelnumber,
    String androidversion,
    String userid,
  ) async {
    var response =
        await client.post(Uri.parse(mainLink + 'login_verify_otp'), body: {
      'mobile': mobileemail,
      'otp': otp,
      'device_id': deviceid,
      'firebase_id': firebaseid,
      'model_number': modelnumber,
      'android_version': androidversion,
      'user_id': userid,
    });
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    LoginModel loginModel = loginModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (decodedResponse['status']) {
        showSnackBar("Login", loginModel.message!);
        prefs.setApiToken(loginModel.apiToken!);

        return loginModel;
      }
      showSnackBar("", loginModel.message!);

      return null;
    } else {
      showSnackBar("", loginModel.message!);
      return null;
    }
  }

  Future<LoginModel?> fillProfile(
    String screen,
    String mobileemail,
    String firstname,
    String lastname,
    String email,
  ) async {
    Map<String, String> header = await apiHeader();

    var response = await client.post(Uri.parse(mainLink + 'update_profile'),
        body: {
          'firstname': firstname,
          'lastname': lastname,
          'email': email,
          'mobile': mobileemail,
        },
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    LoginModel loginModel = loginModelFromJson(jsonString);

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        showSnackBar("Login", loginModel.message!);

        return loginModel;
      }
      showSnackBar("", loginModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   fillProfile(screen, mobileemail, firstname, lastname, email);
      // }
      getStaticLogout();
      return null;
    } else if (response.statusCode == 404) {
      showSnackBar("", loginModel.message!);
    } else {
      showSnackBar("", loginModel.message!);
      return null;
    }
  }

  Future<MainCategoryModel?> addUserGoalCategories(
    String screen,
    String categoryids,
  ) async {
    Map<String, String> header = await apiHeader();

    var response = await client.post(Uri.parse(mainLink + 'add_user_category'),
        body: {
          'category_id': categoryids,
        },
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   addUserGoalCategories(screen, categoryids);
      // }
      getStaticLogout();
      return null;
    } else if (response.statusCode == 404) {
      showSnackBar("", mainCategoryModel.message!);
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return null;
    }
  }

  Future<MainCategoryModel?> searchMainCategory(String searchkeyword) async {
    Map<String, String> header = await apiHeader();
    var response = await client.get(
        Uri.parse(mainLink + 'get_category?search_keyword=' + searchkeyword),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    if (kDebugMode) {
      print(response.body);
    }
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<MainCategoryModel?> getSelectedCategory() async {
    Map<String, String> header = await apiHeader();
    var response = await client
        .get(Uri.parse(mainLink + 'get_selected_category'), headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    if (kDebugMode) {
      print(response.body);
    }
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

/////////////////////////////////
  ///
  Future<HomeModel?> getHomeData(String goalid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(
            mainLink + 'get_home_page?user_selected_category_id=' + goalid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    if (kDebugMode) {
      print(response.body);
    }
    HomeModel homeModel = homeModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (decodedResponse['status']) {
        return homeModel;
      }
      showSnackBar("", homeModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getHomeData(goalid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", homeModel.message!);
      return homeModel;
    }
  }

  Future<HomeModel?> getExamsByType(String type, String goalid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink +
            'get_home_sub_category?type=' +
            type +
            '&category_id=' +
            goalid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    HomeModel homeModel = homeModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return homeModel;
      }
      showSnackBar("", homeModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getExamsByType(type, goalid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", homeModel.message!);
      return homeModel;
    }
  }

  Future<MainCategoryModel?> getBlogList() async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_blog_list?search_keyword='),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainModel;
      }
      showSnackBar("", mainModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getBlogList();
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainModel.message!);
      return mainModel;
    }
  }

  Future<BlogModel?> getBlogDetails(String blogid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_blog_details?blog_id=' + blogid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    BlogModel blogModel = blogModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return blogModel;
      }
      showSnackBar("", blogModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getBlogDetails(blogid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", blogModel.message!);
      return blogModel;
    }
  }

  Future<SubjectModel?> getSubjectList(
      String subcategoryid, String type) async {
    Map<String, String> header = await apiHeader();
    var response = await client.get(
        Uri.parse(mainLink +
            'get_subscription_subject?sub_category_id=' +
            subcategoryid +
            '&type=' +
            type),
        headers: header);
    var jsonString = response.body;
    if (kDebugMode) {
      print(response.body);
    }
    Map decodedResponse = json.decode(jsonString);
    SubjectModel subjectModel = subjectModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (decodedResponse['status']) {
        return subjectModel;
      }
      showSnackBar("", subjectModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getSubjectList(subcategoryid, type);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", subjectModel.message!);
      return subjectModel;
    }
  }

  Future<SubjectModel?> getComboSubjectList(String subscriptionid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink +
            'get_subject_by_subscription?subscription_id=' +
            subscriptionid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    SubjectModel subjectModel = subjectModelFromJson(jsonString);
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return subjectModel;
      }
      showSnackBar("", subjectModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getComboSubjectList(subscriptionid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", subjectModel.message!);
      return subjectModel;
    }
  }

  Future<ChapterModel?> getChapterList(String subjectid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_chapter?subject_id=' + subjectid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    ChapterModel chapterModel = chapterModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return chapterModel;
      }
      showSnackBar("", chapterModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getChapterList(subjectid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", chapterModel.message!);
      return chapterModel;
    }
  }

  Future<ChapterModel?> getPYQChapterList(String subjectid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_pyq_chapter?subject_id=' + subjectid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    ChapterModel chapterModel = chapterModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return chapterModel;
      }
      showSnackBar("", chapterModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getChapterList(subjectid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", chapterModel.message!);
      return chapterModel;
    }
  }

  Future<TopicModel?> getTopicList(String chapterId) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_topic?chapter_id=' + chapterId),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    TopicModel topicModel = topicModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return topicModel;
      }
      showSnackBar("", topicModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getTopicList(chapterid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", topicModel.message!);
      return topicModel;
    }
  }

  Future<TopicModel?> getPYQTopicList(String chapterId) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_pyq_topic?chapter_id=' + chapterId),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    TopicModel topicModel = topicModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return topicModel;
      }
      showSnackBar("", topicModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getTopicList(chapterid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", topicModel.message!);
      return topicModel;
    }
  }

  Future<PracticeMcqModel?> getPracticeMCQList(String topicid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_practice_question?topic_id=' + topicid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    PracticeMcqModel practiceMcqModel = practiceMcqModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return practiceMcqModel;
      }
      showSnackBar("", practiceMcqModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeMCQList(topicid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", practiceMcqModel.message!);
      return practiceMcqModel;
    }
  }

  Future<PracticeMcqModel?> getPYQMCQList(String topicid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_pyq_question?topic_id=' + topicid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    PracticeMcqModel practiceMcqModel = practiceMcqModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return practiceMcqModel;
      }
      showSnackBar("", practiceMcqModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeMCQList(topicid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", practiceMcqModel.message!);
      return practiceMcqModel;
    }
  }

  Future<MainCategoryModel?> getPracticeBookmarked(String practiceid) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'practice_question_bookmark'),
            body: {
              'question_id': practiceid,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeBookmarked(practiceid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<MainCategoryModel?> getPYQBookmarked(String practiceid) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'pyq_question_bookmark'),
            body: {
              'question_id': practiceid,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeBookmarked(practiceid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<MainCategoryModel?> getPracticeReported(
      String practiceid, String comment) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'practice_question_report'),
            body: {
              'question_id': practiceid,
              'message': comment,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeReported(practiceid, comment);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<MainCategoryModel?> getPYQReported(
      String practiceid, String comment) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'pyq_question_report'),
            body: {
              'question_id': practiceid,
              'message': comment,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeReported(practiceid, comment);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<MainCategoryModel?> getPracticeSubmitted(
      String practiceid,
      String questionType,
      List<String> answerOption,
      String takenTime,
      String isSkip,
      String isTopicCompleted,
      String subjectid,
      String chapterid) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'add_single_question_answer'),
            body: {
              'question_id': practiceid,
              'question_type': questionType,
              'answered_option':
                  answerOption.isEmpty ? '' : json.encode(answerOption),
              'taken_time': takenTime,
              'is_skip': isSkip,
              'is_topic_completed': isTopicCompleted,
              'subject_id': subjectid,
              'chapter_id': chapterid,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeSubmitted(practiceid, questionType, answerOption, takenTime,
      //       isSkip, isTopicCompleted, subjectid, chapterid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<MainCategoryModel?> getPYQSubmitted(
      String practiceid,
      String questionType,
      List<String> answerOption,
      String takenTime,
      String isSkip,
      String isTopicCompleted,
      String subjectid,
      String chapterid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.post(
        Uri.parse(mainLink + 'add_single_pyq_question_answer'),
        body: {
          'question_id': practiceid,
          'question_type': questionType,
          'answered_option':
              answerOption.isEmpty ? '' : json.encode(answerOption),
          'taken_time': takenTime,
          'is_skip': isSkip,
          'is_topic_completed': isTopicCompleted,
          'subject_id': subjectid,
          'chapter_id': chapterid,
        },
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeSubmitted(practiceid, questionType, answerOption, takenTime,
      //       isSkip, isTopicCompleted, subjectid, chapterid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<SubjectDetailsModel?> getSubjectDetails(
      String subjectId, String type) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink +
            'get_subject_details?subject_id=' +
            subjectId +
            '&type=' +
            type),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    SubjectDetailsModel subjectDetailsModel =
        subjectDetailsModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return subjectDetailsModel;
      }
      showSnackBar("", subjectDetailsModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getSubjectDetails(subjectid, type);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", subjectDetailsModel.message!);
      return subjectDetailsModel;
    }
  }

  Future<SubjectDetailsModel?> getSubscriptionDetails(
      String subscriptionid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink +
            'get_subscription_details?subscription_id=' +
            subscriptionid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    SubjectDetailsModel subjectDetailsModel =
        subjectDetailsModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return subjectDetailsModel;
      }
      showSnackBar("", subjectDetailsModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getSubscriptionDetails(subscriptionid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", subjectDetailsModel.message!);
      return subjectDetailsModel;
    }
  }

  Future<PracticeTopicLeaderBoardModel?> getPracticeTopicLeader(
      String topicid, int page) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink +
            'get_practice_leader_board?topic_id=' +
            topicid +
            '&page=' +
            page.toString()),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    PracticeTopicLeaderBoardModel topicLeaderBoardModel =
        practiceTopicLeaderBoardModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return topicLeaderBoardModel;
      }
      showSnackBar("", topicLeaderBoardModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeTopicLeader(topicid, page);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", topicLeaderBoardModel.message!);
      return topicLeaderBoardModel;
    }
  }

  Future<PracticeTopicLeaderBoardModel?> getPYQTopicLeader(
      String topicid, int page) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink +
            'get_pyq_leader_board?topic_id=' +
            topicid +
            '&page=' +
            page.toString()),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    PracticeTopicLeaderBoardModel topicLeaderBoardModel =
        practiceTopicLeaderBoardModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return topicLeaderBoardModel;
      }
      showSnackBar("", topicLeaderBoardModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeTopicLeader(topicid, page);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", topicLeaderBoardModel.message!);
      return topicLeaderBoardModel;
    }
  }

  Future<SubjectAnalysisModel?> getSubjectAnalysis(String subjectid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_subject_analysis?subject_id=' + subjectid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    SubjectAnalysisModel subjectAnalysisModel =
        subjectAnalysisModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return subjectAnalysisModel;
      }
      showSnackBar("", subjectAnalysisModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getSubjectAnalysis(subjectid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", subjectAnalysisModel.message!);
      return subjectAnalysisModel;
    }
  }

  Future<SubjectAnalysisModel?> getPYQSubjectAnalysis(String subjectid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(
            mainLink + 'get_pyq_subject_analysis?subject_id=' + subjectid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    SubjectAnalysisModel subjectAnalysisModel =
        subjectAnalysisModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return subjectAnalysisModel;
      }
      showSnackBar("", subjectAnalysisModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getSubjectAnalysis(subjectid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", subjectAnalysisModel.message!);
      return subjectAnalysisModel;
    }
  }

  Future<TopicAnalysisModel?> getTopicAnalysis(String topicid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_topic_analysis?topic_id=' + topicid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    TopicAnalysisModel topicAnalysisModel =
        topicAnalysisModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return topicAnalysisModel;
      }
      showSnackBar("", topicAnalysisModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getTopicAnalysis(topicid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", topicAnalysisModel.message!);
      return topicAnalysisModel;
    }
  }

  Future<TopicAnalysisModel?> getPYQTopicAnalysis(String topicid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_pyq_topic_analysis?topic_id=' + topicid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    TopicAnalysisModel topicAnalysisModel =
        topicAnalysisModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return topicAnalysisModel;
      }
      showSnackBar("", topicAnalysisModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getTopicAnalysis(topicid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", topicAnalysisModel.message!);
      return topicAnalysisModel;
    }
  }

  Future<PracticeMcqModel?> getSubjectBookmarkList(
      String subjectid, int page) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink +
            'get_bookmark_question?subject_id=' +
            subjectid +
            '&page=' +
            page.toString()),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    PracticeMcqModel practiceMcqModel = practiceMcqModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return practiceMcqModel;
      }
      showSnackBar("", practiceMcqModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getSubjectBookmarkList(subjectid, page);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", practiceMcqModel.message!);
      return practiceMcqModel;
    }
  }

  Future<PracticeMcqModel?> getPYQSubjectBookmarkList(
      String subjectid, int page) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink +
            'get_pyq_bookmark_question?subject_id=' +
            subjectid +
            '&page=' +
            page.toString()),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    PracticeMcqModel practiceMcqModel = practiceMcqModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return practiceMcqModel;
      }
      showSnackBar("", practiceMcqModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getSubjectBookmarkList(subjectid, page);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", practiceMcqModel.message!);
      return practiceMcqModel;
    }
  }

  Future<PracticeMcqModel?> getTopicBookmarkList(
      String topicid, int page) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink +
            'get_bookmark_question?topic_id=' +
            topicid +
            '&page=' +
            page.toString()),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    PracticeMcqModel practiceMcqModel = practiceMcqModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return practiceMcqModel;
      }
      showSnackBar("", practiceMcqModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getTopicBookmarkList(topicid, page);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", practiceMcqModel.message!);
      return practiceMcqModel;
    }
  }

  Future<BillingListModel?> getBillingList() async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.get(Uri.parse(mainLink + 'billing_list'), headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    BillingListModel billingListModel = billingListModelFromJson(jsonString);

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return billingListModel;
      }
      // showSnackBar("", billingListModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getBillingList();
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", billingListModel.message!);
      return billingListModel;
    }
  }

  Future<MainCategoryModel?> addBillingInformation(
      String name,
      String mobile,
      String email,
      String addressone,
      String addresstwo,
      String addressthree,
      String pincode) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'add_billing_details'),
            body: {
              'fullname': name,
              'mobile': mobile,
              'email': email,
              'address_one': addressone,
              'address_two': addresstwo,
              'address_three': addressthree,
              'pincode': pincode,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   addBillingInformation(
      //       name, mobile, email, addressone, addresstwo, addressthree, pincode);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<MainCategoryModel?> editBillingInformation(
      String billingid,
      String name,
      String mobile,
      String email,
      String addressone,
      String addresstwo,
      String addressthree,
      String pincode) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'update_billing_details'),
            body: {
              'billing_id': billingid,
              'fullname': name,
              'mobile': mobile,
              'email': email,
              'address_one': addressone,
              'address_two': addresstwo,
              'address_three': addressthree,
              'pincode': pincode,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   editBillingInformation(billingid, name, mobile, email, addressone,
      //       addresstwo, addressthree, pincode);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<MainCategoryModel?> setDefaultBilling(
    String billingid,
  ) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(
            mainLink + 'set_default_billing_details?billing_id=' + billingid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   setDefaultBilling(billingid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<CartModel?> getCartDetails() async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(Uri.parse(mainLink + 'get_cart_details'),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    CartModel cartModel = cartModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return cartModel;
      }
      showSnackBar("", cartModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getCartDetails();
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", cartModel.message!);
      return cartModel;
    }
  }

  Future<MainCategoryModel?> addToCart(
    String subscriptionid,
    String type,
    String duration,
    String price,
  ) async {
    Map<String, String> header = await apiHeader();

    var response = await client.post(Uri.parse(mainLink + 'add_to_cart'),
        body: {
          'subscription_id': subscriptionid,
          'type': type,
          'duration': duration,
          'price': price,
        },
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   addToCart(subscriptionid, type, duration, price);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<MainCategoryModel?> removeCartItem(
    String cartid,
  ) async {
    Map<String, String> header = await apiHeader();

    var response = await client.post(Uri.parse(mainLink + 'remove_from_cart'),
        body: {
          'cart_id': cartid,
        },
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }

      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   removeCartItem(cartid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<CouponListModel?> getCouponCodeList() async {
    Map<String, String> header = await apiHeader();

    var response = await client
        .get(Uri.parse(mainLink + 'get_coupon_code_list'), headers: header);

    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    CouponListModel couponModel = couponListModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return couponModel;
      }
      showSnackBar("", couponModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getCouponCodeList();
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", couponModel.message!);
      return couponModel;
    }
  }

  Future<CouponApplyModel?> applyCouponCode(
    String couponcode,
  ) async {
    Map<String, String> header = await apiHeader();

    var response = await client.post(Uri.parse(mainLink + 'apply_coupon_code'),
        body: {
          'apply_remove': 'apply',
          'coupon_code': couponcode,
        },
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    CouponApplyModel couponApplyModel = couponApplyModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return couponApplyModel;
      }

      showSnackBar("", couponApplyModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   applyCouponCode(couponcode);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", couponApplyModel.message!);
      return couponApplyModel;
    }
  }

  Future<MainCategoryModel?> doCheckoutPayment(String couponcode) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'order_payment_request'),
            body: {
              'coupon_code': couponcode,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCatModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCatModel;
      }
      showSnackBar("", mainCatModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   doCheckoutPayment(couponcode);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCatModel.message!);
      return mainCatModel;
    }
  }

  Future<LoginModel?> getProfile() async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.get(Uri.parse(mainLink + 'get_profile'), headers: header);

    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    if (kDebugMode) {
      print(response.body);
      print(response.statusCode);
    }
    LoginModel loginModel = loginModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (decodedResponse['status']) {
        return loginModel;
      }
      showSnackBar("", loginModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getProfile();
      // }
      print('get 403');
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", loginModel.message!);
      return loginModel;
    }
  }

  Future<MainCategoryModel?> addSubscriptionRating(
      String subscriptionid, String rating) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'add_subscription_rating'),
            body: {
              'subscription_id': subscriptionid,
              'rating': rating,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCatModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCatModel;
      }
      showSnackBar("", mainCatModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   addSubscriptionRating(subscriptionid, rating);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCatModel.message!);
      return mainCatModel;
    }
  }

  Future<MainCategoryModel?> getLogout() async {
    prefs.getAllPrefsClear();
    Get.offAndToNamed(AppRoutes.login);
    Map<String, String> header = await apiHeader();

    var response =
        await client.get(Uri.parse(mainLink + 'logout'), headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getLogout();
      // }
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<TestTopicModel?> getTestByTopic(String subjectid, int page) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink +
            'get_test_bytopiclist?subject_id=' +
            subjectid +
            '&page=' +
            page.toString()),
        headers: header);

    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    if (kDebugMode) {
      print(response.body);
      print(response.statusCode);
    }
    TestTopicModel testTopicModel = testTopicModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (decodedResponse['status']) {
        return testTopicModel;
      }
      showSnackBar("", testTopicModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getProfile();
      // }
      print('get 403');
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", testTopicModel.message!);
      return testTopicModel;
    }
  }

  Future<TestSubjectModel?> getTestBySubject(String subjectid, int page) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink +
            'get_test_by_subject?subject_id=' +
            subjectid +
            '&page=' +
            page.toString()),
        headers: header);

    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    if (kDebugMode) {
      print(response.body);
      print(response.statusCode);
    }
    TestSubjectModel testSubjectModel = testSubjectModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (decodedResponse['status']) {
        return testSubjectModel;
      }
      showSnackBar("", testSubjectModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getProfile();
      // }
      print('get 403');
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", testSubjectModel.message!);
      return testSubjectModel;
    }
  }

  Future<TestSubjectModel?> getTestBySingleTopic(
      String topicid, int page) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink +
            'get_test_by_single_topic?topic_id=' +
            topicid +
            '&page=' +
            page.toString()),
        headers: header);

    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    if (kDebugMode) {
      print(response.body);
      print(response.statusCode);
    }
    TestSubjectModel testSubjectModel = testSubjectModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (decodedResponse['status']) {
        return testSubjectModel;
      }
      showSnackBar("", testSubjectModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getProfile();
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", testSubjectModel.message!);
      return testSubjectModel;
    }
  }

  Future<TestMcqModel?> getTestMCQList(String testid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_test_question?test_id=' + testid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    TestMcqModel testMcqModel = testMcqModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return testMcqModel;
      }

      showSnackBar("", testMcqModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeMCQList(topicid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", testMcqModel.message!);
      return testMcqModel;
    }
  }

  Future<MainCategoryModel?> getTestBookmarked(String practiceid) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'test_question_bookmark'),
            body: {
              'question_id': practiceid,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeBookmarked(practiceid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<MainCategoryModel?> getTestReported(
      String practiceid, String comment) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'test_question_report'),
            body: {
              'question_id': practiceid,
              'message': comment,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeReported(practiceid, comment);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<MainCategoryModel?> getTestMarkReview(
      String practiceid, String markreview) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'test_question_mark_review'),
            body: {
              'question_id': practiceid,
              'mark_review': markreview,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeReported(practiceid, comment);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

//   question_id	integer	optional
// question_type	integer	optional
// answered_option	json_array	optional	[1,2,3] [based on question_type]
// taken_time	integer	optional	in second
// is_skip	integer	optional

  Future<MainCategoryModel?> getSingleTestSubmitted(
    String practiceid,
    String questionType,
    List<String> answerOption,
    String takenTime,
    String isSkip,
  ) async {
    Map<String, String> header = await apiHeader();

    var response = await client.post(
        Uri.parse(mainLink + 'add_single_test_question_answer'),
        body: {
          'question_id': practiceid,
          'question_type': questionType,
          'answered_option':
              answerOption.isEmpty ? '' : json.encode(answerOption),
          'taken_time': takenTime,
          'is_skip': isSkip,
        },
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeSubmitted(practiceid, questionType, answerOption, takenTime,
      //       isSkip, isTopicCompleted, subjectid, chapterid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<BeforeSubmitModel?> getWholeTestSubmittedBefore(
    String testid,
  ) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink +
            'test_confirmation_before_final_submit?test_id=' +
            testid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    BeforeSubmitModel mainCategoryModel = beforeSubmitModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeSubmitted(practiceid, questionType, answerOption, takenTime,
      //       isSkip, isTopicCompleted, subjectid, chapterid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<BeforeSubmitModel?> getWholeTestSubmittedFinal(
    String testid,
  ) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'add_final_test_answer?test_id=' + testid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    BeforeSubmitModel mainCategoryModel = beforeSubmitModelFromJson(jsonString);

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeSubmitted(practiceid, questionType, answerOption, takenTime,
      //       isSkip, isTopicCompleted, subjectid, chapterid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<ScoreCardModel?> getScoreCard(
    String testid,
  ) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(
            mainLink + 'get_test_score_card_topic_wise?test_id=' + testid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    ScoreCardModel scoreCardModel = scoreCardModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return scoreCardModel;
      }
      showSnackBar("", scoreCardModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeSubmitted(practiceid, questionType, answerOption, takenTime,
      //       isSkip, isTopicCompleted, subjectid, chapterid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", scoreCardModel.message!);
      return scoreCardModel;
    }
  }

  Future<ScoreCardModel?> getInstructions(
    String testid,
  ) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_test_introduction?test_id=' + testid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    ScoreCardModel scoreCardModel = scoreCardModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return scoreCardModel;
      }
      showSnackBar("", scoreCardModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeSubmitted(practiceid, questionType, answerOption, takenTime,
      //       isSkip, isTopicCompleted, subjectid, chapterid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", scoreCardModel.message!);
      return scoreCardModel;
    }
  }

  Future<TestMcqModel?> getTestMCQSolutionList(String testid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_final_test_question?test_id=' + testid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    TestMcqModel testMcqModel = testMcqModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return testMcqModel;
      }

      showSnackBar("", testMcqModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeMCQList(topicid);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", testMcqModel.message!);
      return testMcqModel;
    }
  }

  Future<QuestionWiseModel?> getQuestionWiseList(String testid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_question_analysis?test_id=' + testid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    QuestionWiseModel questionWiseModel = questionWiseModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return questionWiseModel;
      }

      showSnackBar("", questionWiseModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getSubjectBookmarkList(subjectid, page);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", questionWiseModel.message!);
      return questionWiseModel;
    }
  }

  Future<TopicWiseModel?> getTopicWise(String testid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_test_summary?test_id=' + testid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    TopicWiseModel topicWiseModel = topicWiseModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return topicWiseModel;
      }

      showSnackBar("", topicWiseModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getSubjectBookmarkList(subjectid, page);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", topicWiseModel.message!);
      return topicWiseModel;
    }
  }

  Future<CompetitiveModel?> getCompetitive(String testid) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_comparitive?test_id=' + testid),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    CompetitiveModel competitiveModel = competitiveModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return competitiveModel;
      }

      showSnackBar("", competitiveModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getSubjectBookmarkList(subjectid, page);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", competitiveModel.message!);
      return competitiveModel;
    }
  }

  Future<SubjectModel?> getPlanList(String type) async {
    Map<String, String> header = await apiHeader();
    var response = await client
        .get(Uri.parse(mainLink + 'get_myplan?type=' + type), headers: header);
    var jsonString = response.body;
    if (kDebugMode) {
      print(response.body);
    }
    Map decodedResponse = json.decode(jsonString);
    SubjectModel subjectModel = subjectModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (decodedResponse['status']) {
        return subjectModel;
      }
      showSnackBar("", subjectModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getSubjectList(subcategoryid, type);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", subjectModel.message!);
      return subjectModel;
    }
  }

  Future<MainCategoryModel?> getTestClearAnswer(String practiceid) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'test_temp_answer_clear'),
            body: {
              'question_id': practiceid,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeReported(practiceid, comment);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<MainCategoryModel?> getNotificationOnOff(String onoff) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'notification_on_off'),
            body: {
              'is_notification_send': onoff,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    MainCategoryModel mainCategoryModel = mainCategoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeReported(practiceid, comment);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<OrderHistoryModel?> getOrderHistoryList() async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(Uri.parse(mainLink + 'get_order_history'),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    OrderHistoryModel mainModel = orderHistoryModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainModel;
      }
      showSnackBar("", mainModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getBlogList();
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainModel.message!);
      return mainModel;
    }
  }

  Future<GeneralModel?> getProfilePhotoUpdate(
      XFile? file, String isRemove) async {
    Map<String, String> header = await apiHeader();

    var formData = dio.FormData.fromMap({
      'is_remove': isRemove,
      'image': file == null
          ? null
          : await dio.MultipartFile.fromFile(file.path, filename: file.name),
    });

    var response = await Dio().post(mainLink + 'update_profile_image',
        data: formData, options: dio.Options(headers: header));

    var jsonString = response.data;

    print(jsonString);

    GeneralModel mainCategoryModel =
        generalModelFromJson(jsonEncode(jsonString));
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.data);
      }

      if (mainCategoryModel.status!) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getPracticeReported(practiceid, comment);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }

  Future<NotificationListModel?> getNotificationList(int page) async {
    Map<String, String> header = await apiHeader();

    var response = await client.get(
        Uri.parse(mainLink + 'get_notification_list?page=' + page.toString()),
        headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    NotificationListModel mainModel = notificationListModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainModel;
      }
      showSnackBar("", mainModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getBlogList();
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainModel.message!);
      return mainModel;
    }
  }

  Future<GeneralModel?> getNotificationRead(String id) async {
    Map<String, String> header = await apiHeader();

    var response = await client.post(
      Uri.parse(mainLink + 'set_notification_read'),
      body: {
        'id': id,
      },
      headers: header,
    );
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    GeneralModel mainModel = generalModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainModel;
      }
      showSnackBar("", mainModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   getBlogList();
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainModel.message!);
      return mainModel;
    }
  }

  Future<GeneralModel?> addContactInfo(
    String name,
    String mobile,
    String email,
    String comment,
  ) async {
    Map<String, String> header = await apiHeader();

    var response =
        await client.post(Uri.parse(mainLink + 'add_contact_inquiry'),
            body: {
              'name': name,
              'mobile': mobile,
              'email': email,
              'comment': comment,
            },
            headers: header);
    var jsonString = response.body;
    Map decodedResponse = json.decode(jsonString);
    GeneralModel mainCategoryModel = generalModelFromJson(jsonString);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }

      if (decodedResponse['status']) {
        return mainCategoryModel;
      }
      showSnackBar("", mainCategoryModel.message!);

      return null;
    } else if (response.statusCode == 403) {
      // int? tokenStatus = await getRefreshToken();
      // if (tokenStatus == 200) {
      //   addBillingInformation(
      //       name, mobile, email, addressone, addresstwo, addressthree, pincode);
      // }
      getStaticLogout();
      return null;
    } else {
      showSnackBar("", mainCategoryModel.message!);
      return mainCategoryModel;
    }
  }
}
