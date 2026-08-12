import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gap/gap.dart';

class ProductViewSkeleton extends StatelessWidget {
  final double maxWidth;
  
  const ProductViewSkeleton({
    super.key,
    this.maxWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return SliverToBoxAdapter(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ResponsiveTheme.isMobile(context)
              ? Column(
                  spacing: 30,
                  children: [
                    SizedBox(
                      height: size.height,
                      child: _buildImageSkeleton(context),
                    ),
                    _buildDetailSkeleton(context),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 11,
                      child: SizedBox(
                        height: size.height,
                        child: _buildImageSkeleton(context),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: SizedBox(
                        height: size.height,
                        child: _buildDetailSkeleton(context),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildImageSkeleton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;
    
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  Widget _buildDetailSkeleton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    Widget skeletonBox({double? width, double? height}) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                skeletonBox(height: 30, width: 250),
                const Gap(10),
                skeletonBox(height: 30, width: 200),
                const Gap(30),
                
                // Price
                skeletonBox(height: 25, width: 100),
                const Gap(30),
                
                // Availability
                skeletonBox(height: 20, width: 150),
                const Gap(20),
                
                // Divider
                skeletonBox(height: 1, width: double.infinity),
                const Gap(20),
                
                // Button Tabla Medidas
                skeletonBox(height: 40, width: 200),
                const Gap(50),
                
                // Design Selector (Color/Size)
                skeletonBox(height: 20, width: 120),
                const Gap(10),
                Row(
                  children: [
                    skeletonBox(height: 40, width: 40),
                    const Gap(10),
                    skeletonBox(height: 40, width: 40),
                    const Gap(10),
                    skeletonBox(height: 40, width: 40),
                  ],
                ),
                const Gap(20),
                skeletonBox(height: 20, width: 100),
                const Gap(10),
                Row(
                  children: [
                    skeletonBox(height: 40, width: 50),
                    const Gap(10),
                    skeletonBox(height: 40, width: 50),
                    const Gap(10),
                    skeletonBox(height: 40, width: 50),
                  ],
                ),
                const Gap(50),
                
                // Add to Cart / Buy Now Buttons
                skeletonBox(height: 50, width: double.infinity),
                const Gap(10),
                skeletonBox(height: 50, width: double.infinity),
                const Gap(50),
                
                // Description Expansion Tile
                skeletonBox(height: 50, width: double.infinity),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
