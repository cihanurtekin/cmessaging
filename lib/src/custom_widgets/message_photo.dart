import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessagePhoto extends StatelessWidget {
  final String placeholderImagePath;
  final String photo;

  MessagePhoto({
    required this.photo,
    required this.placeholderImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCachedNetworkImage();
  }

  Widget _buildCachedNetworkImage() {
    return CachedNetworkImage(
      imageUrl: photo,
      placeholder: (context, url) => Container(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Image.asset(
        placeholderImagePath,
      ),
    );
  }


}
