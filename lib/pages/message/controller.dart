import 'package:Lets_Chat/common/entities/entities.dart';
import 'package:Lets_Chat/pages/message/state.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:get/get.dart';

import '../../common/routes/names.dart';
import '../../common/store/user.dart';

class MessageController extends GetxController {
  final state = MessageState();
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.token;
  String? myAvater;
  String? myName;
  @override
  void onReady() async {
    super.onReady();
    String profile = await UserStore.to.getProfile();
    UserLoginResponseEntity userdata =
        UserLoginResponseEntity.fromJson(jsonDecode(profile));
    myAvater = userdata.photoUrl;
    myName = userdata.displayName;
    getChattingUsers();
  }

  void completeChating(Msg msg) async {
    String userId = (msg.from_uid == token) ? msg.to_uid! : msg.from_uid!;
    String? chattingUserAvatar;
    var fromMessage = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: token)
        .where("to_uid", isEqualTo: userId)
        .get();

    var toMessage = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: userId)
        .where("to_uid", isEqualTo: token)
        .get();

    if (fromMessage.docs.isNotEmpty) {
      chattingUserAvatar = msg.to_avatar;
      Get.toNamed(AppRoutes.Chat, parameters: {
        "doc_id": fromMessage.docs.first.id,
        "to_uid": msg.to_uid ?? "",
        "to_name": msg.to_name ?? "",
        "to_avatar": chattingUserAvatar ?? "",
      });
    }

    if (toMessage.docs.isNotEmpty) {
      chattingUserAvatar = msg.from_avatar;
      Get.toNamed(AppRoutes.Chat, parameters: {
        "doc_id": toMessage.docs.first.id,
        "to_uid": msg.from_uid ?? "",
        "to_name": msg.from_name ?? "",
        "to_avatar": chattingUserAvatar ?? "",
      });
    }
  }

  void getChattingUsers() async {
    List<Msg> combinedUsers = <Msg>[];

    var fromUsers = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: token)
        .orderBy("last_time", descending: true)
        .get()
        // add formUsers to the combinedUsers list
        .then((QuerySnapshot<Msg> querySnapshot) {
      for (var doc in querySnapshot.docs) {
        combinedUsers.add(doc.data());
      }
    });

    var toUsers = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("to_uid", isEqualTo: token)
        .orderBy("last_time", descending: true)
        .get()
        // add toUsers to the combinedUsers list
        .then((QuerySnapshot<Msg> querySnapshot) {
      for (var doc in querySnapshot.docs) {
        combinedUsers.add(doc.data());
      }
    });
    print('combinedUsers: ${combinedUsers.length}');
    combinedUsers.sort((a, b) => b.last_time!.compareTo(a.last_time!));

    print('combinedUsers after the sort operation. ==> $combinedUsers');
    state.chattingUsers.value = combinedUsers;
  }
}
