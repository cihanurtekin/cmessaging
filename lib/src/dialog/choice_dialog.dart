import 'package:flutter/material.dart';

class ChoiceDialog extends StatelessWidget {
  final IconData? icon;
  final String titleText;
  final String contentText;
  final String acceptButtonText;
  final String cancelButtonText;

  ChoiceDialog({
    this.icon,
    this.titleText = '',
    this.contentText = '',
    required this.acceptButtonText,
    required this.cancelButtonText,
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
      content: contentText.trim().isNotEmpty
          ? Text(
        contentText,
      )
          : null,
      actions: <Widget>[
        TextButton(
          child: Text(cancelButtonText),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: Text(acceptButtonText),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
