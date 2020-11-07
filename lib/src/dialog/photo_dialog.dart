import 'dart:io';

import 'package:flutter/material.dart';

class PhotoDialog extends StatelessWidget{
  final File imageFile;
  final String sendButtonText;
  final String cancelButtonText;
  final IconData icon;
  final String titleText;
  final double maxImageWidth;

  PhotoDialog({
    @required this.imageFile,
    @required this.sendButtonText,
    @required this.cancelButtonText,
    this.icon,
    this.titleText = '',
    this.maxImageWidth = 400.0,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: titleText.trim().isNotEmpty
          ? Row(
        children: <Widget>[
          if (icon != null) Icon(icon),
          if (icon != null) SizedBox(width: 16.0),
          Text(
            titleText,
          ),
        ],
      )
          : null,
      content: LimitedBox(
        maxWidth: maxImageWidth,
        child: Image.file(imageFile),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(cancelButtonText),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: Text(sendButtonText),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
