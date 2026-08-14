import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceFilter extends StatelessWidget {
  final TextEditingController minController;
  final TextEditingController maxController;
  final ValueChanged<String> onMinSubmitted;
  final ValueChanged<String> onMaxSubmitted;
  final TextStyle? style;

  const PriceFilter({
    super.key,
    required this.minController,
    required this.maxController,
    required this.onMinSubmitted,
    required this.onMaxSubmitted,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                onMinSubmitted(minController.text);
              }
            },
            child: TextField(
              controller: minController,
              style: style,
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              decoration: const InputDecoration(
                hintText: '0.0',
                prefixText: 'S/. ',
                hintTextDirection: TextDirection.rtl,
              ),
              onSubmitted: onMinSubmitted,
            ),
          ),
        ),
        Text(' a ', style: style),
        Expanded(
          child: Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                onMaxSubmitted(maxController.text);
              }
            },
            child: TextField(
              controller: maxController,
              style: style,
              textAlign: TextAlign.right,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              decoration: const InputDecoration(
                hintText: '0.0',
                prefixText: 'S/.',
                hintTextDirection: TextDirection.rtl,
              ),
              onSubmitted: onMaxSubmitted,
            ),
          ),
        ),
      ],
    );
  }
}
