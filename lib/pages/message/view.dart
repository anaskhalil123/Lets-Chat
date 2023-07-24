import 'package:Lets_Chat/pages/message/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/entities/msg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../common/store/user.dart';
import '../../common/values/colors.dart';
import '../../common/widgets/app.dart';

class MessagePage extends GetView<MessageController> {
  final token = UserStore.to.token;

  MessagePage({super.key});

  AppBar _buildAppBar() {
    return transparentAppBar(
      title: Text(
        'Message',
        style: TextStyle(
            color: AppColors.primaryBackground,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _messageItem(Msg msg) {
    String avatar = (msg.to_avatar == controller.myAvater!)
        ? msg.from_avatar!
        : msg.to_avatar!;
    String name =
        (msg.to_name == controller.myName) ? msg.from_name! : msg.to_name!;
    var passedTime = DateTime.now().difference(msg.last_time!.toDate());
    String displayTime = "";
    () {
      if (passedTime.inDays >= 30) {
        displayTime = "from more than month";
      } else if (passedTime.inDays >= 1) {
        if (passedTime.inDays == 1) {
          displayTime = "1 d ago";
        } else {
          displayTime = "${passedTime.inDays} d ago";
        }
      } else if (passedTime.inHours >= 1) {
        if (passedTime.inHours == 1) {
          displayTime = "1 h ago";
        } else {
          displayTime = "${passedTime.inHours} h ago";
        }
      } else if (passedTime.inMinutes >= 1) {
        if (passedTime.inMinutes == 1) {
          displayTime = "1 m ago";
        } else {
          displayTime = "${passedTime.inMinutes} m ago";
        }
      } else {
        displayTime = "${passedTime.inSeconds} s ago";
      }
    }();
    return Container(
      margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.w, bottom: 0.w),
      child: InkWell(
        onTap: () {
          if (msg.from_uid != null) {
            controller.completeChating(msg);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.amber,
              radius: 32,
              backgroundImage: CachedNetworkImageProvider(avatar),
            ),
            SizedBox(
              width: 10.w,
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 5.w, bottom: 5.w, left: 0.w, right: 0.w),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: AppColors.fourElementText))),
              child: Row(
                children: [
                  SizedBox(
                    width: 200.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.bold,
                              color: AppColors.thirdElement,
                              fontSize: 16.sp),
                        ),
                        Text(
                          msg.last_msg!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.normal,
                              color: AppColors.fourElementText,
                              fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    displayTime,
                    style: TextStyle(
                        fontFamily: "Avenir",
                        fontWeight: FontWeight.normal,
                        color: AppColors.fourElementText,
                        fontSize: 10.sp),
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(
        () => ListView.builder(
          itemBuilder: (context, index) {
            print(
                'chatting users length is ${controller.state.chattingUsers.length}');
            return _messageItem(controller.state.chattingUsers[index]);
          },
          itemCount: controller.state.chattingUsers.length,
        ),
      ),
    );
  }
}
