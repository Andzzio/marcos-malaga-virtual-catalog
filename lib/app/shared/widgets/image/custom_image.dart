import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

enum ImageQuality { thumbnail, highRes }

class CustomImage extends StatelessWidget {
  final String path;
  final BoxFit? fit;
  final double? width;
  final double? height;
  final Alignment alignment;
  final bool isAsset;
  final ImageQuality quality;

  const CustomImage(
    this.path, {
    super.key,
    this.fit,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.isAsset = false,
    this.quality = ImageQuality.highRes,
  });

  @override
  Widget build(BuildContext context) {
    if (isAsset || !path.startsWith('http')) {
      return Image.asset(
        path,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          width: width,
          height: height,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }

    String imageUrl = path;
    if (quality == ImageQuality.thumbnail) {
      imageUrl = path
          .replaceAll('_800x800', '_200x200')
          .replaceAll('_original', '_800');
    }

    if (imageUrl.isEmpty) {
      return Container(
        color: Colors.grey[200],
        width: width,
        height: height,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    if (kIsWeb) {
      return Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              color: Colors.white,
              width: width,
              height: height,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          width: width,
          height: height,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          color: Colors.white,
          width: width,
          height: height,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[200],
        width: width,
        height: height,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }
}
