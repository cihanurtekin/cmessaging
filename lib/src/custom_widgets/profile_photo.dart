import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePhoto extends StatelessWidget {
  static const String SHIMMER_EFFECT = 'shimmer_effect';

  final String placeholderImagePath;
  final String photo;
  final double radius;
  final Color backgroundColor;

  ProfilePhoto({
    required this.photo,
    required this.placeholderImagePath,
    required this.radius,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: photo == SHIMMER_EFFECT
          ? Container(
        width: radius,
        height: radius,
        color: backgroundColor,
      )
          : //_buildFadeInImage()

      _buildCachedNetworkImage(),
    );
  }

  Widget _buildCachedNetworkImage() {
    return CachedNetworkImage(
      width: radius,
      height: radius,
      imageUrl: photo,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        width: radius,
        height: radius,
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => Image.asset(
        placeholderImagePath,
        width: radius,
        height: radius,
      ),
    );
  }

/*
  FadeInImage _buildFadeInImage() {
    return FadeInImage(
      width: radius,
      height: radius,
      fit: BoxFit.fill,
      placeholder: AssetImage(placeholderImagePath),
      image: photo != null && photo.isNotEmpty
          ? NetworkImage(photo)
          : AssetImage(placeholderImagePath),
    );
  }

  Container _buildContainer() {
    return Container(
      width: radius,
      height: radius,
      child: Stack(
        children: <Widget>[
          _buildImageHolder(radius),
          _buildImage(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return photo != null
        ? Container(
            width: radius,
            height: radius,
            decoration: photo == SHIMMER_EFFECT
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    color: backgroundColor,
                  )
                : photo != null && photo.trim().isNotEmpty
                    ? BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(photo),
                        ),
                      )
                    : BoxDecoration(),
          )
        : _buildImageHolder(radius);
  }


  Widget _buildImageHolder(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(placeholderImagePath),
        ),
      ),
    );
  }

   */
}
