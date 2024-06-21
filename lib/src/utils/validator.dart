class Validators {
  static String? validateEmail(String? value) {
    const String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Email is Invalid';
    } else {
      return null;
    }
  }

  static String? validatePassword(String value, String passType) {
    const String pattern =
        r'^.*(?=.{8,})((?=.*[!?@#$%^&*()\-_=+{};:,<.>]){1})(?=.*\d)((?=.*[a-z]){1})((?=.*[A-Z]){1}).*$';
    final RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return '$passType is required';
    } else if (value.length < 8) {
      return '$passType should be more than 8 characters';
    } else if (!regExp.hasMatch(value)) {
      return '''The $passType must be at least 8 characters long and contain a mixture of both uppercase and lowercase letters, at least one number and one special character (e.g.,! @ # ?).''';
    } else {
      return null;
    }
  }

  static String? validateText(String? value, String type) {
    if (value?.trim() == '' || value?.trim().isEmpty == true) {
      return '$type is required';
    } else {
      return null;
    }
  }
}
