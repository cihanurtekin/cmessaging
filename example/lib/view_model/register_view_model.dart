import 'package:example/helper/custom_router.dart';
import 'package:example/model/user.dart';
import 'package:example/service/auth_service_firebase.dart';
import 'package:example/service/notification_service_fcm.dart';
import 'package:example/service/shared_prefs_service.dart';
import 'package:example/service/user_database_service_firestore.dart';
import 'package:flutter/material.dart';

enum RegisterViewState { Idle, Loading, Registered, Error }

class RegisterViewModel with ChangeNotifier {
  FirebaseAuthService _authService = FirebaseAuthService();
  FirestoreUserDatabaseService _databaseService =
      FirestoreUserDatabaseService();
  FcmNotificationService _notificationService = FcmNotificationService();
  SharedPrefsService _sharedPrefsService = SharedPrefsService();

  RegisterViewState _state = RegisterViewState.Idle;

  RegisterViewState get state => _state;

  set state(RegisterViewState value) {
    _state = value;
    notifyListeners();
  }

  bool showPassword = false;

  void changeShowPassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  bool showPasswordAgain = false;

  void changeShowPasswordAgain() {
    showPasswordAgain = !showPasswordAgain;
    notifyListeners();
  }

  AutovalidateMode _formAutoValidateMode = AutovalidateMode.disabled;

  AutovalidateMode get formAutoValidateMode => _formAutoValidateMode;

  set formAutoValidateMode(AutovalidateMode value) {
    _formAutoValidateMode = value;
    notifyListeners();
  }

  Future<String?> signUpWithEmailAndPassword(BuildContext context, String email,
      String password, String username) async {
    //LoadingAlertDialog dialog = LoadingAlertDialog(loadingText: Sentences.registering());
    //DialogHelper.show(context, dialog, barrierDismissible: false);
    state = RegisterViewState.Loading;
    String? currentUserId;
    try {
      User? user = await _authService.signUpWithEmailAndPassword(
          email, password, username,);
      if (user != null) {
        await _authService.sendEmailVerification();
        String? notificationId = await _notificationService.getNotificationId();
        if (notificationId != null) {
          user.notificationId = notificationId;
        }
        await _databaseService.addUser(user);
        await _sharedPrefsService.saveLoggedInUserId(user.userId);
        currentUserId = await _sharedPrefsService.getLoggedInUserId();
        //dialog.cancel(context);
        _navigateToAllUsersPage(context, currentUserId);
      }
    } catch (e) {
      print("RegisterViewModel / signUpWithEmailAndPassword : ${e.toString()}");
      //dialog.cancel(context);
      //DialogHelper.showErrorDialog(context, e);
    }
    state = RegisterViewState.Idle;
    return currentUserId;
  }

  _navigateToAllUsersPage(BuildContext context, String? currentUserId) {
    if (currentUserId != null && currentUserId.trim().isNotEmpty) {
      Navigator.pushReplacementNamed(context, CustomRouter.ALL_USERS_PAGE);
    }
  }

  navigateToLoginPage(BuildContext context) {
    Navigator.pushReplacementNamed(context, CustomRouter.LOGIN_PAGE);
  }
}
