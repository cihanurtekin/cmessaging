import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/model/user.dart';
import 'package:flutter/material.dart';

enum AllUsersViewState { Idle, Loading }

class AllUsersViewModel with ChangeNotifier {
  late FirebaseFirestore _firestore;

  AllUsersViewState _state = AllUsersViewState.Loading;

  AllUsersViewState get state => _state;

  List<User> _users = [];

  List<User> get users => _users;

  AllUsersViewModel() {
    _firestore = FirebaseFirestore.instance;
    _firestore.settings = Settings(persistenceEnabled: false);
    getAllUsers();
  }

  set state(AllUsersViewState value) {
    _state = value;
    notifyListeners();
  }

  void getAllUsers() async {
    state = AllUsersViewState.Loading;

    try {
      QuerySnapshot<Map<String, dynamic>?> qs =
          await _firestore.collection("users").limit(10).get();
      for (DocumentSnapshot<Map<String, dynamic>?> doc in qs.docs) {
        try {
          Map<String, dynamic>? docData = doc.data();
          if (docData != null) {
            User u = User.fromMap(doc.id, docData);
            _users.add(u);
          }
        } catch (e) {
          debugPrint("AllUsersViewModel/ getAllUsers / for loop : ${e.toString()}");
        }
      }
    } catch (e) {
      debugPrint("AllUsersViewModel/ getAllUsers : ${e.toString()}");
    } finally {
      state = AllUsersViewState.Idle;
    }
  }

  openContactsPage(BuildContext context) {
    // 15.02.2023 CMessaging().pushContactsPage(context);
  }
}
