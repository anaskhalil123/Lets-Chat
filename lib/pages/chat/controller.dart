import 'dart:io';
import 'dart:convert';
import 'package:Lets_Chat/common/entities/entities.dart';
import 'package:Lets_Chat/common/store/store.dart';
import 'package:Lets_Chat/pages/chat/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatController extends GetxController {
  ChatController();
  final state = ChatState();
  String doc_id = '';
  File? imageFile;
  final textController = TextEditingController();
  ScrollController msgScrolling = ScrollController();
  FocusNode contentNode = FocusNode();
  final user_id = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  RepliedMsgContent? repliedMsgContent;

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    doc_id = data['doc_id'] ?? '';
    state.to_uid.value = data['to_uid'] ?? "";
    state.to_avatar.value = data['to_avatar'] ?? "";
    state.to_name.value = data['to_name'] ?? "";
    state.to_location.value = data['to_location'] ?? "UnKown Location";
  }

  sendMessage() async {
    String sendContent = textController.text;
    final Msgcontent content;
    if (state.isReplaying.value) {
      content = Msgcontent(
        uid: user_id,
        content: sendContent,
        repliedMessage: repliedMsgContent,
        addtime: Timestamp.now(),
      );
    } else {
      content = Msgcontent(
        uid: user_id,
        content: sendContent,
        addtime: Timestamp.now(),
      );
    }

    if (doc_id.isEmpty) {
      // getProfile get userdata as String
      String profile = await UserStore.to.getProfile();
      UserLoginResponseEntity userdata =
          UserLoginResponseEntity.fromJson(jsonDecode(profile));

      var msgData = Msg(
        from_uid: userdata.accessToken,
        from_avatar: userdata.photoUrl,
        from_name: userdata.displayName,
        to_uid: state.to_uid.value,
        to_name: state.to_name.value,
        to_avatar: state.to_avatar.value,
        last_msg: "",
        last_time: Timestamp.now(),
        msg_num: 0,
      );

      await db
          .collection("message")
          .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore(),
          )
          .add(msgData)
          .then((value) {
        doc_id = value.id;
      });
      uploadMessage(doc_id, content, sendContent);
    } else {
      uploadMessage(doc_id, content, sendContent);
    }
  }

  uploadMessage(String docId, Msgcontent content, String sendContent) async {
    await db
        .collection("message")
        .doc(docId)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msg, options) => msg.toFirestore())
        .add(content)
        .then((value) {
      print(value.id);
      textController.clear();
      if (state.isReplaying.value) unSwipedMessage();
      Get.focusScope?.unfocus();
    });

    await db.collection("message").doc(docId).update({
      "last_msg": sendContent,
      "last_time": Timestamp.now(),
    });
  }

  Stream<QuerySnapshot<Msgcontent>> getPerviousMessages() {
    return db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .orderBy("addtime", descending: false)
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (snapshot, options) => snapshot.toFirestore(),
        )
        .snapshots();
  }

  Future<void> pickImage(ImageSource source, BuildContext context) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    print('pickImage method');
    if (pickedImage != null) {
      imageFile = File(pickedImage.path);
      print('finish pickImage method');
    } else {
      printError(info: 'File not picked!');
    }
  }

  Future<String> uploadImage(File pickedFile) async {
    //get file name, basename function from path library
    final fileName = basename(pickedFile.path);

    //make the storage refrence
    var uploadTask =
        await storage.ref().child("uploads/$fileName").putFile(pickedFile);

    //get download Url
    return await uploadTask.ref.getDownloadURL();
  }

  void sendMessageWithImage(BuildContext context) async {
    print('send: Enter the method');
    String sendContent = textController.text;
    final Msgcontent content;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger
        .showSnackBar(SnackBar(content: Text('uploading the image')));
    print('send: Begin the snackBar');

    //upload the image
    String pickedImageUrl = await uploadImage(imageFile!);

    print('send: finish the uploading');

    if (state.isReplaying.value) {
      content = Msgcontent(
        uid: user_id,
        content: sendContent,
        type: 'image',
        imageUrl: pickedImageUrl,
        repliedMessage: repliedMsgContent,
        addtime: Timestamp.now(),
      );
    } else {
      content = Msgcontent(
        uid: user_id,
        content: sendContent,
        type: 'image',
        imageUrl: pickedImageUrl,
        addtime: Timestamp.now(),
      );
    }

    await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msg, options) => msg.toFirestore())
        .add(content)
        .then((value) {
      print(value.id);
      textController.clear();
      if (state.isReplaying.value) unSwipedMessage();
      Get.focusScope?.unfocus();
    });

    await db.collection("message").doc(doc_id).update({
      //#TODO returened here, قد تكون تأتي بقيمة نل، وليست إمبتي
      "last_msg": (sendContent.isEmpty) ? "PHOTO" : sendContent,
      "last_time": Timestamp.now(),
    });
    print('send: finish the storing in firebase');
    imageFile = null;
  }

  void swipedMessage(RepliedMsgContent repliedMsgContent) {
    contentNode.requestFocus();
    state.isReplaying.value = true;
    this.repliedMsgContent = repliedMsgContent;
  }

  void unSwipedMessage() {
    state.isReplaying.value = false;
    repliedMsgContent = null;
  }
}
