import 'package:flutter/material.dart';

class LoadingAlertDialog extends StatelessWidget {
  final String loadingText;

  const LoadingAlertDialog({
    Key? key,
    required this.loadingText,
  }) : super(key: key);

  void cancel(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(width: 12),
          Flexible(child: Text(loadingText)),
        ],
      ),
    );
  }
}
