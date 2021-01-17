import 'package:example/helper/sentences.dart';
import 'package:flutter/material.dart';

class Validator {
  static const int NAME_SURNAME_MIN_LENGTH = 5;
  static const int NAME_SURNAME_MAX_LENGTH = 32;
  static const int EMAIL_MIN_LENGTH = 4;
  static const int EMAIL_MAX_LENGTH = 32;
  static const int PHONE_MIN_LENGTH = 4;
  static const int PHONE_MAX_LENGTH = 18;
  static const int PASSWORD_MIN_LENGTH = 6;
  static const int PASSWORD_MAX_LENGTH = 32;
  static const int EXTRA_MIN_LENGTH = 0;
  static const int EXTRA_MAX_LENGTH = 255;
  static const int EXTRA_MAX_LINES = 6;

  static String validateNameSurname(BuildContext context, String value) {
    if (value.trim().isEmpty)
      return Sentences.pleaseEnterNameSurname();
    else if (value.trim().length < NAME_SURNAME_MIN_LENGTH)
      return Sentences.nameSurnameShort(NAME_SURNAME_MIN_LENGTH);
    else if (value.trim().length > NAME_SURNAME_MAX_LENGTH)
      return Sentences.nameSurnameLong(NAME_SURNAME_MAX_LENGTH);
    else
      return null;
  }

  static String validateEmail(BuildContext context, String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (value.trim().isEmpty)
      return Sentences.pleaseEnterEmail();
    else if (!regex.hasMatch(value))
      return Sentences.pleaseEnterValidEmail();
    else
      return null;
  }

  static String validatePhone(BuildContext context, String value) {
    if (value.trim().isNotEmpty) {
      if (!isNumeric(value.trim())) {
        return Sentences.phoneShouldBeNumeric();
      } else if (value.trim().length < PHONE_MIN_LENGTH)
        return Sentences.phoneShort(PHONE_MIN_LENGTH);
      else if (value.trim().length > PHONE_MAX_LENGTH)
        return Sentences.phoneLong(PHONE_MAX_LENGTH);
      else
        return null;
    } else
      return null;
  }

  static String validatePassword(BuildContext context, String value) {
    if (value.trim().isEmpty)
      return Sentences.pleaseEnterPassword();
    else if (value.trim().length < PASSWORD_MIN_LENGTH)
      return Sentences.passwordShort(PASSWORD_MIN_LENGTH);
    else if (value.trim().length > PASSWORD_MAX_LENGTH)
      return Sentences.passwordLong(PASSWORD_MAX_LENGTH);
    else
      return null;
  }

  static String validatePasswordAgain(
      BuildContext context, String value, String valueAgain) {
    if (valueAgain.trim().isEmpty)
      return Sentences.pleaseEnterPasswordAgain();
    else if (value.trim() != valueAgain.trim())
      return Sentences.passwordsNotMatch();
    else
      return null;
  }

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
