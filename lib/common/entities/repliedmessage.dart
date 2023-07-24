import 'package:cloud_firestore/cloud_firestore.dart';

class RepliedMsgContent {
  final String? uid;
  final String? content;
  final bool? hasPhoto;
  final int? msgIndex;

  RepliedMsgContent({
    this.uid,
    this.content,
    this.hasPhoto,
    this.msgIndex,
  });

  factory RepliedMsgContent.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return RepliedMsgContent(
      uid: data?['uid'],
      content: data?['content'],
      hasPhoto: data?['hasPhoto'],
      msgIndex: data?['msgIndex'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (content != null) "content": content,
      if (hasPhoto != null) "hasPhoto": hasPhoto,
      if (msgIndex != null) "msgIndex": msgIndex,
    };
  }
}
