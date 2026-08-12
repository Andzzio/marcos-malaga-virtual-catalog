import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_detail_view.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_image_view.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/title_section.dart';

class ProductView extends StatelessWidget {
  final double maxWidth;
  final TitleSection? titleSection;
  final String heroPrefix;
  const ProductView({
    super.key,
    required this.product,
    this.maxWidth = double.infinity,
    this.titleSection,
    this.heroPrefix = 'detail',
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SliverMainAxisGroup(
      slivers: [
        if (titleSection != null)
          SliverToBoxAdapter(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Center(child: titleSection),
            ),
          ),
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: ResponsiveTheme.isMobile(context)
                  ? Column(
                      spacing: 30,
                      children: [
                        SizedBox(
                          height: size.height,
                          child: ProductImageView(
                            product: product,
                            heroPrefix: heroPrefix,
                            fit: BoxFit.cover,
                          ),
                        ),
                        ProductDetailView(product: product),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 11,
                          child: SizedBox(
                            height: size.height,
                            child: ProductImageView(
                              product: product,
                              heroPrefix: heroPrefix,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: ProductDetailView(product: product),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
