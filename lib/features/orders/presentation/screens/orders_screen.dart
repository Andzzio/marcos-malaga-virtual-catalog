import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/footer_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/mobile_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/tablet_header_bar.dart';
import 'package:marcos_malaga_app/features/orders/presentation/widgets/order_result_view.dart';
import 'package:marcos_malaga_app/features/orders/presentation/widgets/order_search_form.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveTheme.isMobile(context);
    final isTablet = ResponsiveTheme.isTablet(context);

    Widget content = const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [OrderSearchForm(), Gap(48), OrderResultView()],
    );

    if (!isMobile && !isTablet) {
      content = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Center(child: SizedBox(width: 500, child: content)),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        const HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
        isMobile
            ? const MobileHeaderBar(colorLerp: false)
            : isTablet
            ? const TabletHeaderBar(colorLerp: false)
            : const HeaderBar(colorLerp: false),
        const SliverGap(48),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 32.0),
          sliver: SliverToBoxAdapter(child: content),
        ),
        const SliverGap(80),
        const FooterBar(),
      ],
    );
  }
}
