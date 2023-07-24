import 'package:Lets_Chat/common/widgets/button.dart';
import 'package:Lets_Chat/pages/sign_in/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/values/colors.dart';
import '../../common/values/shadows.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

  Widget _buildLogo() {
    return Container(
      width: 110.w,
      margin: EdgeInsets.only(top: 84.w),
      child: Column(
        children: [
          Container(
            width: 76.w,
            height: 76.w,
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    height: 76.w,
                    decoration: const BoxDecoration(
                        color: AppColors.primaryBackground,
                        boxShadow: [Shadows.primaryShadow],
                        borderRadius: BorderRadius.all(Radius.circular(35))),
                  ),
                ),
                Positioned(
                  child: Image.asset(
                    'assets/images/ic_launcher.png',
                    width: 76.w,
                    height: 76.w,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 15.h),
            child: Text(
              "Let's chat",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.thirdElement,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  height: 1),
            ),
          )
        ],
      ),
    );
  }

  Widget buildThirdPartyLogin() {
    return Container(
      margin: EdgeInsets.only(bottom: 185.w),
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(bottom: 30.h),
          child: Text(
            'Sign in with social networks',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
          ),
        ),
        btnFlatButtonWidget(
          title: 'Google Login',
          onPressed: () {
            controller.handleGoogleSignIn();
          },
          width: 170.w,
          height: 70.h,
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [_buildLogo(), const Spacer(), buildThirdPartyLogin()],
        ),
      ),
    );
  }
}
