import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/footer_bar.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/single_product_provider.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/related_products.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_view.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/header_bar.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/mobile_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/tablet_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';
import 'package:marcos_malaga_app/app/shared/widgets/skeletons/product_view_skeleton.dart';
import 'package:marcos_malaga_app/app/shared/widgets/placeholders/sliver_empty_placeholder.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  final ProductEntity? product;
  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (product != null) {
      return _buildUI(context, product: product!);
    }
    final productAsync = ref.watch(singleProductProvider(productId));
    return productAsync.when(
      data: (product) {
        if (product == null) return _buildProductNotFound(context);
        return _buildUI(context, product: product);
      },
      loading: () => _buildLoadingUI(context),
      error: (error, stacktrace) => _buildProductNotFound(context),
    );
  }
}

Widget _buildUI(BuildContext context, {required ProductEntity product}) {
  return CustomScrollView(
    slivers: [
      HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
      ResponsiveTheme.isMobile(context)
          ? MobileHeaderBar(colorLerp: false)
          : ResponsiveTheme.isTablet(context)
              ? const TabletHeaderBar(colorLerp: false)
              : HeaderBar(colorLerp: false),
      ProductView(product: product),
      SliverGap(30),
      RelatedProducts(),
      SliverGap(50),
      FooterBar(),
    ],
  );
}

Widget _buildLoadingUI(BuildContext context) {
  return CustomScrollView(
    slivers: [
      HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
      ResponsiveTheme.isMobile(context)
          ? MobileHeaderBar(colorLerp: false)
          : ResponsiveTheme.isTablet(context)
              ? const TabletHeaderBar(colorLerp: false)
              : HeaderBar(colorLerp: false),
      ProductViewSkeleton(),
      SliverGap(30),
      RelatedProducts(),
      SliverGap(50),
      FooterBar(),
    ],
  );
}

Widget _buildProductNotFound(BuildContext context) {
  return CustomScrollView(
    slivers: [
      HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
      ResponsiveTheme.isMobile(context)
          ? MobileHeaderBar(colorLerp: false)
          : ResponsiveTheme.isTablet(context)
              ? const TabletHeaderBar(colorLerp: false)
              : HeaderBar(colorLerp: false),
      SliverEmptyPlaceholder(message: 'Producto no encontrado'),
      SliverGap(50),
      FooterBar(),
    ],
  );
}
