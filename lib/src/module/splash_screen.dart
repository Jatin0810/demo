import 'dart:async';

import 'package:demo_project/src/config/manager/storage_manager.dart';
import 'package:demo_project/src/constants/app_const_assets.dart';
import 'package:demo_project/src/constants/app_storage_key.dart';
import 'package:demo_project/src/module/courses/courses_screen.dart';
import 'package:demo_project/src/module/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      bool? isLogIn = StorageManager.getBoolValue(AppStorageKey.isLogIn);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (_) => isLogIn == null
                  ? const SignInScreen()
                  : isLogIn
                      ? const CoursesScreen()
                      : const SignInScreen()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppAssets.appLogo,
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}
