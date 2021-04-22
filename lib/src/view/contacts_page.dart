import 'package:c_messaging/src/custom_widgets/no_message_background.dart';
import 'package:c_messaging/src/custom_widgets/profile_photo.dart';
import 'package:c_messaging/src/custom_widgets/shimmer.dart';
import 'package:c_messaging/src/model/message.dart';
import 'package:c_messaging/src/view_model/contacts_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

class MessageContactsPage extends StatefulWidget {
  @override
  _MessageContactsPageState createState() => _MessageContactsPageState();
}

class _MessageContactsPageState extends State<MessageContactsPage> {
  ScrollController _controller = ScrollController();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    _controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: Text(viewModel.settings.contactsPageTitle),
          backgroundColor: viewModel.settings.toolbarColor,
        ),
        body: _buildBody(context),
      ),
    ); //ShimmerView(photoRadius: widget.contactProfilePhotoRadius));
  }

  Widget _buildBody(BuildContext context) {
    ContactsViewModel viewModel = Provider.of<ContactsViewModel>(context);
    if (viewModel.state == ContactsViewState.Idle && viewModel.hasMessage()) {
      return _buildListView();
    } else if (viewModel.state == ContactsViewState.Idle &&
        !viewModel.hasMessage()) {
      return _buildNoMessageBody();
    } else if (viewModel.state == ContactsViewState.Error) {
      return _buildErrorBody();
    } else {
      return _buildShimmer();
    }
  }

  Widget _buildNoMessageBody() {
    return Consumer<ContactsViewModel>(
      builder: (context, viewModel, child) => NoMessageBackground(
        assetImagePath: viewModel.settings.noMessageAssetImagePath,
        textContent: viewModel.settings.noMessageTextContent,
        imageWidth: viewModel.settings.noMessageImageWidth,
        textSize: viewModel.settings.noMessageTextSize,
      ),
    );
  }

  Widget _buildErrorBody() {
    return Center(
      child: Consumer<ContactsViewModel>(
        builder: (context, viewModel, child) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              iconSize: 36.0,
              onPressed: () {
                viewModel.refreshContacts();
              },
            ),
            SizedBox(height: 18.0),
            Text(
              viewModel.settings.errorTryAgainMessage,
              style:
                  TextStyle(fontSize: viewModel.settings.errorMessageTextSize),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.white,
          child: _buildListTileView(index, true),
        );
      },
    );
  }

  Widget _buildListView() {
    return Consumer<ContactsViewModel>(
      builder: (context, viewModel, child) => RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          viewModel.refreshContacts();
        },
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller,
          itemCount: viewModel.messages.length,
          itemBuilder: _buildListTile,
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, int index) {
    return _buildListTileView(index, false);
  }

  Widget _buildListTileView(int index, bool isShimmer) {
    return Consumer<ContactsViewModel>(
      builder: (context, viewModel, child) {
        Message? message = viewModel.getMessageWithIndex(index);
        return message != null
            ? InkWell(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: viewModel.settings.paddingTop,
                        bottom: viewModel.settings.paddingBottom,
                        left: viewModel.settings.paddingLeft,
                        right: viewModel.settings.paddingRight,
                      ),
                      child: Container(
                        height: viewModel.settings.profilePhotoRadius,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            if (viewModel.settings.showContactProfilePhoto)
                              ProfilePhoto(
                                photo: isShimmer
                                    ? ProfilePhoto.SHIMMER_EFFECT
                                    : message.contactUser?.profilePhotoUrl ??
                                        "",
                                placeholderImagePath: viewModel
                                    .settings.profilePhotoPlaceholderPath,
                                radius: viewModel.settings.profilePhotoRadius,
                                backgroundColor: viewModel
                                    .settings.profilePhotoBackgroundColor,
                              ),
                            SizedBox(
                                width: viewModel
                                    .settings.profilePhotoAndTextsSpaceBetween),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: isShimmer
                                            ? _shimmerContainer(128.0, 8.0,
                                                32.0, Colors.grey[400]!)
                                            : Text(
                                                message.contactUser?.username
                                                        .trim() ??
                                                    viewModel.settings
                                                        .defaultUsername,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: viewModel.settings
                                                      .usernameFontSize,
                                                  color: viewModel.settings
                                                      .usernameTextColor,
                                                ),
                                              ),
                                      ),
                                      isShimmer
                                          ? _shimmerContainer(64.0, 8.0, 32.0,
                                              Colors.grey[400]!)
                                          : Text(
                                              viewModel.getMessageDateText(
                                                context,
                                                index,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: viewModel.settings
                                                    .messageDateFontSize,
                                                color: viewModel.settings
                                                    .messageDateTextColor,
                                              ),
                                            ),
                                    ],
                                  ),
                                  isShimmer
                                      ? _shimmerContainer(double.infinity, 8.0,
                                          32.0, Colors.grey[400]!)
                                      : _buildLastMessageRow(message),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (viewModel.settings.showDivider)
                      Padding(
                        padding: EdgeInsets.only(
                          left: viewModel.settings.showContactProfilePhoto
                              ? viewModel.settings.paddingLeft +
                                  viewModel.settings.profilePhotoRadius +
                                  viewModel
                                      .settings.profilePhotoAndTextsSpaceBetween
                              : viewModel.settings.paddingLeft +
                                  viewModel.settings
                                      .profilePhotoAndTextsSpaceBetween,
                          right: viewModel.settings.paddingRight,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: viewModel.settings.dividerHeight,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  viewModel.openMessagesPage(context, index);
                },
                //onLongPress: () => _onListTileLongPressed(context, index),
              )
            : Container();
      },
    );
  }

  Widget _buildLastMessageRow(Message message) {
    return Consumer<ContactsViewModel>(
      builder: (context, viewModel, child) => Row(
        children: <Widget>[
          if (viewModel.isUserSender(message))
            Container(
              margin: EdgeInsets.only(right: 2.0),
              child: Icon(
                message.status == Message.STATUS_WAITING
                    ? Icons.access_time
                    : message.status == Message.STATUS_SENT
                        ? Icons.check
                        : message.status == Message.STATUS_ERROR
                            ? Icons.clear
                            : Icons.access_time,
                size: viewModel.settings.lastMessageFontSize,
                color: viewModel.settings.lastMessageTextColor,
              ),
            ),
          Expanded(
            child: Text(
              message.messageType == Message.MESSAGE_TYPE_IMAGE
                  ? viewModel.settings.imageTypeText
                  : message.messageBody,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: viewModel.settings.lastMessageFontSize,
                color: viewModel.settings.lastMessageTextColor,
                fontStyle: message.messageType == Message.MESSAGE_TYPE_IMAGE
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerContainer(
      double width, double height, double radius, Color color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(radius))),
    );
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      if (mounted) {
        Provider.of<ContactsViewModel>(context, listen: false)
            .getMessagesWithPagination();
      }
    }
  }
}
