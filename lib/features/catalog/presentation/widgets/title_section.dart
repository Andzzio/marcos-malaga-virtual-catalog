import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TitleSection extends StatelessWidget {
  final String? topLabel;
  final String bottomLabel;
  final CrossAxisAlignment crossAxisAlignment;
  const TitleSection({
    super.key,
    this.topLabel,
    required this.bottomLabel,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (topLabel != null)
          Text(topLabel!, style: Theme.of(context).textTheme.labelMedium),
        Text(
          bottomLabel,
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 18),
        ),
        Gap(30),
      ],
    );
  }
}
