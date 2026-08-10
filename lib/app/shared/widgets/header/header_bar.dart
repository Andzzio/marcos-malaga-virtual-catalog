import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/search_head_bar.dart';

class HeaderBar extends StatelessWidget {
  final bool colorLerp;
  const HeaderBar({super.key, this.colorLerp = true});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: HeaderBarDelegate(colorLerp: colorLerp),
    );
  }
}

class HeaderBarDelegate extends SliverPersistentHeaderDelegate {
  final bool colorLerp;
  const HeaderBarDelegate({required this.colorLerp});
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(overlayColor: Colors.grey),
                    child: Text(
                      'INICIO',
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: textColor),
                    ),
                    onPressed: () {
                      context.go('/');
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(overlayColor: Colors.grey),
                    child: Text(
                      'NUEVOS INGRESOS',
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: textColor),
                    ),
                    onPressed: () {
                      context.go('/search/new-arrivals');
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(overlayColor: Colors.grey),
                    child: Text(
                      'CATÁLOGO',
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: textColor),
                    ),
                    onPressed: () {
                      context.go('/search/catalog');
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(overlayColor: Colors.grey),
                    child: Text(
                      'TALLAS XL',
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: textColor),
                    ),
                    onPressed: () {
                      context.go('/search/xl-sizes');
                    },
                  ),
                ],
              ),
            ),
            Row(
              spacing: 20,
              children: [
                Text(
                  'MARCOS MALAGA',
                  style: Theme.of(
                    context,
                  ).textTheme.displayLarge?.copyWith(color: titleColor),
                ),
                Spacer(),
                SearchHeadBar(progress: progress),
                IconButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  icon: FaIcon(
                    FontAwesomeIcons.user,
                    color: textColor,
                    size: 18,
                  ),
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
