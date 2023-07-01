import 'package:c_messaging/src/custom_widgets/message_photo.dart';
import 'package:c_messaging/src/custom_widgets/profile_photo.dart';
import 'package:c_messaging/src/model/user.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/settings/messages_page_settings.dart';
import 'package:c_messaging/src/settings/language_settings.dart';
import 'package:c_messaging/src/view_model/messages_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatelessWidget {
  final TextEditingController _messageTextFieldController =
      TextEditingController();

  final ScrollController _controller = ScrollController();

  final MessagesPageSettings _pageSettings;

  final LanguageSettings _languageSettings;

  MessagesPage(this._pageSettings, this._languageSettings);

  @override
  Widget build(BuildContext context) {
    _addScrollListener(context);
    return WillPopScope(
      onWillPop: onPop,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  Future<bool> onPop() async {
    return true;
  }

  AppBar _buildAppBar(BuildContext context) {
    MessagesViewModel viewModel = Provider.of<MessagesViewModel>(
      context,
      listen: false,
    );
    User contactUser = viewModel.contactUser;
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: _pageSettings.backIconColor,
        ),
        onPressed: () {
          MessagesViewModel viewModel =
              Provider.of<MessagesViewModel>(context, listen: false);
          viewModel.onBackButtonPressed(context);
        },
      ),
      title: Row(
        children: <Widget>[
          ProfilePhoto(
            photo: contactUser.profilePhotoUrl,
            placeholderImagePath: _pageSettings.profilePhotoPlaceholderPath,
            radius: _pageSettings.profilePhotoRadius,
            backgroundColor: _pageSettings.profilePhotoBackgroundColor,
          ),
          SizedBox(
            width: _pageSettings.profilePhotoAndUsernameSpaceBetween,
          ),
          Flexible(
            child: Text(
              contactUser.username.isNotEmpty
                  ? contactUser.username
                  : _languageSettings
                      .messagesPageDefaultUsernameForContactTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _pageSettings.titleTextColor,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _pageSettings.toolbarColor,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: _pageSettings.backgroundColor != null
          ? _pageSettings.backgroundColor
          : null,
      decoration: _pageSettings.backgroundImageAssetPath != null
          ? BoxDecoration(
              image: DecorationImage(
                image: AssetImage(_pageSettings.backgroundImageAssetPath!),
                fit: BoxFit.fill,
              ),
            )
          : null,
      child: Column(
        children: <Widget>[
          _buildBodyAccordingToState(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _buildTextFieldRow(),
                SizedBox(width: 8.0),
                _buildCircularButton(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBodyAccordingToState() {
    return Expanded(
      child: Consumer<MessagesViewModel>(builder: (context, viewModel, child) {
        return viewModel.state == MessagesViewState.LoadingFirstQuery
            ? Center(child: CircularProgressIndicator())
            : viewModel.state == MessagesViewState.Error
                ? FloatingActionButton(
                    child: Icon(Icons.refresh),
                    onPressed: () {
                      viewModel.getMessagesWithPagination();
                    })
                : _buildListView();
      }),
    );
  }

  Widget _buildListView() {
    return Consumer<MessagesViewModel>(
      builder: (context, viewModel, child) => ListView.builder(
        controller: _controller,
        itemCount: viewModel.messages.length,
        itemBuilder: _buildMessagesListTile,
        reverse: true,
      ),
    );
  }

  /*
  Widget _buildListTile(BuildContext context, int index) {
    return Consumer<MessagesViewModel>(builder: (context, viewModel, child) {
      // TODO: DISSMISSIBLE DELETED. EDIT NEW DELETE FUNCTIONALITY
      return Dismissible(
        key: Key(UniqueKey().toString()),
        direction: viewModel.isUserSender(index)
            ? DismissDirection.endToStart
            : DismissDirection.startToEnd,
        child: _buildMessagesListTile(index),
        confirmDismiss: (direction) =>
            DialogHelper.showDeleteMessageDialog(context),
        background: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          color: Colors.red,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          alignment: viewModel.isUserSender(index)
              ? Alignment.centerRight
              : Alignment.centerLeft,
        ),
        onDismissed: (direction) => _onDismissed(context, index),
      );
    });
  }
  */

  Widget _buildMessagesListTile(BuildContext context, int index) {
    MessagesViewModel viewModel =
        Provider.of<MessagesViewModel>(context, listen: false);
    Message? message = viewModel.getMessageWithIndex(index);
    bool isUserSender = viewModel.isUserSender(index);
    return message != null
        ? ListTile(
            contentPadding: EdgeInsets.only(
                left: isUserSender
                    ? _pageSettings.listTileMaxPadding
                    : _pageSettings.listTileMinPadding,
                right: isUserSender
                    ? _pageSettings.listTileMinPadding
                    : _pageSettings.listTileMaxPadding),
            title: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      _pageSettings.listTileCornerRadius)),
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(_pageSettings.messageTextPadding),
                    color: isUserSender
                        ? _pageSettings.senderMessageBackgroundColor
                        : _pageSettings.receiverMessageBackgroundColor,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: isUserSender
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: message.messageType ==
                                  Message.MESSAGE_TYPE_IMAGE
                              ? MessagePhoto(
                                  photo: message.messageBody,
                                  placeholderImagePath:
                                      _pageSettings.messagePhotoPlaceholderPath,
                                )
                              : Text(
                                  message.messageBody,
                                  style: TextStyle(
                                      fontSize:
                                          _pageSettings.messageBodyTextSize),
                                ),
                        ),
                        SizedBox(height: 4.0),
                        _buildDateRow(context, index),
                      ],
                    ),
                  ),
                  if (message.status == Message.STATUS_ERROR)
                    IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          viewModel.retryToSendMessage(index, message);
                        }),
                ],
              ),
            ),
            //onLongPress: () => _onListTileLongPressed(context, index),
          )
        : Container();
  }

  _buildDateRow(BuildContext context, int index) {
    MessagesViewModel viewModel =
        Provider.of<MessagesViewModel>(context, listen: false);
    Color iconColor = Colors.black45;
    Message? message = viewModel.getMessageWithIndex(index);
    return message != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                viewModel.getMessageDateText(context, index),
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: _pageSettings.messageDateTextSize),
              ),
              if (viewModel.isUserSender(index))
                Container(
                  margin: EdgeInsets.only(left: 2.0),
                  child: message.status == Message.STATUS_WAITING
                      ? SizedBox(
                          width: _pageSettings.messageStatusIconsSize,
                          height: _pageSettings.messageStatusIconsSize,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(iconColor),
                          ),
                        )
                      : message.status == Message.STATUS_SENT
                          ? Icon(
                              Icons.check,
                              size: _pageSettings.messageStatusIconsSize,
                              color: iconColor,
                            )
                          : message.status == Message.STATUS_ERROR
                              ? Icon(
                                  Icons.clear,
                                  size: _pageSettings.messageStatusIconsSize,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.access_time,
                                  size: _pageSettings.messageStatusIconsSize,
                                  color: iconColor,
                                ),
                ),
            ],
          )
        : Container();
  }

  Widget _buildTextFieldRow() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _pageSettings.messageWritingTextFieldMinHeight / 2.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: _pageSettings.messageWritingTextFieldMinHeight,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Consumer<MessagesViewModel>(
                    builder: (context, viewModel, child) => TextField(
                      controller: _messageTextFieldController,
                      maxLines: null,
                      enabled: viewModel.state !=
                              MessagesViewState.LoadingFirstQuery &&
                          viewModel.state != MessagesViewState.Error,
                      decoration: InputDecoration(
                        hintText: viewModel.languageSettings.typeMessage,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.camera_enhance),
                          onPressed: () {
                            viewModel.sendImageMessage(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
                _pageSettings.messageWritingTextFieldMinHeight / 2.0),
          ),
          color: Colors.white,
        ),
        /*decoration: ShapeDecoration(
          shape: StadiumBorder(),
          color: Colors.white,
        ),*/
      ),
    );
  }

  Widget _buildCircularButton(BuildContext context) {
    return Container(
      width: _pageSettings.messageWritingTextFieldMinHeight,
      height: _pageSettings.messageWritingTextFieldMinHeight,
      child: RawMaterialButton(
        fillColor: _pageSettings.sendMessageButtonColor,
        shape: CircleBorder(),
        child: Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          MessagesViewModel viewModel =
              Provider.of<MessagesViewModel>(context, listen: false);
          String messageBody = _messageTextFieldController.text;
          _messageTextFieldController.clear();
          viewModel.sendMessage(messageBody);
        },
      ),
    );
  }

  // TODO : Edit this
  _onDismissed(BuildContext context, int index) async {
    //MessagesViewModel messagesViewModel = Provider.of<MessagesViewModel>(context);
    // ContactsViewModel contactsViewModel = Provider.of<ContactsViewModel>(context);
    // Message newLastMessage = await messagesViewModel.deleteMessage(index);
    /*if (newLastMessage != null &&
        newLastMessage.messageUid != currentMessage.messageUid) {
      _contactsViewModel.updateLastMessageCallback(newLastMessage);
    }*/
  }

  _addScrollListener(BuildContext context) {
    _controller.addListener(() {
      _scrollListener(context);
    });
  }

  _scrollListener(BuildContext context) {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      //if (mounted) {
      Provider.of<MessagesViewModel>(context, listen: false)
          .getMessagesWithPagination();
      //}
    }
  }

/*
  _onListTileLongPressed(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (context) {
          return DeleteAlertDialog(vs: MessagesPageViewSettings);
        }).then((isAccepted) {
      if (isAccepted != null && isAccepted) {
        Message currentMessage = _messageList[index];
        setState(() {
          _messageList.removeAt(index);
        });
        Message newLastMessage = _messageList[0];
        newLastMessage.userUid = MessagesPageViewSettings.contactUid;
        newLastMessage.username = MessagesPageViewSettings.username;
        newLastMessage.profilePhotoUrl = MessagesPageViewSettings.profilePhoto;
        widget.callbackLastMessage(MessagesPageViewSettings.contactUid, newLastMessage);
        MessagesPageViewSettings.comvs.cmessaging.deleteMessage(
            MessagesPageViewSettings.comvs.userUid, currentMessage, newLastMessage);
      }
    });
  }
  */
}
