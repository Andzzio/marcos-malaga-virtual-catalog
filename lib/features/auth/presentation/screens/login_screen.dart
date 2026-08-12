import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/footer_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/header_bar.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/mobile_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/tablet_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
        ResponsiveTheme.isMobile(context)
            ? MobileHeaderBar(colorLerp: false)
            : ResponsiveTheme.isTablet(context)
                ? const TabletHeaderBar(colorLerp: false)
                : const HeaderBar(colorLerp: false),
        SliverFillRemaining(
          child: Center(
            child: Text('Login Screen', style: const TextStyle(fontSize: 24)),
          ),
        ),
        SliverGap(50),
        FooterBar(),
      ],
    );
  }
}
