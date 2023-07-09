import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chating/common/values/colors.dart';
import 'package:firebase_chating/pages/chat/controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../common/entities/msgcontent.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: const [
          Color.fromARGB(255, 176, 106, 231),
          Color.fromARGB(255, 166, 112, 231),
          Color.fromARGB(255, 131, 123, 231),
          Color.fromARGB(255, 104, 132, 231),
        ], transform: GradientRotation(90))),
      ),
      title: Container(
        padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
              child: InkWell(
                onTap: () {},
                child: SizedBox(
                  width: 44.w,
                  height: 44.w,
                  child: CachedNetworkImage(
                    imageUrl: controller.state.to_avatar.value,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 44.w,
                      height: 44.w,
                      margin: null,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(44.w)),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                    errorWidget: (context, url, error) => Image(
                      image: AssetImage('assets/images/feature-1.png'),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
            Container(
              width: 180.w,
              padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 180.w,
                    height: 54.w,
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            controller.state.to_name.value,
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: 'Avenir',
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBackground,
                                fontSize: 16.sp),
                          ),
                          Text(
                            controller.state.to_location.value,
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            style: TextStyle(
                              fontFamily: 'Avenir',
                              fontWeight: FontWeight.normal,
                              color: AppColors.primaryBackground,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

/*ConstrainedBox(
        constraints: BoxConstraints.expand(), */

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: controller.getPerviousMessages(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    goToLastMessage(scrollController, 100);
                    var list = ListView.builder(
                      controller: scrollController,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        String messageUid = snapshot.data!.docs[index]['uid'];
                        String? messageType =
                            snapshot.data!.docs[index]['type'];
                        Alignment messageAlignment =
                            (messageUid == controller.user_id)
                                ? Alignment.centerRight
                                : Alignment.centerLeft;
                        LinearGradient gradient =
                            (messageUid == controller.user_id)
                                ? LinearGradient(colors: const [
                                    Color.fromARGB(255, 166, 112, 231),
                                    Color.fromARGB(255, 131, 123, 231),
                                    Color.fromARGB(255, 104, 132, 231),
                                  ])
                                : LinearGradient(colors: const [
                                    Color.fromARGB(255, 180, 179, 182),
                                    Color.fromARGB(255, 185, 183, 183),
                                  ]);
                        Color messageColor = (messageUid == controller.user_id)
                            ? Colors.white
                            : Colors.black;
                        DateTime time =
                            snapshot.data!.docs[index]['addtime'].toDate();
                        String hours = DateFormat('hh').format(time);
                        String minutes = DateFormat('mm').format(time);
                        String amPm = DateFormat('a').format(time);
                        return Align(
                          alignment: messageAlignment,
                          child: Container(
                            margin: EdgeInsets.only(
                                right: 5.w, left: 5.w, top: 2.w, bottom: 2.w),
                            padding: EdgeInsets.only(
                                right: 5.w, left: 5.w, top: 5.w, bottom: 5.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: gradient,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                (messageType == "image")
                                    ? FadeInImage(
                                        placeholder: AssetImage(
                                            'assets/images/placeholder_image.png'),
                                        image: NetworkImage(snapshot
                                            .data!.docs[index]['imageUrl']),
                                        height: 300,
                                        width: 200,
                                        fit: BoxFit.fill,
                                      )
                                    : SizedBox(
                                        height: 0.h,
                                      ),
                                Text(
                                  snapshot.data!.docs[index]['content'],
                                  style: TextStyle(
                                      color: messageColor, fontSize: 13.sp),
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    (messageType == "image")
                                        ? SizedBox(width: 200)
                                        : Text(
                                            "${snapshot.data!.docs[index]['content']}",
                                            style: TextStyle(
                                                fontSize: 17.sp,
                                                color: Colors.transparent),
                                          ),
                                    Text(
                                      '$hours:$minutes $amPm',
                                      style: TextStyle(fontSize: 8.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    return list;
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              width: 360.w,
              height: 50.w,
              color: AppColors.primaryBackground,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 217.w,
                    height: 50.h,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: controller.contentNode,
                      autofocus: false,
                      controller: controller.textController,
                      decoration:
                          InputDecoration(hintText: ' Send messages...'),
                    ),
                  ),
                  Container(
                    width: 30.w,
                    height: 30.h,
                    margin: EdgeInsets.only(left: 5.w),
                    child: GestureDetector(
                      child: Icon(
                        Icons.photo_outlined,
                        size: 35.w,
                        color: Colors.blue,
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.camera),
                                  title: Text('Camera'),
                                  onTap: () async {
                                    controller.pickImage(
                                        ImageSource.camera, context);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.photo_library),
                                  title: Text('Gallery'),
                                  onTap: () async {
                                    controller.pickImage(
                                        ImageSource.gallery, context);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    width: 65.w,
                    height: 35.h,
                    margin: EdgeInsets.only(left: 10.w, top: 5.h),
                    child: ElevatedButton(
                      child: Text("Send"),
                      onPressed: () async {
                        print('send:  onPressed method');
                        if (controller.imageFile == null) {
                          controller.sendMessage();
                        } else {
                          print('send: send message with image');
                          controller.sendMessageWithImage(context);
                        }
                        // scroll to last message
                        await goToLastMessage(scrollController, 300);
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> goToLastMessage(
      ScrollController scrollController, int timeInMilliSeconds) async {
    // scroll to last message
    await Future.delayed(Duration(milliseconds: timeInMilliSeconds));
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }
}
