import 'package:Lets_Chat/pages/profile/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../common/values/colors.dart';
import '../../common/widgets/app.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  AppBar _buildAppBar() {
    return transparentAppBar(
      title: Text(
        'Profile',
        style: TextStyle(
            color: AppColors.primaryBackground,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(
        () => Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 234, 234, 234),
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 2,
                    blurRadius: 20,
                    offset: Offset.fromDirection(0, 3),
                  )
                ],
              ),
              padding: EdgeInsets.only(
                top: 10.w,
                left: 15.w,
                right: 5.w,
                bottom: 8.w,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.amber,
                    radius: 32,
                    backgroundImage: CachedNetworkImageProvider(
                        controller.state.userAvatar.value),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(top: 10.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.state.name.value,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.bold,
                              color: AppColors.thirdElement,
                              fontSize: 15.sp),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          'ID: ${controller.state.uid.value}',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.normal,
                              color: AppColors.fourElementText,
                              fontSize: 13.sp),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
                child: Column(
                  children: [
                    ProfileItem(
                        imagePath: 'assets/icons/1.png',
                        name: 'Account',
                        onClick: () {}),
                    ProfileItem(
                        imagePath: 'assets/icons/2.png',
                        name: 'Chat',
                        onClick: () {}),
                    ProfileItem(
                        imagePath: 'assets/icons/3.png',
                        name: 'Notification',
                        onClick: () {}),
                    ProfileItem(
                        imagePath: 'assets/icons/4.png',
                        name: 'Privacy',
                        onClick: () {}),
                    ProfileItem(
                        imagePath: 'assets/icons/5.png',
                        name: 'Help',
                        onClick: () {}),
                    ProfileItem(
                        imagePath: 'assets/icons/6.png',
                        name: 'About',
                        onClick: () {}),
                    ProfileItem(
                        imagePath: 'assets/icons/7.png',
                        name: 'Logout',
                        onClick: () {
                          controller.logOut();
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  ProfileItem({
    super.key,
    required this.name,
    required this.imagePath,
    required this.onClick,
  });
  String name = '';
  String imagePath = 'assets/icons/1.png';
  void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
            width: 50.w,
            image: AssetImage(imagePath),
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            name,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: "Avenir",
                fontWeight: FontWeight.bold,
                color: AppColors.thirdElement,
                fontSize: 14.sp),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios),
            color: AppColors.fourElementText,
            onPressed: onClick,
          ),
        ],
      ),
    );
  }
}
