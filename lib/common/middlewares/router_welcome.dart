import 'package:flutter/material.dart';
import 'package:firebase_chat/common/routes/routes.dart';
import 'package:firebase_chat/common/store/store.dart';

import 'package:get/get.dart';

/// 第一次欢迎页面
class RouteWelcomeMiddleware extends GetMiddleware {
  // priority 数字小优先级高
  @override
  int? priority = 0;

  RouteWelcomeMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    print(ConfigStore.to.isFirstOpen);
    if (ConfigStore.to.isFirstOpen == false) {
      return null;
    } else if (UserStore.to.isLogin == true) {
      return RouteSettings(name: AppRoutes.Application);
    } else {
      return RouteSettings(name: AppRoutes.SIGN_IN);
    }
  }
}
