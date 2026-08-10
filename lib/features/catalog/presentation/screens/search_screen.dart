import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/footer_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/header_bar.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/mobile_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const HomeLabel(label: 'NUESTROS CATÁLOGOS'),
        ResponsiveTheme.isMobile(context)
            ? const MobileHeaderBar(colorLerp: false)
            : const HeaderBar(colorLerp: false),
        const SliverFillRemaining(
          child: Center(
            child: Text('Search Screen', style: TextStyle(fontSize: 24)),
          ),
        ),
        const SliverGap(50),
        const FooterBar(),
      ],
    );
  }
}
