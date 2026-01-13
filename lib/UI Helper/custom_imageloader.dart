import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'colors.dart'; // Assuming AppColors is defined here

typedef CustomImageProvider = CachedNetworkImageProvider;

class CustomImageLoader extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  const CustomImageLoader({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Detect network URLs vs local file paths
    final trimmed = imageUrl.trim();
    final isNetwork = RegExp(
      r'^https?://',
      caseSensitive: false,
    ).hasMatch(trimmed);
    final isFilePath =
        trimmed.isNotEmpty &&
        (trimmed.startsWith('/') || // Android absolute path like /data/...
            trimmed.startsWith('file://') || // file URI
            RegExp(r'^[a-zA-Z]:\\').hasMatch(
              trimmed,
            ) // Windows drive letter e.g. C:\
            );

    Widget child;

    if (isNetwork) {
      child = CachedNetworkImage(
        imageUrl: trimmed,
        fit: fit,
        width: width,
        height: height,
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder:
            (context, url) => Container(
              width: width,
              height: height,
              color: AppColors.greyVeryLight,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
        errorWidget: (context, url, error) => _errorWidget(),
      );
    } else if (isFilePath) {
      // Normalize file:// URIs to a local path
      String path = trimmed;
      if (path.startsWith('file://')) path = path.replaceFirst('file://', '');

      final file = File(path);
      child = Image.file(
        file,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => _errorWidget(),
      );
    } else if (trimmed.isEmpty) {
      child = Container(
        width: width,
        height: height,
        color: AppColors.greyVeryLight,
      );
    } else {
      // Fallback: attempt network load if it looks like a URL, otherwise show error
      child = _errorWidget();
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: child,
    );
  }

  Widget _errorWidget() {
    return Container(
      width: width,
      height: height,
      color: AppColors.greyVeryLight,
      child: Icon(
        Icons.broken_image,
        color: AppColors.disabled,
        size:
            width != null && height != null
                ? (width! < height! ? width! : height!) * 0.5
                : 24,
      ),
    );
  }
}
