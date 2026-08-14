import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:popover/popover.dart';

class ConsumerPopOverWidget extends StatelessWidget {
  final String label;
  final Widget Function(BuildContext context, WidgetRef ref) bodyBuilder;
  const ConsumerPopOverWidget({super.key, required this.bodyBuilder, this.label = ''});

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
          bodyBuilder: (context) => Consumer(
            builder: (context, ref, child) => ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 250),
              child: bodyBuilder(context, ref),
            ),
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
