import 'package:c_messaging/src/model/channel.dart';
import 'package:c_messaging/src/repository/channel_database_repository.dart';
import 'package:c_messaging/src/settings/messages_page_settings.dart';
import 'package:c_messaging/src/tools/locator.dart';
import 'package:c_messaging/src/settings/firebase_settings.dart';
import 'package:c_messaging/src/settings/language_settings.dart';
import 'package:c_messaging/src/view/messages_page.dart';
import 'package:c_messaging/src/view_model/messages_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ChannelsViewState {
  idle,
  loadingFirstQuery,
  loadingOtherQueries,
  deleting,
  error
}

class ChannelsViewModel with ChangeNotifier {
  ChannelDatabaseRepository _channelDatabaseRepository =
      locator<ChannelDatabaseRepository>();

  final ScrollController _scrollController = ScrollController();

  ScrollController get scrollController => _scrollController;

  ChannelsViewState _state = ChannelsViewState.loadingFirstQuery;

  ChannelsViewState get state => _state;

  set state(ChannelsViewState value) {
    _state = value;
    notifyListeners();
  }

  List<Channel> _channels = [];

  List<Channel> get channels => _channels;

  dynamic _lastItemToStartAfter;

  // TODO: Add listener when needed.
  //StreamSubscription? _channelUpdateSubscription;

  final String _currentDatabaseUserId;

  final MessagesPageSettings messagesPageSettings;
  final FirebaseSettings firebaseSettings;
  final LanguageSettings languageSettings;

  final int _paginationLimitForFirstQuery;
  final int _paginationLimitForOtherQueries;

  ChannelsViewModel({
    required String userId,
    required int paginationLimitForFirstQuery,
    required int paginationLimitForOtherQueries,
    required this.messagesPageSettings,
    required this.firebaseSettings,
    required this.languageSettings,
  })  : _currentDatabaseUserId = userId,
        _paginationLimitForFirstQuery = paginationLimitForFirstQuery,
        _paginationLimitForOtherQueries = paginationLimitForOtherQueries {
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearChannels();
      _getChannels(_paginationLimitForFirstQuery);
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_state == ChannelsViewState.idle) {
        _state = ChannelsViewState.loadingOtherQueries;
        _getChannels(_paginationLimitForOtherQueries);
      }
    }
  }

  void _clearChannels() {
    _channels = [];
    _lastItemToStartAfter = null;
  }

  void refreshChannels() {
    state = ChannelsViewState.loadingFirstQuery;
    _clearChannels();
    _getChannels(_paginationLimitForFirstQuery);
  }

  void _getChannels(int paginationLimit) async {
    try {
      List channelList = await _channelDatabaseRepository.getChannels(
        _lastItemToStartAfter,
        paginationLimit,
      );
      _channels.addAll(
        List.from(channelList[0]),
      );
      _lastItemToStartAfter = channelList[1];
      // TODO: Add listener when needed.
      /*if (_channelUpdateSubscription == null) {
        _addListener();
      }*/
      state = ChannelsViewState.idle;
    } catch (e) {
      debugPrint('ChannelsViewModel / _getChannels: ${e.toString()}');
      state = ChannelsViewState.error;
    }
  }

  // TODO: Add listener when needed.
  /*
  @override
  dispose() {
    _channelUpdateSubscription?.cancel();
    super.dispose();
  }

  bool isUserSender(Message message) {
    return message.senderId == _currentDatabaseUserId;
  }

  void _addListener() async {
    _channelUpdateSubscription = _channelDatabaseRepository
        .addListenerToChannel(_currentDatabaseUserId, "")
        .listen((messageList) {
      if (messageList.isNotEmpty) {
        Message? newMessage = messageList[0];

        if (newMessage != null) {
          newMessageHandler(newMessage);
        }
      }
    });
  }

  void newMessageHandler(Message newMessage) {
    String contactIdToRemove = "";
    Message messageToAdd = newMessage;
    for (Message m in _messages) {
      if (m.contactId == messageToAdd.contactId) {
        User? contactUser = m.contactUser;
        messageToAdd.contactUser = contactUser;
        contactIdToRemove = m.contactId;
        break;
      }
    }
    if (contactIdToRemove.trim().isNotEmpty) {
      _messages.removeWhere((mess) => mess.contactId == contactIdToRemove);
    }
    _messages.insert(0, messageToAdd);
    notifyListeners();
  }

  void updateLastMessageCallback(Message message) {
    int index = messages.indexWhere((m) => m.contactId == message.contactId);
    if (index >= 0) {
      messages[index] = message;
      messages.sort((m1, m2) {
        return m2.dateOfCreated.compareTo(m1.dateOfCreated);
      });
      notifyListeners();
    }
  }

  void updateMessageStatusCallback(Message mess) {
    Message? message = messages.firstWhereOrNull(
      (m) => m.contactId == mess.contactId,
    );
    if (message != null) {
      message.updateSendStatus(mess.sendStatus);
    }
  }
  */

  void openMessagesPage(BuildContext context, Channel channel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ChangeNotifierProvider(
          create: (context) => MessagesViewModel.channel(
            userId: _currentDatabaseUserId,
            channel: channel,
            paginationLimitForFirstQuery:
                messagesPageSettings.paginationLimitForFirstQuery,
            paginationLimitForOtherQueries:
                messagesPageSettings.paginationLimitForOtherQueries,
            firebaseSettings: firebaseSettings,
            languageSettings: languageSettings,
          ),
          child: MessagesPage(messagesPageSettings, languageSettings),
        ),
      ),
    );
  }

  void onBackButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }
}
