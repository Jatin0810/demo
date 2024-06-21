import 'package:flutter/material.dart';

class SignInModel {
  TextEditingController emailController;
  TextEditingController passwordController;
  bool isValid;
  SignInModel({
    required this.emailController,
    required this.isValid,
    required this.passwordController,
  });
}
