import 'dart:io';

import 'package:c_messaging/src/dialog/choice_dialog.dart';
import 'package:c_messaging/src/dialog/photo_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static Future<T> show<T>(BuildContext context, Widget dialog,
      {bool barrierDismissible = true}) {
    return showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return dialog;
        });
  }

  /*static void showLoadingDialog(BuildContext context, String loadingText,
      {bool barrierDismissible = false}) {
    LoadingAlertDialog dialog = LoadingAlertDialog(
      loadingText: loadingText,
    );
    show(context, dialog, barrierDismissible: barrierDismissible);
  }*/

  static Future<bool> showChoiceDialog(
      BuildContext context,
      IconData icon,
      String titleText,
      String contentText,
      String confirmText,
      String cancelText) {
    ChoiceDialog dialog = ChoiceDialog(
      icon: icon,
      titleText: titleText,
      contentText: contentText,
      acceptButtonText: confirmText,
      cancelButtonText: cancelText,
    );
    return show<bool>(context, dialog);
  }


  static Future<bool> showPhotoDialog(
      BuildContext context,
      File file,
      String sendButtonText,
      String cancelButtonText, {
        IconData icon,
        String titleText = '',
        double maxImageWidth = 400.0,
      }) {
    PhotoDialog dialog = PhotoDialog(
        imageFile: file,
        sendButtonText: sendButtonText,
        cancelButtonText: cancelButtonText,
        icon: icon,
        maxImageWidth: maxImageWidth,
        titleText: titleText);
    return show<bool>(context, dialog);
  }

  /*
  static Future<bool> showDeleteMessageDialog(BuildContext context) {
    return showChoiceDialog(
      context,
      Icons.delete,
      Sentences.deleteMessage(),
      Sentences.deleteMessageConfirm(),
      Sentences.confim(),
      Sentences.cancel(),
    );
  }

  static Future<bool> showDeleteAllMessagesDialog(BuildContext context) {
    return showChoiceDialog(
      context,
      Icons.delete,
      Sentences.deleteAllMessages(),
      Sentences.deleteAllMessagesConfirm(),
      Sentences.confim(),
      Sentences.cancel(),
    );
  }
   */

  /*
  static void showSuccessDialog(BuildContext context, String successText) {
    ResultAlertDialog dialog = ResultAlertDialog(
      result: Result.Success,
      resultText: successText,
      okButtonText: Sentences.ok(),
    );
    show(context, dialog);
  }

  static void showWarningDialog(BuildContext context, String warningText) {
    ResultAlertDialog dialog = ResultAlertDialog(
      result: Result.Warning,
      resultText: warningText,
      okButtonText: Sentences.ok(),
    );
    show(context, dialog);
  }

  static void showErrorDialog(BuildContext context, dynamic e) {
    String errorText = getError(context, e);
    ResultAlertDialog dialog = ResultAlertDialog(
      result: Result.Error,
      resultText: errorText,
      okButtonText: Sentences.ok(),
    );
    show(context, dialog);
  }

  static String getError(BuildContext context, dynamic e) {
    String result = Sentences.errorTryAgain();
    if (e != null) {
      if (e is PlatformException) {
        switch (e.code) {
          case 'ERROR_USER_NOT_FOUND':
            result = Sentences.errorUserNotFound();
            break;
          case 'ERROR_WRONG_PASSWORD':
            result = Sentences.errorWrongPassword();
            break;
          case 'ERROR_EMAIL_ALREADY_IN_USE':
            result = Sentences.errorEmailAlreadyInUse();
            break;
        }
      }
    }
    return result;
  }
   */
}
