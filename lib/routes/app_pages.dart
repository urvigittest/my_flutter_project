import 'package:flutter_practicekiya/bindings/dashboard_controller_binding.dart';
import 'package:flutter_practicekiya/bindings/home_controller_binding.dart';
import 'package:flutter_practicekiya/bindings/listing_controller_binding.dart';
import 'package:flutter_practicekiya/bindings/payment_controller_binding.dart';
import 'package:flutter_practicekiya/bindings/practicemcq_controller_binding.dart';
import 'package:flutter_practicekiya/bindings/testmcq_controller_binding.dart';
import 'package:flutter_practicekiya/models/notificationlist_model.dart';

import 'package:flutter_practicekiya/views/billinginformation_screen.dart';
import 'package:flutter_practicekiya/views/blogdetail_screen.dart';
import 'package:flutter_practicekiya/views/bloglist_screen.dart';
import 'package:flutter_practicekiya/views/cart_screen.dart';
import 'package:flutter_practicekiya/views/chapterlist_screen.dart';
import 'package:flutter_practicekiya/views/contactform_screen.dart';
import 'package:flutter_practicekiya/views/dashboard_screen.dart';
import 'package:flutter_practicekiya/views/editcategory_screen.dart';
import 'package:flutter_practicekiya/views/editprofile_screen.dart';
import 'package:flutter_practicekiya/views/login_screen.dart';
import 'package:flutter_practicekiya/views/notificationlist_screen.dart';
import 'package:flutter_practicekiya/views/offerslist_screen.dart';
import 'package:flutter_practicekiya/views/orderhistory_screen.dart';
import 'package:flutter_practicekiya/views/paymentwebview_screen.dart';
import 'package:flutter_practicekiya/views/pdfview_screen.dart';
import 'package:flutter_practicekiya/views/practicemcq_screen.dart';
import 'package:flutter_practicekiya/views/scorecard_screen.dart';
import 'package:flutter_practicekiya/views/selectcoupon_screen.dart';
import 'package:flutter_practicekiya/views/signupfourth_screen.dart';
import 'package:flutter_practicekiya/views/signupsecond_screen.dart';
import 'package:flutter_practicekiya/views/signupthird_screen.dart';
import 'package:flutter_practicekiya/views/subjectdetails_screen.dart';
import 'package:flutter_practicekiya/views/subjectlist_screen.dart';
import 'package:flutter_practicekiya/views/testanalysis_screen.dart';
import 'package:flutter_practicekiya/views/testmcq_screen.dart';
import 'package:flutter_practicekiya/views/testsingletopic_screen.dart';
import 'package:flutter_practicekiya/views/testtopicsubject_screen.dart';
import 'package:flutter_practicekiya/views/topicanalysis_screen.dart';
import 'package:flutter_practicekiya/views/topiclist_screen.dart';
import 'package:flutter_practicekiya/views/videosolution_screen.dart';
import 'package:get/get.dart';

import '../bindings/login_controller_binding.dart';
import '../views/addeditbillinginformation_screen.dart';
import '../views/letsgetstarted_screen.dart';
import '../views/reminder_screen.dart';
import '../views/signupone_screen.dart';
import '../views/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: AppRoutes.root, page: () => const SplashScreen()),
    GetPage(
      name: AppRoutes.letsgetstarted,
      page: () => const LetsGetStartedScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      bindings: [
        LoginControllerBinding(),
        DashboardControllerBinding(),
      ],
    ),
    GetPage(
        name: AppRoutes.signupone,
        page: () => const SignUpOneScreen(),
        binding: LoginControllerBinding()),
    GetPage(
        name: AppRoutes.signupsecond,
        page: () => const SignUpSecondScreen(),
        binding: LoginControllerBinding()),
    GetPage(
        name: AppRoutes.signupthird,
        page: () => const SignUpThirdScreen(),
        binding: LoginControllerBinding()),
    GetPage(
        name: AppRoutes.signupfourth,
        page: () => const SignUpFourthScreen(),
        binding: LoginControllerBinding()),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      bindings: [
        LoginControllerBinding(),
        DashboardControllerBinding(),
        HomeControllerBinding(),
        PaymentControllerBinding(),
        ListingControllerBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.subjectlist,
      page: () => const SubjectListScreen(),
      bindings: [
        ListingControllerBinding(),
        PaymentControllerBinding(),
        HomeControllerBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.bloglist,
      page: () => const BlogListScreen(),
      bindings: [HomeControllerBinding(), PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.blogdetail,
      page: () => const BlogDetailScreen(),
      bindings: [HomeControllerBinding(), PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.chapterlist,
      page: () => const ChapterListScreen(),
      bindings: [
        ListingControllerBinding(),
        PracticeMCQControllerBinding(),
        PaymentControllerBinding()
      ],
    ),
    GetPage(
      name: AppRoutes.topiclist,
      page: () => const TopicListScreen(),
      bindings: [ListingControllerBinding(), PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.practicemcq,
      page: () => const PracticeMCQScreen(),
      bindings: [
        PracticeMCQControllerBinding(),
        PaymentControllerBinding(),
        ListingControllerBinding()
      ],
    ),
    GetPage(
      name: AppRoutes.subjectdetail,
      page: () => const SubjectDetailsScreen(),
      bindings: [ListingControllerBinding(), PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.topicanalysis,
      page: () => const TopicAnalysisScreen(),
      bindings: [
        PracticeMCQControllerBinding(),
        PaymentControllerBinding(),
        ListingControllerBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.pdfviewpage,
      page: () => const PDFViewScreen(),
    ),
    GetPage(
      name: AppRoutes.billinginformation,
      page: () => const BillingInformationScreen(),
      bindings: [PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.addeditbillinginfo,
      page: () => const AddEditBillingInformationScreen(),
      bindings: [PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.subscriptioncart,
      page: () => const CartScreen(),
      bindings: [PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.couponlist,
      page: () => const SelectCouponScreen(),
      bindings: [PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.paymentwebview,
      page: () => const PaymentWebviewScreen(),
      bindings: [PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.editprofile,
      page: () => const EditProfileScreen(),
      bindings: [PaymentControllerBinding(), LoginControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.editcategory,
      page: () => const EditCategoryScreen(),
      bindings: [
        PaymentControllerBinding(),
        LoginControllerBinding(),
        DashboardControllerBinding()
      ],
    ),
    GetPage(
      name: AppRoutes.testtopicsubject,
      page: () => const TestTopicSubjectScreen(),
      bindings: [ListingControllerBinding(), PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.testsingletopic,
      page: () => const TestSingleTopicScreen(),
      bindings: [ListingControllerBinding(), PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.testmcq,
      page: () => const TestMCQScreen(),
      bindings: [
        TestMCQControllerBinding(),
        PaymentControllerBinding(),
        ListingControllerBinding()
      ],
    ),
    GetPage(
      name: AppRoutes.scorecard,
      page: () => const ScoreCardScreen(),
      bindings: [
        TestMCQControllerBinding(),
        PaymentControllerBinding(),
        ListingControllerBinding()
      ],
    ),
    GetPage(
      name: AppRoutes.testanalysis,
      page: () => const TestAnalysisScreen(),
      bindings: [
        TestMCQControllerBinding(),
        PaymentControllerBinding(),
        ListingControllerBinding()
      ],
    ),
    GetPage(
      name: AppRoutes.planlist,
      page: () => const SubjectListScreen(),
      bindings: [
        ListingControllerBinding(),
        PaymentControllerBinding(),
        HomeControllerBinding(),
        DashboardControllerBinding()
      ],
    ),
    GetPage(
      name: AppRoutes.offerslist,
      page: () => const OffersListScreen(),
      bindings: [DashboardControllerBinding(), PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.videosolution,
      page: () => const VideoSolutionScreen(),
    ),
    GetPage(
      name: AppRoutes.orderhistory,
      page: () => const OrderHistoryScreen(),
      bindings: [HomeControllerBinding(), PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.reminder,
      page: () => const ReminderScreen(),
      bindings: [HomeControllerBinding(), PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.notificationlist,
      page: () => const NotificationListScreen(),
      bindings: [HomeControllerBinding(), PaymentControllerBinding()],
    ),
    GetPage(
      name: AppRoutes.contactform,
      page: () => const ContactFormScreen(),
      bindings: [PaymentControllerBinding()],
    ),
  ];
}
