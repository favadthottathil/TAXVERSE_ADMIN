import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taxverse_admin/view/sign_in.dart';
// import 'package:taxverse/view/otp_screen.dart';
// import 'package:taxverse/utils/utils.dart';
// import 'package:taxverse/view/sign_option.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _fb;

  FirebaseAuth auth = FirebaseAuth.instance;

  AuthProvider(this._fb);

  bool _isLoading = false;

  Stream<User?> stream() => _fb.authStateChanges();

  bool get loading => _isLoading;

  String? _uid;

  String get uid => _uid!;

  Future<void> logOut(BuildContext context) async {
    await _fb.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignIn(),
        ),
        (route) => false);
  }

  Future<String> signIn(String email, String password) async {
    try {
      log('1');
      _isLoading = true;
      notifyListeners();

      log('2');

      await _fb.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      log('3');

      _isLoading = false;
      notifyListeners();

      log('4');

      return Future.value('');
    } on FirebaseAuthException catch (ex) {
      _isLoading = false;
      notifyListeners();
      log('5');
      return Future.value(ex.message);
    }
  }

  Future<String> signOut(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _fb.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());

      _isLoading = false;
      notifyListeners();

      return Future.value('');
    } on FirebaseAuthException catch (ex) {
      _isLoading = false;
      notifyListeners();
      return Future.value(ex.message);
    }
  }

  Future<String> resetPassword(String email) async {
    // await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    try {
      _isLoading = true;
      notifyListeners();

      await _fb.sendPasswordResetEmail(email: email.trim());

      _isLoading = false;
      notifyListeners();

      return Future.value('');
    } on FirebaseAuthException catch (ex) {
      _isLoading = false;
      notifyListeners();
      log('${ex.message} favad');
      return Future.value(ex.message);
    }
  }
}
