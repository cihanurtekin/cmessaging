import 'package:example/helper/custom_router.dart';
import 'package:example/model/user.dart';
import 'package:example/service/auth_service_firebase.dart';
import 'package:example/service/notification_service_fcm.dart';
import 'package:example/service/shared_prefs_service.dart';
import 'package:example/service/user_database_service_firestore.dart';
import 'package:flutter/material.dart';

enum LoginViewState { Idle, Loading, LoggedIn, Error }
enum PasswordResetState { SendingEmail, Success, Error }

class LoginViewModel with ChangeNotifier {
  FirebaseAuthService _authService = FirebaseAuthService();
  FirestoreUserDatabaseService _databaseService =
      FirestoreUserDatabaseService();
  FcmNotificationService _notificationService = FcmNotificationService();
  SharedPrefsService _sharedPrefsService = SharedPrefsService();

  LoginViewState _state = LoginViewState.Idle;

  LoginViewState get state => _state;

  set state(LoginViewState value) {
    _state = value;
    notifyListeners();
  }

  bool showPassword = false;

  void changeShowPassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  bool _autoValidateForm = false;

  bool get autoValidateForm => _autoValidateForm;

  set autoValidateForm(bool value) {
    _autoValidateForm = value;
    notifyListeners();
  }

  Future<String> signInWithGoogle(BuildContext context) async {
    state = LoginViewState.Loading;
    String currentUserId;
    try {
      User user = await _authService.signInWithGoogle();
      if (user != null) {
        String notificationId = await _notificationService.getNotificationId();
        if (notificationId != null) {
          user.notificationId = notificationId;
        }
        await _databaseService.addUser(user);
        await _sharedPrefsService.saveLoggedInUserId(user.userId);
        currentUserId = await _sharedPrefsService.getLoggedInUserId();
        _navigateToAllUsersPage(context, currentUserId);
      }
    } catch (e) {
      print("LoginViewModel / signInWithGoogle : ${e.toString()}");
      //DialogHelper.showErrorDialog(context, e);
    }
    state = LoginViewState.Idle;
    return currentUserId;
  }

  Future<String> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    //LoadingAlertDialog dialog = LoadingAlertDialog(loadingText: Sentences.signingIn());
    //DialogHelper.show(context, dialog, barrierDismissible: false);
    state = LoginViewState.Loading;
    String currentUserId;
    try {
      User user =
          await _authService.signInWithEmailAndPassword(email, password);
      if (user != null) {
        String notificationId = await _notificationService.getNotificationId();

        await _databaseService
            .updateUser(user.userId, {User.notificationIdKey: notificationId});
        await _sharedPrefsService.saveLoggedInUserId(user.userId);
        currentUserId = await _sharedPrefsService.getLoggedInUserId();
        //dialog.cancel(context);
        _navigateToAllUsersPage(context, currentUserId);
      }
    } catch (e) {
      print("LoginViewModel / signInWithEmailAndPassword : ${e.toString()}");
      //dialog.cancel(context);
      //DialogHelper.showErrorDialog(context, e);
    }
    state = LoginViewState.Idle;
    return currentUserId;
  }

  Future<void> sendPasswordResetEmail(
      BuildContext context, String email) async {
    //LoadingAlertDialog dialog = LoadingAlertDialog(loadingText: Sentences.sendingPasswordResetEmail());
    //DialogHelper.show(context, dialog, barrierDismissible: false);
    try {
      await _authService.sendPasswordResetEmail(email);
      //dialog.cancel(context);
      //DialogHelper.showSuccessDialog(context, Sentences.passwordResetEmailSentSuccessfully());
    } catch (e) {
      print("LoginViewModel / sendPasswordResetEmail : ${e.toString()}");
      //dialog.cancel(context);
      //DialogHelper.showErrorDialog(context, e);
    }
  }

  _navigateToAllUsersPage(BuildContext context, String currentUserId) {
    if (currentUserId != null && currentUserId.trim().isNotEmpty) {
      Navigator.pushReplacementNamed(context, CustomRouter.ALL_USERS_PAGE);
    }
  }

  navigateToRegisterPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, CustomRouter.REGISTER_PAGE);
  }
}
