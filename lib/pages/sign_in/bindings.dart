import 'package:get/get.dart';

import 'controller.dart';

class SignInBinding implements Bindings{
  @override
  void dependencies() {
    //we need to put here the controllers that we want load.
    Get.lazyPut<SignInController>(() => SignInController());
  }
}