import 'package:demo_project/src/config/theme/app_colors.dart';
import 'package:demo_project/src/config/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final Function()? onTap;
  final Color? tColor, bColor;
  final TextStyle? textStyle;
  final double? height, width, borderRadius;

  const PrimaryButton({
    super.key,
    required this.text,
    this.tColor,
    this.bColor,
    this.height,
    this.width,
    this.textStyle,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: height ?? 50,
        width: width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: bColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
        child: Text(
          text!,
          style: textStyle ??
              AppTextStyle.mediumText16.copyWith(
                fontFamily: 'poppins',
                color: tColor,
              ),
        ),
      ),
    );
  }
}
