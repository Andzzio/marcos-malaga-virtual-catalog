import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/bottom/bottom_bar.dart';

import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveTheme.isMobile(context);
    return Scaffold(
      extendBody: isMobile,
      floatingActionButton: isMobile ? _buildFab(context) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: isMobile
          ? BottomBar(navigationShell: navigationShell)
          : null,
      body: navigationShell,
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: const CircleBorder(),
      onPressed: () {},
      child: const FaIcon(FontAwesomeIcons.cartShopping, color: Colors.white),
    );
  }
}
