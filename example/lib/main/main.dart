import 'package:example/helper/custom_router.dart';
import 'package:example/main/c_messaging_settings.dart';
import 'package:example/main/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:c_messaging/c_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //_initCMessaging();
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
      routes: CustomRouter.getRoutes(),
      //localizationsDelegates: [
      //  GlobalMaterialLocalizations.delegate,
      //  GlobalWidgetsLocalizations.delegate
      //],
      //supportedLocales: [Locale('en', ''), Locale('tr', '')],
    );
  }
}

_initCMessaging(BuildContext context) {
  // 15.02.2023
  /*CMessaging().init(
    context,
    userId: "",
    serviceSettings: CMessagingSettings.serviceSettings,
    firebaseSettings: CMessagingSettings.firebaseSettings,
    languageSettings: CMessagingSettings.languageSettings,
    contactsPageSettings: CMessagingSettings.contactsPageSettings,
    messagesPageSettings: CMessagingSettings.messagesPageSettings,
  );*/
}
