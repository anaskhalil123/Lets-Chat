import 'dart:convert';

import 'package:Lets_Chat/common/entities/entities.dart';
import 'package:Lets_Chat/common/routes/names.dart';
import 'package:Lets_Chat/common/store/store.dart';
import 'package:Lets_Chat/pages/contact/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

class ContactController extends GetxController {
  ContactController();
  final state = ContactState();
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.token;

  @override
  void onReady() {
    super.onReady();
    asyncLoadAllData();
  }

  goChat(UserData toUserdata) async {
    // print('user data ${toUserdata.id}');
    var fromMessages = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: token)
        .where("to_uid", isEqualTo: toUserdata.id)
        .get();

    var toMessages = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: toUserdata.id)
        .where("to_uid", isEqualTo: token)
        .get();

    if (fromMessages.docs.isEmpty && toMessages.docs.isEmpty) {
      // getProfile get userdata as String
      // String profile = await UserStore.to.getProfile();
      // UserLoginResponseEntity userdata =
      //     UserLoginResponseEntity.fromJson(jsonDecode(profile));

      // var msgData = Msg(
      //   from_uid: userdata.accessToken,
      //   from_avatar: userdata.photoUrl,
      //   from_name: userdata.displayName,
      //   to_uid: toUserdata.id,
      //   to_name: toUserdata.name,
      //   to_avatar: toUserdata.photourl,
      //   last_msg: "",
      //   last_time: Timestamp.now(),
      //   msg_num: 0,
      // );

      // db
      //     .collection("message")
      //     .withConverter(
      //       fromFirestore: Msg.fromFirestore,
      //       toFirestore: (Msg msg, options) => msg.toFirestore(),
      //     )
      //     .add(msgData)
      //     .then((value) {
      print(
          'controller: go to chat without have document in message collection');
      Get.toNamed(AppRoutes.Chat, parameters: {
        //these parameters will sent to "/chat",
        //which means its binding(it inject the controller),
        //so the parameters finally will appear in the controller
        // "doc_id": value.id,

        "to_uid": toUserdata.id ?? "",
        "to_name": toUserdata.name ?? "",
        "to_avatar": toUserdata.photourl ?? "",
      });
      // });
    } else {
      if (fromMessages.docs.isNotEmpty) {
        Get.toNamed(AppRoutes.Chat, parameters: {
          "doc_id": fromMessages.docs.first.id,
          "to_uid": toUserdata.id ?? "",
          "to_name": toUserdata.name ?? "",
          "to_avatar": toUserdata.photourl ?? "",
        });
      }

      if (toMessages.docs.isNotEmpty) {
        Get.toNamed(AppRoutes.Chat, parameters: {
          "doc_id": toMessages.docs.first.id,
          "to_uid": toUserdata.id ?? "",
          "to_name": toUserdata.name ?? "",
          "to_avatar": toUserdata.photourl ?? "",
        });
      }
    }
  }

  void asyncLoadAllData() async {
    // get data from firestore
    var usersbase = await db
        .collection("users")
        .where("id", isNotEqualTo: token)
        .withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData userData, options) => userData.toFirestore())
        .get();
    // note that, we git all users expect the user كلهم ما عدا المستخدم
    // بالتالي ما في نظام معين لإضافة لجهات الاتصال بهذا التطبيق

    for (var doc in usersbase.docs) {
      state.contactList.add(doc.data());
      print(doc.toString());
    }
  }
}
