import 'package:example/main/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "C Messaging",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      //routes: router.Router.getRoutes(),
      //localizationsDelegates: [
      //  GlobalMaterialLocalizations.delegate,
      //  GlobalWidgetsLocalizations.delegate
      //],
      //supportedLocales: [Locale('en', ''), Locale('tr', '')],
    );
  }
}