import 'package:demo_project/src/config/theme/app_colors.dart';
import 'package:demo_project/src/config/theme/app_text_style.dart';
import 'package:demo_project/src/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextFormField textFormField({
  final Key? fieldKey,
  final String? hintText,
  final String? labelText,
  final String? helperText,
  final String? initialValue,
  final int? errorMaxLines,
  final int? maxLines,
  final int? maxLength,
  final bool? enabled,
  final bool? readOnly,
  final bool autofocus = false,
  final bool? obscureText,
  final Color? filledColor,
  final Color? cursorColor,
  final Widget? prefixIcon,
  final Widget? suffixIcon,
  final FocusNode? focusNode,
  final TextStyle? style,
  final TextStyle? hintStyle,
  final TextAlign textAlign = TextAlign.left,
  final TextEditingController? controller,
  final List<TextInputFormatter>? inputFormatters,
  final TextInputAction? textInputAction,
  final TextInputType? keyboardType,
  final TextCapitalization textCapitalization = TextCapitalization.none,
  final GestureTapCallback? onTap,
  final FormFieldSetter<String?>? onSaved,
  final FormFieldValidator<String?>? validator,
  final ValueChanged<String?>? onChanged,
  final ValueChanged<String?>? onFieldSubmitted,
  final BorderSide? focusBorder,
  final BorderSide? enabledBorder,
  final BorderSide? border,
  final String? prefixText,
  final BoxConstraints? prefixIconConstraints,
  final EdgeInsetsGeometry? contentPadding,
}) {
  return TextFormField(
    key: fieldKey,
    controller: controller,
    focusNode: focusNode,
    maxLines: maxLines ?? 1,
    initialValue: initialValue,
    keyboardType: keyboardType,
    textCapitalization: textCapitalization,
    obscureText: obscureText ?? false,
    enabled: enabled,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    enableInteractiveSelection: enabled,
    validator: validator,
    maxLength: maxLength,
    textInputAction: textInputAction,
    inputFormatters: inputFormatters,
    onTap: onTap,
    onSaved: onSaved,
    onChanged: onChanged,
    onFieldSubmitted: onFieldSubmitted,
    autocorrect: true,
    autofocus: autofocus,
    textAlign: textAlign,
    cursorColor: cursorColor ?? AppColors.blackColor,
    cursorHeight: 24,
    style: style,
    readOnly: readOnly ?? false,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      contentPadding:
          contentPadding ?? const EdgeInsets.symmetric(horizontal: 10),
      // border: const UnderlineInputBorder(),
      // enabledBorder: const UnderlineInputBorder(),
      // disabledBorder: const UnderlineInputBorder(),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: enabledBorder ??
            const BorderSide(
              color: Colors.transparent,
            ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: enabledBorder ??
            const BorderSide(
              color: Colors.transparent,
            ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: enabledBorder ??
            const BorderSide(
              color: Colors.transparent,
            ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: focusBorder ??
            const BorderSide(
              color: Colors.transparent,
            ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: AppColors.errorColor,
        ),
      ),
      prefixText: prefixText,
      errorMaxLines: 5,
      fillColor: filledColor ?? AppColors.secondary,
      filled: true,
      hintStyle: hintStyle,
      hintText: hintText,
      counterText: "",
      suffixIcon: suffixIcon,
      labelText: labelText,
      labelStyle: AppTextStyle.lightText18,
      helperText: helperText,
      // floatingLabelBehavior: FloatingLabelBehavior.always,
    ),
  );
}

class EmailWidget extends StatelessWidget {
  const EmailWidget({
    super.key,
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.style,
    this.prefixIcon,
    this.controller,
    this.textInputAction,
    this.keyboardType,
    this.enabled,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
    this.borderSide,
  });
  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final TextStyle? style;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool? enabled;
  final FormFieldValidator<String?>? validator;
  final BorderSide? borderSide;
  final TextInputType? keyboardType;
  final Function(String? value)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      fieldKey: fieldKey,
      hintText: hintText,
      focusNode: focusNode,
      controller: controller,
      cursorColor: AppColors.blackColor,
      labelText: labelText,
      textInputAction: textInputAction ?? TextInputAction.next,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: TextInputType.emailAddress,
      prefixIcon: prefixIcon ??
          const Icon(
            Icons.email_outlined,
          ),
      validator:
          validator ?? (value) => Validators.validateEmail(value!.trim()),
    );
  }
}

// ignore: must_be_immutable
class PasswordWidget extends StatefulWidget {
  PasswordWidget({
    super.key,
    this.fieldKey,
    this.labelText,
    required this.passType,
    this.hintText,
    this.validator,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.showsuffixIcon,
    this.borderSide,
    this.onFieldSubmitted,
  });

  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String passType;
  final FormFieldValidator<String?>? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final BorderSide? borderSide;
  final Function(String? value)? onFieldSubmitted;
  bool? showsuffixIcon = true;

  @override
  PasswordWidgetState createState() => PasswordWidgetState();
}

class PasswordWidgetState extends State<PasswordWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return textFormField(
      fieldKey: widget.fieldKey,
      hintText: widget.hintText,
      border: widget.borderSide,
      labelText: widget.labelText,
      focusBorder: widget.borderSide,
      enabledBorder: widget.borderSide,
      focusNode: widget.focusNode,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      cursorColor: AppColors.blackColor,
      obscureText: _obscureText,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator ??
          (value) => Validators.validatePassword(
                value!.trim(),
                widget.passType,
              ),
      prefixIcon: const Icon(
        Icons.lock_outline_rounded,
      ),
      suffixIcon: widget.showsuffixIcon == true
          ? GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child: Icon(
                _obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            )
          : const SizedBox(),
    );
  }
}

class NumberWidget extends StatelessWidget {
  const NumberWidget({
    super.key,
    this.fieldKey,
    this.hintText,
    this.validator,
    this.controller,
    this.maxLength,
    this.focusNode,
    this.autofocus,
    this.style,
    this.textInputAction,
    this.textAlign = TextAlign.left,
    this.inputFormatters,
    this.keyboardType,
    this.fillColor,
  });

  final Key? fieldKey;
  final String? hintText;
  final List<TextInputFormatter?>? inputFormatters;
  final FormFieldValidator<String?>? validator;
  final TextEditingController? controller;
  final int? maxLength;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? style;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return textFormField(
      keyboardType: keyboardType,
      fieldKey: fieldKey,
      hintText: hintText,
      focusNode: focusNode,
      controller: controller,
      style: style,
      filledColor: fillColor,
      validator: validator,
      textAlign: textAlign,
      maxLength: maxLength,
      textInputAction: textInputAction,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]'))],
    );
  }
}

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget({
    super.key,
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.validator,
    this.prefixIcon,
    this.controller,
    this.focusNode,
    this.maxLines,
    this.maxLength,
    this.suffixIcon,
    this.onTap,
    this.enabled,
    this.autoFocus,
    this.readOnly,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.textInputAction,
    this.keyboardType,
    this.filledColor,
    this.hintStyle,
    this.style,
    this.focusBorder,
    this.border,
    this.enabledBorder,
    this.cursorColor,
    this.contentPadding,
    this.prefixText,
    this.prefixIconConstraints,
    this.textAlign = TextAlign.left,
  });

  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final bool? autoFocus;
  final bool? readOnly;
  final FormFieldValidator<String?>? validator;
  final ValueChanged<String?>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String?>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;
  final bool? enabled;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final Color? filledColor;
  final Color? cursorColor;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final BorderSide? focusBorder;
  final BorderSide? border;
  final BorderSide? enabledBorder;
  final String? prefixText;
  final BoxConstraints? prefixIconConstraints;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return textFormField(
      autofocus: autoFocus ?? false,
      fieldKey: fieldKey,
      focusNode: focusNode,
      hintText: hintText,
      filledColor: filledColor,
      style: style,
      readOnly: readOnly,
      labelText: labelText,
      inputFormatters: inputFormatters,
      hintStyle: hintStyle,
      controller: controller,
      cursorColor: cursorColor ?? AppColors.blackColor,
      keyboardType: keyboardType,
      validator: validator,
      prefixIcon: prefixIcon,
      prefixText: prefixText,
      prefixIconConstraints: prefixIconConstraints,
      suffixIcon: suffixIcon,
      maxLength: maxLength,
      maxLines: maxLines,
      textInputAction: textInputAction,
      textAlign: textAlign,
      onTap: onTap,
      enabled: enabled,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      focusBorder: focusBorder,
      border: border,
      contentPadding: contentPadding,
      enabledBorder: enabledBorder,
    );
  }
}
