import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/footer_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/header_bar.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/mobile_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/tablet_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/search_head_bar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const HomeLabel(label: 'NUESTROS CATÁLOGOS'),
        ResponsiveTheme.isMobile(context)
            ? const MobileHeaderBar(colorLerp: false)
            : ResponsiveTheme.isTablet(context)
            ? const TabletHeaderBar(colorLerp: false)
            : const HeaderBar(colorLerp: false),
        SliverPadding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          sliver: SliverMainAxisGroup(
            slivers: [SliverToBoxAdapter(child: const SearchHeadBar())],
          ),
        ),
        const SliverGap(50),
        const FooterBar(),
      ],
    );
  }
}
