import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String path;
  final BoxFit? fit;
  final double? width;
  final double? height;

  const CustomImage(this.path, {super.key, this.fit, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Image.asset(path, fit: fit, width: width, height: height);
  }
}
