import 'package:get/get.dart';

import 'controller.dart';

class ApplicationBinding implements Bindings{
  @override
  void dependencies() {
    //we need to put here the controllers that we want load.
    Get.lazyPut<ApplicationController>(() => ApplicationController());
  }
}