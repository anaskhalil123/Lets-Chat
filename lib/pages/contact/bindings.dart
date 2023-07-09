import 'package:get/get.dart';

class ContactBinding implements Bindings{
  @override
  void dependencies() {
    //we need to put here the controllers that we want load.
    // Get.lazyPut<ContactController>(() => ContactController());
  }
}