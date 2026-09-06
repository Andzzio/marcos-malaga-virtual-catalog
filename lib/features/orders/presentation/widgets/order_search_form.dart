import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OrderSearchForm extends StatefulWidget {
  const OrderSearchForm({super.key});

  @override
  State<OrderSearchForm> createState() => _OrderSearchFormState();
}

class _OrderSearchFormState extends State<OrderSearchForm> {
  final _orderCodeController = TextEditingController();

  @override
  void dispose() {
    _orderCodeController.dispose();
    super.dispose();
  }

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
        Text('RASTREAR PEDIDO', style: titleStyle, textAlign: TextAlign.center),
        const Gap(24),
        TextFormField(
          controller: _orderCodeController,
          decoration: InputDecoration(
            labelText: 'Código de Pedido',
            labelStyle: baseTextStyle,
            border: const OutlineInputBorder(),
          ),
          style: baseTextStyle,
        ),
        const Gap(24),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          child: Text(
            'BUSCAR',
            style: baseTextStyle?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
