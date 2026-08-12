import 'package:flutter/material.dart';

class SliverEmptyPlaceholder extends StatelessWidget {
  final String message;

  const SliverEmptyPlaceholder({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
