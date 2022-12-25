import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/controllers/home_controller.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../controllers/payment_controller.dart';
import '../services/remote_services.dart';
import '../utils/theme.dart';

class BlogDetailScreen extends StatefulWidget {
  const BlogDetailScreen({Key? key}) : super(key: key);

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  HomeController? homeController;
  PaymentController? paymentController;
  String? blogid, blogname;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    homeController = Get.find<HomeController>();
    paymentController = Get.find<PaymentController>();
    blogid =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_blog")['blogid'];
    blogname = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_blog")['blogname'];

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      homeController!.getBlogDetails(true, blogid!);
    });
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
                        height: 120.h,
                        decoration: const BoxDecoration(
                          // border: Border.all(color: kPrimaryColorDark),
                          color: kPrimaryColorDark,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Column(children: [
                          paymentController!.appBar(false, 'Blog Detail',
                              kPrimaryColorDark, context, scaffoldKey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  height: 25,
                                  width: 25,
                                  child: SvgPicture.asset(
                                    'assets/images/blogimg.svg',
                                    width: 25.w,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      blogname!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ]),
                      ),
                      Expanded(
                        child: Obx(() {
                          return Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              child: ListView(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: FadeInImage.assetNetwork(
                                      height: 200,
                                      placeholder:
                                          "assets/images/placeholder.png",
                                      imageErrorBuilder:
                                          (context, url, error) => const Image(
                                        alignment: Alignment.center,
                                        image: AssetImage(
                                            'assets/images/placeholder.png'),
                                      ),
                                      fit: BoxFit.fill,
                                      image: RemoteServices.imageMainLink +
                                          homeController!.blogData.value.image!,
                                      // image:'https://www.pixinvent.com/materialize-material-design-admin-template/laravel/demo-4/images/avatar/avatar-7.png'
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      homeController!
                                          .blogData.value.shortDescription!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: kDarkBlueColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(10),
                                    // alignment: Alignment.topLeft,
                                    child: HtmlWidget(
                                      //to show HTML as widget.
                                      homeController!
                                          .blogData.value.longDescription!,
                                      webView: true,
                                      textStyle: TextStyle(
                                          color: kPrimaryColorDark,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                    ),

                                    // TeXView(
                                    //   style: TeXViewStyle(
                                    //       textAlign: TeXViewTextAlign.center),
                                    //   child: TeXViewDocument(homeController!
                                    //       .blogData.value.longDescription
                                    //       .toString()),
                                    // )
                                  )
                                ],
                              ));
                        }),
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}
