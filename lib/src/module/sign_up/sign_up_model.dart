import 'package:flutter/material.dart';

class SignUpModel {
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController confirmController;
  bool isValid;
  SignUpModel({
    required this.emailController,
    required this.isValid,
    required this.passwordController,
    required this.confirmController,
  });
}
