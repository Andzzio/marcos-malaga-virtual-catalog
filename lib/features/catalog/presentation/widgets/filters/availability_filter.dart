import 'package:flutter/material.dart';

class AvailabilityFilter extends StatelessWidget {
  final bool showInStock;
  final bool showOutOfStock;
  final ValueChanged<bool?> onInStockChanged;
  final ValueChanged<bool?> onOutStockChanged;
  final TextStyle? style;

  const AvailabilityFilter({
    super.key,
    required this.showInStock,
    required this.showOutOfStock,
    required this.onInStockChanged,
    required this.onOutStockChanged,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: showInStock,
          onChanged: onInStockChanged,
          title: Text('En existencia', style: style),
          dense: true,
        ),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          value: showOutOfStock,
          onChanged: onOutStockChanged,
          title: Text('Agotado', style: style),
          dense: true,
        ),
      ],
    );
  }
}
