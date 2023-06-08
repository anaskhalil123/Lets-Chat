import 'package:cloud_firestore/cloud_firestore.dart';

class Msg {
  final String? from_uid;
  final String? to_uid;
  final String? from_name;
  final String? to_name;
  final String? from_avatar;
  final String? to_avatar;
  final String? last_msg;
  final Timestamp? last_time;
  final int? msg_num;

  Msg({
    this.from_uid,
    this.to_uid,
    this.from_name,
    this.to_name,
    this.from_avatar,
    this.to_avatar,
    this.last_msg,
    this.last_time,
    this.msg_num,
  });

  factory Msg.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Msg(
      from_uid: data?['from_uid'],
      to_uid: data?['to_uid'],
      from_name: data?['from_name'],
      to_name: data?['to_name'],
      from_avatar: data?['from_avatar'],
      to_avatar: data?['to_avatar'],
      last_msg: data?['last_msg'],
      last_time: data?['last_time'],
      msg_num: data?['msg_num'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (from_uid != null) "from_uid": from_uid,
      if (to_uid != null) "to_uid": to_uid,
      if (from_name != null) "from_name": from_name,
      if (to_name != null) "to_name": to_name,
      if (from_avatar != null) "from_avatar": from_avatar,
      if (to_avatar != null) "to_avatar": to_avatar,
      if (last_msg != null) "last_msg": last_msg,
      if (last_time != null) "last_time": last_time,
      if (msg_num != null) "msg_num": msg_num,
    };
  }
}
