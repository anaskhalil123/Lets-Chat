import 'package:firebase_chating/pages/welcome/controller.dart';
import 'package:get/get.dart';

class WelcomeBinding implements Bindings{
  @override
  void dependencies() {
    //we need to put here the controllers that we want load.
    Get.lazyPut<WelcomeController>(() => WelcomeController());
  }
}