import 'package:example/helper/sentences.dart';

class Validator {
  static const int NAME_SURNAME_MIN_LENGTH = 5;
  static const int NAME_SURNAME_MAX_LENGTH = 32;
  static const int EMAIL_MIN_LENGTH = 4;
  static const int EMAIL_MAX_LENGTH = 32;
  static const int PHONE_MIN_LENGTH = 10;
  static const int PHONE_MAX_LENGTH = 10;
  static const int PASSWORD_MIN_LENGTH = 6;
  static const int PASSWORD_MAX_LENGTH = 32;
  static const int EXTRA_MIN_LENGTH = 0;
  static const int EXTRA_MAX_LENGTH = 255;
  static const int EXTRA_MAX_LINES = 6;

  static String? validateNameSurname(String? value) {
    String tValue = value != null ? value.trim() : "";
    if (tValue.isEmpty)
      return Sentences.pleaseEnterNameSurname();
    else if (tValue.length < NAME_SURNAME_MIN_LENGTH)
      return Sentences.nameSurnameShort(NAME_SURNAME_MIN_LENGTH);
    else if (tValue.length > NAME_SURNAME_MAX_LENGTH)
      return Sentences.nameSurnameLong(NAME_SURNAME_MAX_LENGTH);
    else
      return null;
  }

  static String? validateEmail(String? value) {
    String tValue = value != null ? value.trim() : "";
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (tValue.isEmpty)
      return Sentences.pleaseEnterEmail();
    else if (!regex.hasMatch(tValue))
      return Sentences.pleaseEnterValidEmail();
    else
      return null;
  }

  static String? validatePhone(String? value) {
    String tValue = value != null ? value.trim() : "";
    if (tValue.isNotEmpty) {
      if (!isNumeric(tValue)) {
        return Sentences.phoneShouldBeNumeric();
      } else if (PHONE_MIN_LENGTH == PHONE_MAX_LENGTH) {
        if (tValue.length != PHONE_MIN_LENGTH)
          return Sentences.phoneAsLongAs(PHONE_MIN_LENGTH);
        else
          return null;
      } else {
        if (tValue.length < PHONE_MIN_LENGTH)
          return Sentences.phoneShort(PHONE_MIN_LENGTH);
        else if (tValue.length > PHONE_MAX_LENGTH)
          return Sentences.phoneLong(PHONE_MAX_LENGTH);
        else
          return null;
      }
    } else
      return null;
  }

  static String? validatePassword(String? value) {
    String tValue = value != null ? value.trim() : "";
    if (tValue.isEmpty)
      return Sentences.pleaseEnterPassword();
    else if (tValue.length < PASSWORD_MIN_LENGTH)
      return Sentences.passwordShort(PASSWORD_MIN_LENGTH);
    else if (tValue.length > PASSWORD_MAX_LENGTH)
      return Sentences.passwordLong(PASSWORD_MAX_LENGTH);
    else
      return null;
  }

  static String? validatePasswordAgain(String password, String? value) {
    String tValue = value != null ? value.trim() : "";
    if (tValue.isEmpty)
      return Sentences.pleaseEnterPasswordAgain();
    else if (password.trim() != tValue)
      return Sentences.passwordsNotMatch();
    else
      return null;
  }

  static bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }
}
