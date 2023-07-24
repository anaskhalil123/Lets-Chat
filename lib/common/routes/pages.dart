import '../../pages/message/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../pages/application/index.dart';
import '../../pages/contact/index.dart';
import '../../pages/sign_in/index.dart';
import '../../pages/profile/index.dart';
import '../../pages/chat/index.dart';
import '../../pages/welcome/index.dart';
import '../middlewares/router_welcome.dart';
import 'routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.INITIAL;
  static const APPlication = AppRoutes.Application;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
        name: AppRoutes.INITIAL,
        page: () => const WelcomePage(),
        binding: WelcomeBinding(),
        middlewares: [RouteWelcomeMiddleware(priority: 1)]),
    GetPage(
      name: AppRoutes.SIGN_IN,
      page: () => const SignInPage(),
      binding: SignInBinding(),
    ),

    // check if needed to login or not
    GetPage(
      name: AppRoutes.Application,
      page: () => ApplicationPage(),
      binding: ApplicationBinding(),
      // middlewares: const [
      //   // RouteAuthMiddleware(priority: 1),
      // ],
    ),
    GetPage(
      name: AppRoutes.Contact,
      page: () => ContactPage(),
      binding: ContactBinding(),
    ),
    GetPage(
      name: AppRoutes.Chat,
      page: () => ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.Message,
      page: () => MessagePage(),
      binding: MessageBinding(),
    ),
    GetPage(
      name: AppRoutes.Profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
/*
    //消息
    GetPage(name: AppRoutes.Message, page: () => MessagePage(), binding: MessageBinding()),
    //我的
   
    //聊天详情
    GetPage(name: AppRoutes.Photoimgview, page: () => PhotoImgViewPage(), binding: PhotoImgViewBinding()),*/
  ];
}
