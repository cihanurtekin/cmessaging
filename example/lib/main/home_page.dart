import 'package:example/helper/custom_router.dart';
import 'package:example/service/shared_prefs_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPrefsService _sharedPrefsService = SharedPrefsService();

  navigate(BuildContext context) async {
    String _userId = await _sharedPrefsService.getLoggedInUserId();
    if (_userId != null && _userId.trim().isNotEmpty) {
      Navigator.pushReplacementNamed(context, CustomRouter.ALL_USERS_PAGE);
    } else {
      Navigator.pushReplacementNamed(context, CustomRouter.LOGIN_PAGE);
    }
  }

  @override
  Widget build(BuildContext context) {
    navigate(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(),
    );
  }
}
