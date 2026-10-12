import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class AuthentificationService {
  static const String USER_NOT_FOUND_EXCEPTION_CODE = "user-not-found";
  static const String WRONG_PASSWORD_EXCEPTION_CODE = "wrong-password";
  static const String EMAIL_ALREADY_IN_USE_EXCEPTION_CODE =
      "email-already-in-use";
  static const String OPERATION_NOT_ALLOWED_EXCEPTION_CODE =
      "operation-not-allowed";
  static const String WEAK_PASSWORD_EXCEPTION_CODE = "weak-password";
  static const String USER_MISMATCH_EXCEPTION_CODE = "user-mismatch";
  static const String INVALID_CREDENTIALS_EXCEPTION_CODE = "invalid-credential";
  static const String INVALID_EMAIL_EXCEPTION_CODE = "invalid-email";
  static const String USER_DISABLED_EXCEPTION_CODE = "user-disabled";
  static const String INVALID_VERIFICATION_CODE_EXCEPTION_CODE =
      "invalid-verification-code";
  static const String INVALID_VERIFICATION_ID_EXCEPTION_CODE =
      "invalid-verification-id";
  static const String REQUIRES_RECENT_LOGIN_EXCEPTION_CODE =
      "requires-recent-login";

  FirebaseAuth? _firebaseAuth;

  AuthentificationService._privateConstructor();

  static AuthentificationService _instance =
  AuthentificationService._privateConstructor();

  FirebaseAuth get firebaseAuth {
    if (_firebaseAuth == null) {
      _firebaseAuth = FirebaseAuth.instance;
    }
    return _firebaseAuth!;
  }

  Stream<User?> get userChanges => firebaseAuth.userChanges();

  factory AuthentificationService() {
    return _instance;
  }
  User get currentUser {
    return firebaseAuth.currentUser!;
  }
  Future<void> updateCurrentUserDisplayName(String updatedDisplayName) async {
    await currentUser.updateDisplayName(updatedDisplayName);
  }

  Future<void> updateCurrentUserEmail(String email ) async {
    await currentUser.updateEmail(email);
  }
  Future<void> updateCurrentUserPassword(String Password) async {
    await currentUser.updatePassword(Password);
  }
  Future<void> updateCurrentUserPhone(String Phone) async {
    await currentUser.updatePhoneNumber(Phone as PhoneAuthCredential);
  }

  Future<void> resetPasswordForEmail(String email) async {
    firebaseAuth.sendPasswordResetEmail(email: email);
    showToast(
      "تم ارسال كود استعادة الباسورد الي حسابك",
      borderRadius: BorderRadius.circular(5),
      animation: StyledToastAnimation.scale,
      reverseAnimation: StyledToastAnimation.fade,
      animDuration: Duration(milliseconds: 250),
    );
  }

  Future<bool> changePasswordForCurrentUser(
      { String? oldPassword,  required String newPassword}) async {
      bool isOldPasswordProvidedCorrect = true;
      if (oldPassword != "") {
        isOldPasswordProvidedCorrect =
        await verifyCurrentUserPassword(oldPassword!);
      }
      if (isOldPasswordProvidedCorrect) {
        await firebaseAuth.currentUser!.updatePassword(newPassword);

        return true;
      } else {
        throw "Please Enter your data right";
      }
  }

  Future<bool> changeEmailForCurrentUser(
      { String? password, required String newEmail}) async {
      bool isPasswordProvidedCorrect = true;
      if (password != "") {
        isPasswordProvidedCorrect = await verifyCurrentUserPassword(password!);
      }
      if (isPasswordProvidedCorrect) {
        await currentUser.updateEmail(newEmail);

        return true;
      } else {
        throw "Please Check your data again";
      }

  }

  Future<bool> verifyCurrentUserPassword(String password) async {
      final AuthCredential authCredential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: password,
      );

      final authCredentials =
      await currentUser.reauthenticateWithCredential(authCredential);
      return authCredentials != null;
  }

}