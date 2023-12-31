import 'package:Lets_Chat/common/entities/repliedmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Msgcontent {
  final String? uid;
  final String? content;
  final String? type;
  final String? imageUrl;
  final Timestamp? addtime;
  final RepliedMsgContent? repliedMessage;

  Msgcontent({
    this.uid,
    this.content,
    this.type,
    this.imageUrl,
    this.addtime,
    this.repliedMessage,
  });

  factory Msgcontent.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Msgcontent(
      uid: data?['uid'],
      content: data?['content'],
      type: data?['type'],
      imageUrl: data?['imageUrl'],
      addtime: data?['addtime'],
      repliedMessage: (data?['repliedMessage'] == null)
          ? null
          : RepliedMsgContent.fromFirestore(data?['repliedMessage'], options),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (content != null) "content": content,
      if (type != null) "type": type else "type": null,
      if (imageUrl != null) "imageUrl": imageUrl else "imageUrl": null,
      if (addtime != null) "addtime": addtime,
      if (repliedMessage != null)
        "repliedMessage": repliedMessage!.toFirestore()
      else
        'repliedMessage': null,
    };
  }
}
