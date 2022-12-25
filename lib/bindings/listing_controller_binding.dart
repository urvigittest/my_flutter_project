import 'package:flutter_practicekiya/controllers/listing_controller.dart';
import 'package:get/get.dart';

class ListingControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListingController>(() => ListingController());
  }
}
