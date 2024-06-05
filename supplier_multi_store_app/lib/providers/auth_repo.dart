// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  static Future<void> signUpWithEmailAndPassword(email, password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> signInWithEmailAndPassword(email, password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> sendEmailVerification() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  static get uid {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<void> updateUserName(storeName) async {
    await FirebaseAuth.instance.currentUser!.updateDisplayName(storeName);
  }

  static Future<void> updateStoreLogo(storeLogo) async {
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(storeLogo);
  }

  static Future<void> reloadUserData() async {
    await FirebaseAuth.instance.currentUser!.reload();
  }

  static Future<bool> checkEmailVerification() async {
    try {
      bool verifiedEmail = FirebaseAuth.instance.currentUser!.emailVerified;
      return verifiedEmail == true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> sendPasswordResetEmail(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<bool> checkOldPassword(email, password) async {
    AuthCredential authCredential =
        EmailAuthProvider.credential(email: email, password: password);
    try {
      var credentialResult = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(authCredential);
      return credentialResult.user != null;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<void> updateUserPassword(newPassword) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    } catch (e) {
      print(e.toString());
    }
  }
}
