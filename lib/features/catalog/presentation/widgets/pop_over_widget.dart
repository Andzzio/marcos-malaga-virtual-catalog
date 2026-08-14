import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:popover/popover.dart';

class PopOverWidget extends StatelessWidget {
  final String label;
  final Widget Function(BuildContext context) bodyBuilder;
  const PopOverWidget({super.key, required this.bodyBuilder, this.label = ''});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 14);
    return TextButton.icon(
      label: Text(label, style: style),
      icon: FaIcon(FontAwesomeIcons.chevronDown, size: 14),
      iconAlignment: IconAlignment.end,
      onPressed: () {
        showPopover(
          context: context,
          bodyBuilder: (context) => ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 250),
            child: bodyBuilder(context),
          ),
          direction: PopoverDirection.bottom,
          backgroundColor: Colors.white,
          arrowWidth: 0,
          arrowHeight: 0,
        );
      },
    );
  }
}
