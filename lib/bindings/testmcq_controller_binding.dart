import 'package:get/get.dart';

import '../controllers/testmcq_controller.dart';

class TestMCQControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TestMCQController>(() => TestMCQController());
  }
}
