import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_practicekiya/utils/preferences.dart';

import 'package:get/get.dart';

import '../controllers/payment_controller.dart';
import '../routes/app_routes.dart';
import '../utils/theme.dart';

class PaymentWebviewScreen extends StatefulWidget {
  const PaymentWebviewScreen({Key? key}) : super(key: key);

  @override
  State<PaymentWebviewScreen> createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  PaymentController? paymentController;
  Prefs prefs = Prefs();
  final scaffoldKey = GlobalKey<ScaffoldState>();
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
                          paymentController!.appBar(false, 'Checkout Payment',
                              kPrimaryColorDark, context, scaffoldKey),
                        ]),
                      ),
                      Expanded(
                        // flex: 1,
                        child: Obx(() {
                          return InAppWebView(
                            initialUrlRequest: URLRequest(
                                url: Uri.parse(
                                    paymentController!.paymentLink!.value)),
                            // initialUrlRequest: URLRequest(url: Uri.parse('https://pub.dev/packages/flutter_inappwebview/versions/5.0.5+2')),
                            // onWebViewCreated:
                            //     (InAppWebViewController webViewController) {
                            //   paymentController!.inAppWebviewController
                            //       .complete(webViewController);
                            // },
                            onUpdateVisitedHistory:
                                (controller, url, androidIsReload) {
                              print('webview link called->' + url.toString());
                              if (url.toString().contains('failed')) {
                                Future.delayed(const Duration(seconds: 4), () {
                                  Get.toNamed(AppRoutes.dashboard);
                                });
                              } else if (url.toString().contains('thankyou')) {
                                prefs.setCartCount('0');
                                Future.delayed(const Duration(seconds: 4), () {
                                  Get.toNamed(AppRoutes.dashboard);
                                });
                              }
                            },
                          );
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // paymentController!.inAppWebviewController.
  }
}
