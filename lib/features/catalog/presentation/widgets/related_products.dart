import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_grid.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/title_section.dart';

class RelatedProducts extends StatelessWidget {
  const RelatedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 100, vertical: 10),
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
