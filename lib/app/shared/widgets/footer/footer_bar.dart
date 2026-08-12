import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/business_info_section.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/legal_section.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/newsletter_section.dart';

class FooterBar extends StatelessWidget {
  const FooterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: primaryColor),
            child: Padding(
              padding:
                  ResponsiveTheme.isMobile(context) ||
                      ResponsiveTheme.isTablet(context)
                  ? EdgeInsetsGeometry.symmetric(horizontal: 20, vertical: 50)
                  : EdgeInsetsGeometry.symmetric(horizontal: 100, vertical: 50),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: Colors.white),
                child: ResponsiveTheme.isMobile(context)
                    ? Column(
                        spacing: 50,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BusinessInfoSection(),
                          NewsletterSection(),
                          LegalSection(),
                        ],
                      )
                    : ResponsiveTheme.isTablet(context)
                    ? Row(
                        spacing: 50,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            spacing: 50,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BusinessInfoSection(),
                              NewsletterSection(),
                            ],
                          ),
                          Column(
                            spacing: 50,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [LegalSection()],
                          ),
                        ],
                      )
                    : Row(
                        spacing: 50,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BusinessInfoSection(),
                          NewsletterSection(),
                          LegalSection(),
                        ],
                      ),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Padding(
              padding: ResponsiveTheme.isMobile(context)
                  ? const EdgeInsetsGeometry.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    )
                  : const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
              child: Row(
                children: [
                  Text(
                    '© 2026 Marcos Malaga',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(fontSize: 15),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.facebook),
                        iconSize: 18,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.instagram),
                        iconSize: 18,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.tiktok),
                        iconSize: 18,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (ResponsiveTheme.isMobile(context)) const SliverGap(60),
      ],
    );
  }
}
