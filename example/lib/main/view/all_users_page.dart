import 'package:example/main/model/user.dart';
import 'package:example/main/view_model/all_users_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllUsersPage extends StatefulWidget {
  @override
  _AllUsersPageState createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  User _currentDatabaseUser;

  //UserDatabaseRepository _userDatabaseRepository = locator<UserDatabaseRepository>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => AllUsersViewModel(),
      child: SafeArea(
        child: Scaffold(
          body: Consumer<AllUsersViewModel>(
            builder: (ctx, viewModel, child) =>
            viewModel.state == AllUsersViewState.Idle
                ? ListView.builder(
              itemCount: viewModel.users.length,
              itemBuilder: (context, index) {
                User user = viewModel.users[index];
                return ListTile(
                  title: Text(user.nameSurname),
                  subtitle: Text(user.userId),
                  onTap: () async {
                    /*await getCurrentDatabaseUser();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ChangeNotifierProvider(
                                create: (ctx) => MessagesViewModel(
                                    _currentDatabaseUser, user),
                                child: MessagesPage()),
                      ),
                    );*/
                  },
                );
              },
            )
                : Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Future<User> getCurrentDatabaseUser() async {
    if (_currentDatabaseUser != null) {
      return _currentDatabaseUser;
    }
    try {
      //_currentDatabaseUser = await _userDatabaseRepository.getCurrentDatabaseUser();
    } catch (e) {
      print("MessagesViewModel / getCurrentDatabaseUser : ${e.toString()}");
    }
    return _currentDatabaseUser;
  }
}
