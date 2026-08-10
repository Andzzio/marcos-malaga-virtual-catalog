import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_grid.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/title_section.dart';

class RelatedProducts extends StatelessWidget {
  const RelatedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: ResponsiveTheme.isMobile(context)
          ? EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10)
          : EdgeInsetsGeometry.symmetric(horizontal: 100, vertical: 10),
      sliver: ProductGrid<ProductsProvider>(
        titleSection: TitleSection(
          bottomLabel: 'PRODUCTOS QUE TE PODRÍAN INTERESAR:',
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        itemCount: 4,
        productsProvider: productsProvider,
      ),
    );
  }
}
