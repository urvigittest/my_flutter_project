import 'package:flutter/material.dart';
import 'package:flutter_practicekiya/controllers/login_controller.dart';

import 'package:flutter_practicekiya/utils/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../models/maincategory_model.dart';

import '../services/remote_services.dart';

class SignUpFourthScreen extends StatefulWidget {
  const SignUpFourthScreen({Key? key}) : super(key: key);

  @override
  State<SignUpFourthScreen> createState() => _SignUpFourthScreenState();
}

class _SignUpFourthScreenState extends State<SignUpFourthScreen> {
  LoginController? loginController;

  String? screen, userid, mobileemail;

  @override
  void initState() {
    super.initState();
    loginController = Get.find<LoginController>();
    screen = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_logintype")['screen'];
    userid = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_logintype")['userid'];
    mobileemail = GetIt.I<Map<String, dynamic>>(
        instanceName: "selected_logintype")['mobileemail'];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loginController!.selectedCategoryList.clear();
      loginController!.searchMainCategory(true, '');
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
                  Container(
                    height: 300,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/dot_back.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    height: 250,
                    alignment: Alignment.centerRight,
                    child: Image.asset(
                      'assets/images/triangle.png',
                      height: 100,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(top: 50, right: 10, left: 10),
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
                            decoration: boxDecorationStep(
                                kPrimaryColorDarkLight,
                                kPrimaryColorDark,
                                kPrimaryColorDark),
                            child: const Text(
                              '2',
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
                            decoration: boxDecorationStep(
                                kPrimaryColorDarkLight,
                                kPrimaryColorDark,
                                kPrimaryColorDark),
                            child: const Text(
                              '3',
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
                            decoration: boxDecorationStep(
                                kPrimaryColorDarkLight,
                                kPrimaryColorDark,
                                kPrimaryColorDark),
                            child: const Text(
                              '4',
                              style: TextStyle(
                                  color: Colors.white,
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
                                  'Select Your Goal',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10, bottom: 10),
                                child: TextFormField(
                                  controller: loginController!.searchController,
                                  keyboardType: TextInputType.name,
                                  textCapitalization: TextCapitalization.words,
                                  style: TextStyle(fontSize: 14.sp),
                                  onChanged: (value) {
                                    debounce(
                                        loginController!.count,
                                        (_) => loginController!
                                            .searchMainCategory(true, value),
                                        time:
                                            const Duration(milliseconds: 500));

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
                          loginController!.checkSelectedCategories(screen!);
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
                  )
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
