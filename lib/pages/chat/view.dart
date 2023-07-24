import 'package:Lets_Chat/common/entities/repliedmessage.dart';
import 'package:Lets_Chat/common/values/colors.dart';
import 'package:Lets_Chat/pages/chat/controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:intl/intl.dart';

import '../../common/entities/configmessagedata.dart';

/*
informations:
1- scrollview above column.
2- not use resize attribute.
3- (specific for the keyboard) it should be in statefulWidget.
4- not to used Expanded inside the column.
*/

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

  Row _sendMessagesWidget(
      BuildContext context, ScrollController scrollController) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              (controller.state.isReplaying.value)
                  ? Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  controller.state.to_name.value,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                child: Icon(Icons.close, size: 14.w),
                                onTap: () {
                                  controller.unSwipedMessage();
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 8.w),
                          Text(
                            controller.repliedMsgContent!.content!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 0.w,
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 10.w,
                ),
                child: (controller.doc_id.isNotEmpty)
                    ? StreamBuilder(
                        stream: controller.getPerviousMessages(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var list = ListView.builder(
                              controller: scrollController,
                              physics: BouncingScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (ctx, index) {
                                ConfigMessageData configDatas =
                                    ConfigMessageData.configData(
                                  snapshot.data!.docs[index],
                                  controller,
                                );
                                String hours =
                                    DateFormat('hh').format(configDatas.time!);
                                String minutes =
                                    DateFormat('mm').format(configDatas.time!);
                                String amPm =
                                    DateFormat('a').format(configDatas.time!);
                                return SwipeTo(
                                  onRightSwipe: () {
                                    controller.swipedMessage(RepliedMsgContent(
                                        uid: configDatas.messageUid,
                                        content: snapshot.data!.docs[index]
                                            ['content'],
                                        hasPhoto:
                                            configDatas.messageType == 'image'
                                                ? true
                                                : false,
                                        msgIndex: index));
                                    print('swiped');
                                  },
                                  child: Align(
                                    alignment: configDatas.messageAlignment!,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right: 5.w,
                                          left: 5.w,
                                          top: 2.w,
                                          bottom: 2.w),
                                      padding: EdgeInsets.only(
                                          right: 5.w,
                                          left: 5.w,
                                          top: 5.w,
                                          bottom: 5.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: configDatas.gradient,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          if (configDatas.hasRepliedMessage!)
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                color: configDatas.gradient1,
                                                padding: EdgeInsets.only(
                                                    left: 5.w, right: 5.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // TODO:
                                                    Text(
                                                      (snapshot.data!.docs[
                                                                          index]
                                                                      [
                                                                      'repliedMessage']
                                                                  ['uid'] ==
                                                              controller
                                                                  .user_id)
                                                          ? 'You'
                                                          : controller.state
                                                              .to_name.value,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!.docs[index]
                                                              ['repliedMessage']
                                                          ['content'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          (configDatas.messageType == "image")
                                              ? FadeInImage(
                                                  placeholder: AssetImage(
                                                      'assets/images/placeholder_image.png'),
                                                  image: NetworkImage(snapshot
                                                      .data!
                                                      .docs[index]['imageUrl']),
                                                  height: 300,
                                                  width: 200,
                                                  fit: BoxFit.fill,
                                                )
                                              : SizedBox(
                                                  height: 0.h,
                                                ),
                                          Text(
                                            snapshot.data!.docs[index]
                                                ['content'],
                                            style: TextStyle(
                                                color: configDatas.messageColor,
                                                fontSize: 13.sp),
                                          ),
                                          SizedBox(
                                            height: 2.5.h,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              (configDatas.messageType ==
                                                      "image")
                                                  ? SizedBox(width: 200)
                                                  : Text(
                                                      "${snapshot.data!.docs[index]['content']}",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 8.sp,
                                                          color: Colors
                                                              .transparent),
                                                    ),
                                              Text(
                                                '$hours:$minutes $amPm',
                                                style:
                                                    TextStyle(fontSize: 8.sp),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                            goToLastMessage(scrollController, 100);
                            return list;
                          } else {
                            return Container();
                          }
                        },
                      )
                    : Container(),
              ),
            ),
            Obx(
              () => _sendMessagesWidget(context, scrollController),
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
