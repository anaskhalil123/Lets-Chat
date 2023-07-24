import 'package:Lets_Chat/pages/contact/controller.dart';
import 'package:Lets_Chat/pages/profile/controller.dart';
import 'package:get/get.dart';

import '../contact/index.dart';
import '../message/index.dart';
import 'controller.dart';

class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    //we need to put here the controllers that we want load.
    //2- we should add here all controllers inside the application pages,
    // chat controller and contact controller and profile controller

    Get.lazyPut<ApplicationController>(() => ApplicationController());
    Get.lazyPut<ContactController>(() => ContactController());
    Get.lazyPut<MessageController>(() => MessageController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
