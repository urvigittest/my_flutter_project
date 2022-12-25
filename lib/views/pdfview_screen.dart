import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../utils/theme.dart';

class PDFViewScreen extends StatefulWidget {
  const PDFViewScreen({Key? key}) : super(key: key);

  @override
  State<PDFViewScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<PDFViewScreen> {
  // DashboardController? dashboardController;
  String? pdfUrl, pfdTitle;
  @override
  void initState() {
    super.initState();
    // dashboardController = Get.find<DashboardController>();
    pdfUrl =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_pdf")['pdfUrl'];
    pfdTitle =
        GetIt.I<Map<String, dynamic>>(instanceName: "selected_pdf")['pfdTitle'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        backgroundColor: kPrimaryColorDark,
        elevation: 0,
        leadingWidth: 30,
        leading: GestureDetector(
          onTap: () {
            Get.back(result: 'success');
          },
          child: Container(
            color: Colors.transparent,
            margin: const EdgeInsets.all(5),
            height: 25,
            width: 25,
            child: SvgPicture.asset(
              'assets/images/backarrow.svg',
              width: 25,
            ),
          ),
        ),
        title: Text(
          pfdTitle!,
          style: TextStyle(color: Colors.white, fontSize: 14.sp),
        ),
      ),
      body: const PDF().cachedFromUrl(
        pdfUrl!,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
