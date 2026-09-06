import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/footer_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/mobile_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/tablet_header_bar.dart';
import 'package:marcos_malaga_app/features/legal/presentation/widgets/legal_document_view.dart';

class ShippingPolicyScreen extends StatelessWidget {
  const ShippingPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
        ResponsiveTheme.isMobile(context)
            ? const MobileHeaderBar(colorLerp: false)
            : ResponsiveTheme.isTablet(context)
            ? const TabletHeaderBar(colorLerp: false)
            : const HeaderBar(colorLerp: false),
        const LegalDocumentView(documentId: 'shipping_policy'),
        const SliverGap(50),
        const FooterBar(),
      ],
    );
  }
}
