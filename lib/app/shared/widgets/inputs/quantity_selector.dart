import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: ResponsiveTheme.isMobile(context)
            ? const EdgeInsets.symmetric(horizontal: 0, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            IconButton(
              iconSize: ResponsiveTheme.isMobile(context) ? 11 : 14,
              color: Theme.of(context).colorScheme.secondary,
              icon: const FaIcon(FontAwesomeIcons.minus),
              onPressed: onDecrement,
            ),
            Expanded(
              child: Text(
                quantity.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: ResponsiveTheme.isMobile(context) ? 11 : 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            IconButton(
              iconSize: ResponsiveTheme.isMobile(context) ? 11 : 14,
              color: Theme.of(context).colorScheme.secondary,
              icon: const FaIcon(FontAwesomeIcons.plus),
              onPressed: onIncrement,
            ),
          ],
        ),
      ),
    );
  }
}
