import 'package:example/view/all_users_page.dart';
import 'package:example/view/login_page.dart';
import 'package:example/view/register_page.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static const String LOGIN_PAGE = '/login_page';
  static const String REGISTER_PAGE = '/register_page';
  static const String ALL_USERS_PAGE = '/all_users_page';
  static const String PROFILE_PAGE = '/profile_page';
  static const String MESSAGE_CONTACTS_PAGE = '/contacts_page';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      LOGIN_PAGE: (BuildContext context) => LoginPage(),
      REGISTER_PAGE: (BuildContext context) => RegisterPage(),
      ALL_USERS_PAGE: (BuildContext context) => AllUsersPage(),
      //PROFILE_PAGE: (BuildContext context) => ProfilePage(),
      //MESSAGE_CONTACTS_PAGE: (BuildContext context) => MessageContactsPage(),
    };
  }
}