import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/model/user.dart';
import 'package:flutter/material.dart';
import 'package:c_messaging/c_messaging.dart';

enum AllUsersViewState { Idle, Loading }

class AllUsersViewModel with ChangeNotifier {
  FirebaseFirestore _firestore;

  AllUsersViewState _state = AllUsersViewState.Loading;

  AllUsersViewState get state => _state;

  List<User> _users = [];

  List<User> get users => _users;

  AllUsersViewModel() {
    _firestore = FirebaseFirestore.instance;
    _firestore.settings = Settings(persistenceEnabled:  false);
    getAllUsers();
  }

  set state(AllUsersViewState value) {
    _state = value;
    notifyListeners();
  }

  void getAllUsers() async {
    state = AllUsersViewState.Loading;

    try {
      QuerySnapshot qs = await _firestore
          .collection("users")
          .limit(10)
          .get();
      for (DocumentSnapshot doc in qs.docs) {
        try {
          User u = User.fromMap(doc.id, doc.data());
          _users.add(u);
        } catch (e) {
          print("AllUsersViewModel/ getAllUsers / for loop : ${e.toString()}");
        }
      }
    } catch (e) {
      print("AllUsersViewModel/ getAllUsers : ${e.toString()}");
    } finally {
      state = AllUsersViewState.Idle;
    }
  }

  openContactsPage(BuildContext context){
    CMessaging().pushContactsPage(context);
  }
}
