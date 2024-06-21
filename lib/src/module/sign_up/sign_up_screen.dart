// ignore_for_file: use_build_context_synchronously

import 'package:demo_project/src/config/theme/app_colors.dart';
import 'package:demo_project/src/config/theme/app_text_style.dart';
import 'package:demo_project/src/constants/app_const_assets.dart';
import 'package:demo_project/src/module/sign_in/sign_in_screen.dart';
import 'package:demo_project/src/module/sign_up/sign_up_model.dart';
import 'package:demo_project/src/module/sign_up/sign_up_presenter.dart';
import 'package:demo_project/src/module/sign_up/sign_up_view.dart';
import 'package:demo_project/src/utils/validator.dart';
import 'package:demo_project/src/widgets/input_text_field.dart';
import 'package:demo_project/src/widgets/primary_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> implements SignUpView {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late SignUpModel model;
  SignInPresenter presenter = BasicSignInPresenter();

  @override
  void initState() {
    super.initState();
    presenter.signUpView = this;

    model.emailController.addListener(presenter.validateForm);
    model.passwordController.addListener(presenter.validateForm);
  }

  @override
  void refreshModel(SignUpModel signUpModel) {
    if (mounted) {
      setState(() {
        model = signUpModel;
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
                      confirmPasswordView(),
                      const SizedBox(
                        height: 18,
                      ),
                      PrimaryButton(
                        text: 'Register',
                        tColor: model.isValid == true
                            ? AppColors.whiteColor
                            : AppColors.blackColor.withOpacity(0.5),
                        bColor:
                            model.isValid == true ? null : AppColors.greyColor,
                        onTap: model.isValid == false
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  presenter.register(context: context);
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
                        text: 'Sign in',
                        style: AppTextStyle.regularText16,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignInScreen()),
                                (route) => false);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
          'Register',
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

  Widget confirmPasswordView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirm Password',
          style: AppTextStyle.regularText16,
        ),
        const SizedBox(
          height: 8,
        ),
        PasswordWidget(
          hintText: 'Confirm Password',
          passType: 'Confirm Password',
          controller: model.confirmController,
          validator: (value) {
            return Validators.validatePassword(
                    value!.trim(), 'Confirm Password') ??
                (model.passwordController.text == model.confirmController.text
                    ? null
                    : 'Password and confirm password are should be match');
          },
          showsuffixIcon: true,
        ),
      ],
    );
  }
}
