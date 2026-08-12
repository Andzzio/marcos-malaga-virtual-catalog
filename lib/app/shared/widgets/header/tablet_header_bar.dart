import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class TabletHeaderBar extends StatelessWidget {
  final bool colorLerp;
  const TabletHeaderBar({super.key, this.colorLerp = true});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: TabletHeaderBarDelegate(colorLerp: colorLerp),
    );
  }
}

class TabletHeaderBarDelegate extends SliverPersistentHeaderDelegate {
  final bool colorLerp;
  const TabletHeaderBarDelegate({required this.colorLerp});
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
    Color? textColor = Color.lerp(
      Theme.of(context).colorScheme.surface,
      Colors.black,
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
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Row(
          spacing: 20,
          children: [
            Text(
              'MARCOS MALAGA',
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(color: titleColor),
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                context.go('/search');
              },
              icon: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: textColor,
                size: 18,
              ),
            ),
            IconButton(
              onPressed: () {
                context.go('/login');
              },
              icon: FaIcon(FontAwesomeIcons.user, color: textColor, size: 18),
            ),
            IconButton(
              onPressed: () {},
              icon: FaIcon(
                FontAwesomeIcons.cartShopping,
                color: textColor,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 75;

  @override
  double get minExtent => 75;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
