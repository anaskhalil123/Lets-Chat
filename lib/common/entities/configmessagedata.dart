import 'package:Lets_Chat/common/entities/entities.dart';
import 'package:Lets_Chat/pages/chat/controller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfigMessageData {
  ConfigMessageData(
      [this.messageUid,
      this.messageType,
      this.messageAlignment,
      this.gradient,
      this.gradient1,
      this.messageColor,
      this.time,
      this.hasRepliedMessage]);

  String? messageUid;
  String? messageType;
  Alignment? messageAlignment;
  LinearGradient? gradient;
  Color? gradient1;
  Color? messageColor;
  DateTime? time;
  bool? hasRepliedMessage;

  factory ConfigMessageData.configData(
    QueryDocumentSnapshot<Msgcontent> doc,
    ChatController controller,
  ) {
    String messageUid = doc['uid'];
    String? messageType = doc['type'];
    Alignment messageAlignment = (messageUid == controller.user_id)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    LinearGradient gradient = (messageUid == controller.user_id)
        ? LinearGradient(colors: const [
            Color.fromARGB(255, 166, 112, 231),
            Color.fromARGB(255, 131, 123, 231),
            Color.fromARGB(255, 104, 132, 231),
          ])
        : LinearGradient(colors: const [
            Color.fromARGB(255, 180, 179, 182),
            Color.fromARGB(255, 185, 183, 183),
          ]);

    Color gradient1 = (messageUid == controller.user_id)
        ? Color.fromARGB(255, 197, 169, 232)
        : Color.fromARGB(255, 222, 217, 217);
    Color messageColor =
        (messageUid == controller.user_id) ? Colors.white : Colors.black;
    DateTime time = doc['addtime'].toDate();

    bool? hasReplyeid = (doc['repliedMessage'] == null) ? false : true;

    return ConfigMessageData(messageUid, messageType, messageAlignment,
        gradient, gradient1, messageColor, time, hasReplyeid);
  }
}
