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
    if (isAsset) {
      return Image.asset(
        path,
        fit: fit,
        width: width,
        height: height,
        alignment: alignment,
      );
    }

    String imageUrl = path;
    if (quality == ImageQuality.thumbnail) {
      imageUrl = path.replaceAll('_800x800', '_200x200');
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
