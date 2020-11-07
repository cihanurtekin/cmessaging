import 'package:c_messaging/src/custom_widgets/message_photo.dart';
import 'package:c_messaging/src/custom_widgets/profile_photo.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/view_model/messages_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  TextEditingController _messageTextFieldController = TextEditingController();

  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onPop,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<MessagesViewModel>(
            builder: (context, viewModel, child) => Row(
              children: <Widget>[
                ProfilePhoto(
                  photo: viewModel.contactUser.profilePhotoUrl,
                  placeholderImagePath:
                      viewModel.settings.profilePhotoPlaceholderPath,
                  radius: viewModel.settings.profilePhotoRadius,
                  backgroundColor:
                      viewModel.settings.profilePhotoBackgroundColor,
                ),
                SizedBox(
                    width:
                        viewModel.settings.profilePhotoAndUsernameSpaceBetween),
                Flexible(
                  child: Text(
                    viewModel.contactUser.username.isNotEmpty
                        ? viewModel.contactUser.username
                        : viewModel.settings.defaultUsernameForContactTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Future<bool> onPop() async {
    return true;
  }

  Widget _buildBody() {
    return Consumer<MessagesViewModel>(
      builder: (context, viewModel, child) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                viewModel.settings.backgroundImageAssetPath,
              ),
              fit: BoxFit.fill),
        ),
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
                  _buildCircularButton(),
                ],
              ),
            )
          ],
        ),
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
    return Consumer<MessagesViewModel>(builder: (context, viewModel, child) {
      Message message = viewModel.getMessageWithIndex(index);
      bool isUserSender = viewModel.isUserSender(index);
      return ListTile(
        contentPadding: EdgeInsets.only(
            left: isUserSender
                ? viewModel.settings.listTileMaxPadding
                : viewModel.settings.listTileMinPadding,
            right: isUserSender
                ? viewModel.settings.listTileMinPadding
                : viewModel.settings.listTileMaxPadding),
        title: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  viewModel.settings.listTileCornerRadius)),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(viewModel.settings.messageTextPadding),
                color: isUserSender
                    ? viewModel.settings.senderMessageBackgroundColor
                    : viewModel.settings.receiverMessageBackgroundColor,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment:
                          isUserSender ? Alignment.topRight : Alignment.topLeft,
                      child: message.messageType == Message.MESSAGE_TYPE_IMAGE
                          ? MessagePhoto(
                              photo: message.messageBody,
                              placeholderImagePath: viewModel
                                  .settings.messagePhotoPlaceholderPath,
                            )
                          : Text(
                              message.messageBody,
                              style: TextStyle(
                                  fontSize:
                                      viewModel.settings.messageBodyTextSize),
                            ),
                    ),
                    SizedBox(height: 4.0),
                    _buildDateRow(index),
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
      );
    });
  }

  _buildDateRow(int index) {
    return Consumer<MessagesViewModel>(
      builder: (context, viewModel, child) {
        Color iconColor = Colors.black45;
        Message message = viewModel.getMessageWithIndex(index);
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              viewModel.getMessageDateText(context, index),
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: viewModel.settings.messageDateTextSize),
            ),
            if (viewModel.isUserSender(index))
              Container(
                margin: EdgeInsets.only(left: 2.0),
                child: message.status == Message.STATUS_WAITING
                    ? SizedBox(
                        width: viewModel.settings.messageStatusIconsSize,
                        height: viewModel.settings.messageStatusIconsSize,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                          valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                        ),
                      )
                    : message.status == Message.STATUS_SENT
                        ? Icon(
                            Icons.check,
                            size: viewModel.settings.messageStatusIconsSize,
                            color: iconColor,
                          )
                        : message.status == Message.STATUS_ERROR
                            ? Icon(
                                Icons.clear,
                                size: viewModel.settings.messageStatusIconsSize,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.access_time,
                                size: viewModel.settings.messageStatusIconsSize,
                                color: iconColor,
                              ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTextFieldRow() {
    return Expanded(
      child: Consumer<MessagesViewModel>(
        builder: (context, viewModel, child) => Container(
          padding: EdgeInsets.symmetric(
              horizontal:
                  viewModel.settings.messageWritingTextFieldMinHeight / 2.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                      minHeight:
                          viewModel.settings.messageWritingTextFieldMinHeight),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _messageTextFieldController,
                      maxLines: null,
                      enabled: viewModel.state !=
                              MessagesViewState.LoadingFirstQuery &&
                          viewModel.state != MessagesViewState.Error,
                      decoration: InputDecoration(
                        hintText: viewModel.languageSettings.typeMessage,
                        border: InputBorder.none,
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
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                  viewModel.settings.messageWritingTextFieldMinHeight / 2.0),
            ),
            color: Colors.white,
          ),
          /*decoration: ShapeDecoration(
          shape: StadiumBorder(),
          color: Colors.white,
        ),*/
        ),
      ),
    );
  }

  Widget _buildCircularButton() {
    return Consumer<MessagesViewModel>(
      builder: (context, viewModel, child) => Container(
        width: viewModel.settings.messageWritingTextFieldMinHeight,
        height: viewModel.settings.messageWritingTextFieldMinHeight,
        child: RawMaterialButton(
          fillColor: viewModel.settings.sendMessageButtonColor,
          shape: CircleBorder(),
          child: Icon(
            Icons.send,
            color: Colors.white,
          ),
          onPressed: () {
            String messageBody = _messageTextFieldController.text;
            _messageTextFieldController.clear();
            viewModel.sendMessage(messageBody);
          },
        ),
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

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (mounted) {
        Provider.of<MessagesViewModel>(context, listen: false)
            .getMessagesWithPagination();
      }
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
