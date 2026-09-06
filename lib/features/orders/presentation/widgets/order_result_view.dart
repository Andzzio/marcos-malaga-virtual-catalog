import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class OrderResultView extends StatelessWidget {
  const OrderResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextStyle = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ESTADO DEL PEDIDO',
          style: titleStyle,
          textAlign: TextAlign.center,
        ),
        const Gap(24),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                FaIcon(FontAwesomeIcons.magnifyingGlass, size: 14),
                Text('Escriba su número de orden', style: baseTextStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
