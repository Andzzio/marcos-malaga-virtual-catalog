import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class CatalogChip extends StatelessWidget {
  final String label;
  final FaIconData iconData;
  final VoidCallback onPressed;
  const CatalogChip({
    super.key,
    required this.label,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 14);
    return SliverToBoxAdapter(
      child: Column(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onPressed,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(child: FaIcon(iconData, color: Colors.white)),
              ),
            ),
          ),
          Gap(10),
          Text(label, style: style),
        ],
      ),
    );
  }
}

class CatalogChipData {
  final String label;
  final FaIconData iconData;
  final VoidCallback onPressed;
  const CatalogChipData({
    required this.label,
    required this.iconData,
    required this.onPressed,
  });
}
