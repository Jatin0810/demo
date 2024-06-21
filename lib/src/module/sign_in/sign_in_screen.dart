// ignore_for_file: use_build_context_synchronously

import 'package:demo_project/src/config/manager/storage_manager.dart';
import 'package:demo_project/src/config/theme/app_colors.dart';
import 'package:demo_project/src/config/theme/app_text_style.dart';
import 'package:demo_project/src/constants/app_const_assets.dart';
import 'package:demo_project/src/constants/app_storage_key.dart';
import 'package:demo_project/src/module/courses/courses_screen.dart';
import 'package:demo_project/src/module/sign_in/sign_in_model.dart';
import 'package:demo_project/src/module/sign_in/sign_in_presenter.dart';
import 'package:demo_project/src/module/sign_in/sign_in_view.dart';
import 'package:demo_project/src/module/sign_up/sign_up_screen.dart';
import 'package:demo_project/src/widgets/input_text_field.dart';
import 'package:demo_project/src/widgets/primary_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> implements SignInView {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late SignInModel model;
  SignInPresenter presenter = BasicSignInPresenter();

  @override
  void initState() {
    super.initState();
    presenter.signInView = this;
    model.emailController.addListener(presenter.validateForm);
    model.passwordController.addListener(presenter.validateForm);
  }

  @override
  void refreshModel(SignInModel signInModel) {
    if (mounted) {
      setState(() {
        model = signInModel;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    model.emailController.dispose();
    model.passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      topView(),
                      const SizedBox(
                        height: 12,
                      ),
                      emailView(),
                      const SizedBox(
                        height: 12,
                      ),
                      passwordView(),
                      const SizedBox(
                        height: 12,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {},
                          child: Text(
                            'Forget Password?',
                            style: AppTextStyle.regularText14,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      PrimaryButton(
                        text: 'Log In',
                        tColor: model.isValid == true
                            ? AppColors.whiteColor
                            : AppColors.blackColor.withOpacity(0.5),
                        bColor:
                            model.isValid == true ? null : AppColors.greyColor,
                        onTap: model.isValid == false
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  presenter.signIn(context: context);
                                }
                              },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Do not have an account? ',
                        style: AppTextStyle.regularText16.copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Register',
                        style: AppTextStyle.regularText16,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignUpScreen()),
                                (route) => false);
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Divider(),
                const SizedBox(
                  height: 6,
                ),
                googleLogin()
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Version 1.0.0",
              style: AppTextStyle.regularText14
                  .copyWith(color: AppColors.blackColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget googleLogin() {
    return InkWell(
      onTap: () {
        presenter.signInWithGoogle(context: context).then((User? value) {
          if (value != null) {
            StorageManager.setBoolValue(
                key: AppStorageKey.isLogIn, value: true);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const CoursesScreen()),
                (route) => false);
          }
        });
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 48),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: AppColors.blueColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.blueColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(6),
              child: Image.asset(AppAssets.googleLogin),
            ),
            Text(
              "Sign In With Google",
              style: AppTextStyle.mediumText18
                  .copyWith(color: AppColors.whiteColor),
            ),
            const SizedBox()
          ],
        ),
      ),
    );
  }

  Widget topView() {
    return Column(
      children: [
        Center(
          child: Image.asset(
            AppAssets.signIn,
            height: 200,
            width: 200,
          ),
        ),
        Text(
          'Log in',
          style: AppTextStyle.regularText20.copyWith(
            fontFamily: 'poppins',
          ),
        ),
      ],
    );
  }

  Widget emailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: AppTextStyle.regularText16,
        ),
        const SizedBox(
          height: 8,
        ),
        EmailWidget(
          hintText: 'Email',
          controller: model.emailController,
        ),
      ],
    );
  }

  Widget passwordView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: AppTextStyle.regularText16,
        ),
        const SizedBox(
          height: 8,
        ),
        PasswordWidget(
          hintText: 'Password',
          passType: 'Password',
          controller: model.passwordController,
          showsuffixIcon: true,
          
        ),
      ],
    );
  }
}
