import 'package:Lets_Chat/common/entities/entities.dart';
import 'package:Lets_Chat/pages/message/state.dart';
import 'package:Lets_Chat/pages/profile/state.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

import '../../common/routes/routes.dart';
import '../../common/store/user.dart';

class ProfileController extends GetxController {
  ProfileController();
  final state = ProfileState();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void onReady() async {
    super.onReady();
    // getProfile get userdata as String
    String profile = await UserStore.to.getProfile();
    UserLoginResponseEntity userdata =
        UserLoginResponseEntity.fromJson(jsonDecode(profile));

    state.name.value = userdata.displayName!;
    state.uid.value = userdata.accessToken!;
    state.userAvatar.value = userdata.photoUrl!;

    print(
        'user data is name ${state.name.value}\nuid ${state.uid.value}\nuser Avatar ${state.userAvatar.value}');
  }

  Future<void> logOut() async {
    UserStore.to.onLogout();
    await _googleSignIn.signOut();
    Get.offAndToNamed(AppRoutes.SIGN_IN);
  }
}
