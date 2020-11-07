import 'package:flutter/material.dart';

class NoMessageBackground extends StatelessWidget {
  final String assetImagePath;
  final String textContent;
  final double imageWidth;
  final double textSize;

  NoMessageBackground({
    @required this.assetImagePath,
    @required this.textContent,
    @required this.imageWidth,
    @required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (assetImagePath.trim().isNotEmpty)
            Image.asset(
              assetImagePath,
              width: imageWidth,
            ),
          if (assetImagePath.trim().isNotEmpty && textContent.trim().isNotEmpty)
            SizedBox(height: 16.0),
          if (textContent.trim().isNotEmpty)
            Text(
              textContent,
              style: TextStyle(fontSize: textSize),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
