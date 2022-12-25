import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/controllers/dashboard_controller.dart';
import 'package:flutter_practicekiya/controllers/login_controller.dart';

import 'package:flutter_practicekiya/utils/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/payment_controller.dart';
import '../models/maincategory_model.dart';

import '../services/remote_services.dart';

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen({Key? key}) : super(key: key);

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  LoginController? loginController;
  PaymentController? paymentController;
  DashboardController? dashboardController;

  String? screen, userid, mobileemail;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    loginController = Get.find<LoginController>();
    paymentController = Get.find<PaymentController>();
    dashboardController = Get.find<DashboardController>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loginController!.searchController!.clear();
      loginController!.selectedCategoryList.clear();
      loginController!.mainCategoryList.clear();
      loginController!.getSelectedCategory(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          alignment: Alignment.center,
          child: Padding(
              padding: const EdgeInsets.all(0),
              child: Stack(
                // alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/wholeappback.jpg'),
                        fit: BoxFit.cover,
                      ),
                      // color: Colors.white,
                    ),
                  ),
                  Visibility(
                      replacement: const Center(
                        child: Text("Loading..."),
                      ),
                      visible: !loginController!.isLoading.value,
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
                              paymentController!.appBar(
                                  false,
                                  'Edit your goals',
                                  kPrimaryColorDark,
                                  context,
                                  scaffoldKey),
                            ]),
                          ),
                          Expanded(
                              flex: 10,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 10,
                                        bottom: 10),
                                    child: TextFormField(
                                      controller:
                                          loginController!.searchController,
                                      keyboardType: TextInputType.name,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      style: TextStyle(fontSize: 14.sp),
                                      onChanged: (value) {
                                        debounce(
                                            loginController!.count,
                                            (_) => loginController!
                                                .searchMainCategory(
                                                    true, value),
                                            time: const Duration(
                                                milliseconds: 500));

                                        loginController!
                                            .searchMainCategory(true, value);
                                      },
                                      decoration: InputDecoration(
                                          hintText: 'Search goal by name',
                                          hintStyle: const TextStyle(
                                              color: kSecondaryColor),
                                          suffixIcon: GestureDetector(
                                            onTap: () {},
                                            child: const Icon(
                                              Icons.search_rounded,
                                              color: kPrimaryColorDark,
                                            ),
                                          )),
                                    ),
                                  ),
                                  Obx(() {
                                    return loginController!
                                            .selectedCategoryList.isNotEmpty
                                        ? Expanded(
                                            flex: 1,
                                            child: GridView.builder(
                                              // separatorBuilder: (context, index) => const Divider(),
                                              itemCount: loginController!
                                                  .selectedCategoryList.length,
                                              controller:
                                                  loginController!.controller,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return itemWidgetSelectedGoals(
                                                    loginController!
                                                            .selectedCategoryList[
                                                        index],
                                                    index);
                                              },
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 1,
                                                      mainAxisSpacing: 15,
                                                      crossAxisSpacing: 15,
                                                      childAspectRatio: 1),
                                            ))
                                        : const Text('');
                                  }),

                                  // loginController!.selectedCategoryList.isNotEmpty
                                  // ? Expanded(
                                  //     flex: 1,
                                  //     child: Obx(() {
                                  //       return Container(
                                  //         // margin: EdgeInsets.all(10),
                                  //         child: GridView.builder(
                                  //           // separatorBuilder: (context, index) => const Divider(),
                                  //           itemCount: loginController!
                                  //               .selectedCategoryList.length,
                                  //           controller:
                                  //               loginController!.controller,
                                  //           scrollDirection: Axis.horizontal,
                                  //           itemBuilder: (context, index) {
                                  //             return itemWidgetSelectedGoals(
                                  //                 loginController!
                                  //                         .selectedCategoryList[
                                  //                     index],
                                  //                 index);
                                  //           },
                                  //           gridDelegate:
                                  //               const SliverGridDelegateWithFixedCrossAxisCount(
                                  //                   crossAxisCount: 1,
                                  //                   mainAxisSpacing: 15,
                                  //                   crossAxisSpacing: 15,
                                  //                   childAspectRatio: 1),
                                  //         ),
                                  //       );
                                  //     }),
                                  //   )
                                  // : Text(''),
                                  Expanded(
                                    flex: 2,
                                    child: Obx(() {
                                      return ListView.separated(
                                        padding: const EdgeInsets.all(0),
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                        itemCount: loginController!
                                            .mainCategoryList.length,
                                        controller: loginController!.controller,
                                        itemBuilder: (context, index) {
                                          return itemWidgetGoals(
                                              loginController!
                                                  .mainCategoryList[index],
                                              index);
                                        },
                                      );
                                    }),
                                  ),
                                  Obx(() {
                                    return loginController!.isLoading.value
                                        ? Container(
                                            height: 40,
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // Image.asset(
                                                //     'assets/images/bottomloader.gif',
                                                //     cacheWidth: 60),
                                                Text(
                                                  'Loading...',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : Container();
                                  }),
                                ],
                              )),
                          GestureDetector(
                            onTap: () {
                              loginController!.checkSelectedCategories('Edit');

                              dashboardController!.tabIndex.value = 0;
                              dashboardController!.changeTabIndex(0);
                            },
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(
                                  top: 12, bottom: 12, right: 20, left: 20),
                              decoration: boxDecorationRect(
                                  kPrimaryColor, kPrimaryColorLight),
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }

  Widget itemWidgetGoals(MainCategoryData model, int index) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      // padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: boxDecorationRect(Colors.white, Colors.white),
                      // padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FadeInImage.assetNetwork(
                          height: 45,
                          width: 45,
                          placeholder: "assets/images/placeholder.png",
                          fit: BoxFit.contain,
                          imageErrorBuilder: (context, url, error) =>
                              const Image(
                            alignment: Alignment.center,
                            image: AssetImage("assets/images/placeholder.png"),
                            height: 45,
                            width: 45,
                          ),
                          image: RemoteServices.imageMainLink + model.image!,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      model.categoryname!,
                      style: TextStyle(color: Colors.black, fontSize: 12.sp),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    loginController!.addSelectedCategory(index);
                  },
                  child: const Icon(Icons.add),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemWidgetSelectedGoals(MainCategoryData model, int index) {
    return Container(
        // width: double.infinity,
        decoration: boxDecorationRect(Colors.white, Colors.white),
        // decoration: BoxDecoration(
        //     border: Border.all(color: kTextColor),
        //     borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7.0),
                        child: FadeInImage.assetNetwork(
                          height: 90,
                          width: 90,
                          placeholder: "assets/images/placeholder.png",
                          imageErrorBuilder: (context, url, error) =>
                              const Image(
                            alignment: Alignment.center,
                            image: AssetImage("assets/images/placeholder.png"),
                            height: 90,
                            width: 90,
                          ),
                          fit: BoxFit.contain,
                          image: RemoteServices.imageMainLink + model.image!,
                        ),
                      ),
                      Expanded(
                          child: Text(
                        model.categoryname.toString(),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: TextStyle(color: Colors.black, fontSize: 12.sp),
                      ))
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  loginController!.removeSelectedCategory(index);
                },
                child: const Icon(
                  Icons.cancel,
                  color: kPrimaryColor,
                ),
              ),
            ),
          ],
        ));
  }
}
