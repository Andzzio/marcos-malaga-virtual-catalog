import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';

class ProductGridShimmer extends StatelessWidget {
  final int itemCount;
  final double maxWidth;

  const ProductGridShimmer({
    super.key,
    this.itemCount = 20,
    this.maxWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverCrossAxisConstrained(
          maxCrossAxisExtent: maxWidth,
          child: SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverGrid.builder(
              itemCount: itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    ResponsiveTheme.isMobile(context) ||
                        ResponsiveTheme.isTablet(context)
                    ? 2
                    : 4,
                mainAxisSpacing: 60,
                crossAxisSpacing: 15,
                childAspectRatio: 0.55,
              ),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
