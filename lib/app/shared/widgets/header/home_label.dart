import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';

class HomeLabel extends StatelessWidget {
  final String label;
  const HomeLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontSize: ResponsiveTheme.isMobile(context) ? 14 : 18,
            ),
          ),
        ),
      ),
    );
  }
}
