import 'package:flutter_practicekiya/controllers/practicemcq_controller.dart';
import 'package:get/get.dart';

class PracticeMCQControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PracticeMCQController>(() => PracticeMCQController());
  }
}
