import 'package:demo_project/src/config/manager/storage_manager.dart';
import 'package:demo_project/src/constants/app_storage_key.dart';
import 'package:demo_project/src/module/courses/courses_screen.dart';
import 'package:demo_project/src/module/sign_up/sign_up_model.dart';
import 'package:demo_project/src/module/sign_up/sign_up_view.dart';
import 'package:demo_project/src/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInPresenter {
  Future<void> register({required BuildContext context}) async {}
  Future<void> validateForm() async {}
  set signUpView(SignUpView value) {}
}

class BasicSignInPresenter implements SignInPresenter {
  late SignUpModel model;
  late SignUpView view;

  BasicSignInPresenter() {
    view = SignUpView();
    model = SignUpModel(
        isValid: false,
        confirmController: TextEditingController(),
        emailController: TextEditingController(),
        passwordController: TextEditingController());
  }

  @override
  Future<void> register({required BuildContext context}) async {
    try {
      UserCredential details =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: model.emailController.text.trim(),
        password: model.passwordController.text.trim(),
      );
      if (details.user != null) {
        StorageManager.setBoolValue(key: AppStorageKey.isLogIn, value: true);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const CoursesScreen()),
            (route) => false);
      }
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
  Future<void> validateForm() async {
    final email = model.emailController.text;
    final password = model.passwordController.text;
    final confirmPassword = model.confirmController.text;
    model.isValid = _validateEmail(email) &&
        _validatePassword(password) &&
        _validateConfirmPassword(confirmPassword);
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

  bool _validateConfirmPassword(String password) {
    String? val = Validators.validatePassword(password, "Password");
    return val == null ? true : false;
  }

  @override
  set signUpView(SignUpView value) {
    view = value;
    view.refreshModel(model);
  }
}
