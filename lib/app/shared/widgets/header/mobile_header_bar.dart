import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';

class MobileHeaderBar extends StatelessWidget {
  final bool colorLerp;
  const MobileHeaderBar({super.key, this.colorLerp = true});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: MobileHeaderBarDelegate(colorLerp: colorLerp, context: context),
    );
  }
}

class MobileHeaderBarDelegate extends SliverPersistentHeaderDelegate {
  final bool colorLerp;
  final BuildContext context;
  const MobileHeaderBarDelegate({
    required this.colorLerp,
    required this.context,
  });
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    double progress = colorLerp
        ? (shrinkOffset / (maxExtent)).clamp(0.0, 1.0)
        : 1.0;
    Color? bgColor = Color.lerp(
      Colors.transparent,
      Theme.of(context).colorScheme.surface,
      progress,
    );
    Color? titleColor = Color.lerp(
      Theme.of(context).colorScheme.surface,
      Theme.of(context).colorScheme.primary,
      progress,
    );
    return Container(
      height: maxExtent,
      decoration: BoxDecoration(color: bgColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'MARCOS MALAGA',
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(color: titleColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => ResponsiveTheme.isMobile(context) ? 60 : 75;

  @override
  double get minExtent => ResponsiveTheme.isMobile(context) ? 60 : 75;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
