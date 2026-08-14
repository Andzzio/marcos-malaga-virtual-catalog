import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class BackScreenButton extends StatelessWidget {
  final String label;
  const BackScreenButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 16);
    return Row(
      spacing: 10,
      children: [
        IconButton(
          icon: FaIcon(FontAwesomeIcons.arrowLeft, size: 15),
          onPressed: () {
            context.pop();
          },
        ),
        Text(label, style: style),
      ],
    );
  }
}
