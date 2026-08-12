import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_card.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/title_section.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ProductGrid<T extends AsyncNotifier<List<ProductEntity>>>
    extends ConsumerWidget {
  final int itemCount;
  final AsyncNotifierProvider<T, List<ProductEntity>> productsProvider;
  final TitleSection? titleSection;
  final double maxWidth;
  const ProductGrid({
    super.key,
    required this.itemCount,
    required this.productsProvider,
    this.titleSection,
    this.maxWidth = double.infinity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    return SliverMainAxisGroup(
      slivers: [
        if (titleSection != null)
          SliverToBoxAdapter(
            child: Align(
              alignment:
                  titleSection?.crossAxisAlignment == CrossAxisAlignment.start
                  ? Alignment.centerLeft
                  : Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: titleSection,
              ),
            ),
          ),
        SliverCrossAxisConstrained(
          maxCrossAxisExtent: maxWidth,
          child: SliverPadding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
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
                return productsAsync.when(
                  data: (products) {
                    final product = products[index];
                    return ProductCard(product: product);
                  },
                  error: (error, stackTrace) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Center(
                          child: FaIcon(FontAwesomeIcons.circleXmark),
                        ),
                      ),
                    );
                  },
                  loading: () {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
