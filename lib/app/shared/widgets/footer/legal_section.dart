import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LegalSection extends StatelessWidget {
  const LegalSection({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(color: Colors.white, fontSize: 14);
    final titleStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Legal', style: titleStyle),
        Gap(10),
        TextButton(
          onPressed: () {
            context.go('/legal/privacy-policy');
          },
          style: TextButton.styleFrom(padding: EdgeInsetsGeometry.zero),
          child: Text('Política de Privacidad', style: style),
        ),
        Gap(10),
        TextButton(
          onPressed: () {
            context.go('/legal/refund-policy');
          },
          style: TextButton.styleFrom(padding: EdgeInsetsGeometry.zero),
          child: Text('Política de Reembolso', style: style),
        ),
        Gap(10),
        TextButton(
          onPressed: () {
            context.go('/legal/shipping-policy');
          },
          style: TextButton.styleFrom(padding: EdgeInsetsGeometry.zero),
          child: Text('Política de Envío', style: style),
        ),
        Gap(10),
        TextButton(
          onPressed: () {
            context.go('/legal/terms');
          },
          style: TextButton.styleFrom(padding: EdgeInsetsGeometry.zero),
          child: Text('Términos del servicio', style: style),
        ),
        Gap(10),
        TextButton(
          onPressed: () {
            context.go('/legal/complaints-book');
          },
          style: TextButton.styleFrom(padding: EdgeInsetsGeometry.zero),
          child: Text('Libro de Reclamaciones', style: style),
        ),
      ],
    );
  }
}
