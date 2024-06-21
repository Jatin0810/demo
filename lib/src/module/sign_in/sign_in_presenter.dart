import 'package:demo_project/src/config/manager/storage_manager.dart';
import 'package:demo_project/src/constants/app_storage_key.dart';
import 'package:demo_project/src/module/courses/courses_screen.dart';
import 'package:demo_project/src/module/sign_in/sign_in_model.dart';
import 'package:demo_project/src/module/sign_in/sign_in_view.dart';
import 'package:demo_project/src/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInPresenter {
  Future<void> signIn({required BuildContext context}) async {}
  Future<User?> signInWithGoogle({required BuildContext context}) async {}
  Future<void> validateForm() async {}

  set signInView(SignInView value) {}
}

class BasicSignInPresenter implements SignInPresenter {
  late SignInModel model;
  late SignInView view;

  BasicSignInPresenter() {
    view = SignInView();
    model = SignInModel(
        isValid: false,
        emailController: TextEditingController(),
        passwordController: TextEditingController());
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<void> signIn({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: model.emailController.text.trim(),
        password: model.passwordController.text.trim(),
      );

      StorageManager.setBoolValue(key: AppStorageKey.isLogIn, value: true);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const CoursesScreen()),
          (route) => false);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(error.message ?? ''),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(e.toString()),
      ));
    }
  }

  @override
  Future<User?> signInWithGoogle({required BuildContext context}) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(e.toString()),
      ));
      return null;
    }
  }

  @override
  Future<void> validateForm() async {
    final email = model.emailController.text;
    final password = model.passwordController.text;
    model.isValid = _validateEmail(email) && _validatePassword(password);
    view.refreshModel(model);
  }

  bool _validateEmail(String email) {
    String? val = Validators.validateEmail(email);
    return val == null ? true : false;
  }

  bool _validatePassword(String password) {
    String? val = Validators.validatePassword(password, "Password");
    return val == null ? true : false;
  }

  @override
  set signInView(SignInView value) {
    view = value;
    view.refreshModel(model);
  }
}
