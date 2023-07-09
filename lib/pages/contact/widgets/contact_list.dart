import 'package:firebase_chating/common/entities/entities.dart';
import 'package:firebase_chating/common/values/colors.dart';
import 'package:firebase_chating/pages/contact/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

class ContactList extends GetView<ContactController> {
  const ContactList({super.key});

  Widget buildListItem(UserData item) {
    return Container(
      padding: EdgeInsets.only(top: 15.w, bottom: 0.w, left: 15.w, right: 15.w),
      child: InkWell(
        onTap: () {
          if (item.id != null) {
            controller.goChat(item);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 0.w, bottom: 0.w, left: 0.w, right: 15.w),
              child: SizedBox(
                  width: 54.w,
                  height: 54.w,
                  child: CachedNetworkImage(imageUrl: "${item.photourl}")),
            ),
            Container(
              width: 250.w, // how that?!
              padding: EdgeInsets.only(
                  top: 15.w, bottom: 0.w, left: 0.w, right: 0.w),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xffE5EFE5)))),
              child: Row(
                children: [
                  SizedBox(
                    width: 200.w,
                    height: 42.w,
                    child: Text(item.name ?? "",
                        style: TextStyle(
                            fontFamily: "Avenir",
                            fontWeight: FontWeight.bold,
                            color: AppColors.thirdElement,
                            fontSize: 16.sp)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  print('reach the slevers');
                  var item = controller.state.contactList[index];
                  return buildListItem(item);
                },
                childCount: controller.state.contactList.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
