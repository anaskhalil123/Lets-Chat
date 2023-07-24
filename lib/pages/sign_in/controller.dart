import 'package:Lets_Chat/common/entities/entities.dart';
import 'package:Lets_Chat/common/routes/names.dart';
import 'package:Lets_Chat/common/widgets/toast.dart';
import 'package:Lets_Chat/pages/sign_in/state.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../common/store/user.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['openid']);

class SignInController extends GetxController {
  final state = SignInState();
  final db = FirebaseFirestore.instance;
  SignInController();

  Future<void> handleGoogleSignIn() async {
    try {
      var user = await _googleSignIn.signIn();
      if (user != null) {
        //save the user in FirebaseAuth
        final gAuthentication = await user.authentication;
        final gCredential = GoogleAuthProvider.credential(
          idToken: gAuthentication.idToken,
          accessToken: gAuthentication.accessToken,
        );
        await FirebaseAuth.instance.signInWithCredential(gCredential);

        String name = user.displayName ?? user.email;
        String email = user.email;
        String id = user.id;
        String photoUrl = user.photoUrl ?? '';

        //save data in user object
        UserLoginResponseEntity userProfile = UserLoginResponseEntity();
        userProfile.accessToken = id;
        userProfile.email = email;
        userProfile.displayName = name;
        userProfile.photoUrl = photoUrl;

        //save object in the device(GetX local store).
        UserStore.to.saveProfile(userProfile);

        //save data in firestore
        //1- check if data saved in firestore before
        var userbase = await db
            .collection("users")
            .withConverter(
                fromFirestore: UserData.fromFirestore,
                toFirestore: (UserData userData, options) =>
                    userData.toFirestore())
            .where("id", isEqualTo: id)
            .get();
        //2- if not exist, submit the data to firestore
        //after save it in UserData object.
        if (userbase.docs.isEmpty) {
          final data = UserData(
              id: id,
              name: name,
              email: email,
              photourl: photoUrl,
              fcmtoken: "",
              location: "",
              addtime: Timestamp.now());
          await db
              .collection("users")
              .withConverter(
                  fromFirestore: UserData.fromFirestore,
                  toFirestore: (UserData userData, options) =>
                      userData.toFirestore())
              .add(data);
        }
        toastInfo(msg: "Login success");
        Get.offAndToNamed(AppRoutes.Application);
      }
    } catch (e) {
      toastInfo(msg: "Login error");
      print('error in google signin due to ${e.toString()}');
    }
  }

  @override
  void onReady() {
    super.onReady();
    //authStateChanges check if user signin or signout
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("user now is logged out");
      } else {
        print("user now is login");
      }
    });
  }
}
