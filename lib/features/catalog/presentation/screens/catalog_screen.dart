import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/footer_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/header_bar.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/mobile_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/tablet_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/filtered_products_provider.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/states/product_filters_state.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/filter_widget.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/back_screen_button.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_grid.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_grid_shimmer.dart';

class CatalogScreen extends ConsumerWidget {
  final CatalogCategory category;
  final String title;
  final String? showInStock;
  final String? showOutOfStock;
  final String? query;
  final String? categoryName;
  final String? minPrice;
  final String? maxPrice;
  final String? orderBy;
  const CatalogScreen({
    super.key,
    this.category = CatalogCategory.global,
    this.title = 'Catálogo',
    this.showInStock,
    this.showOutOfStock,
    this.query,
    this.categoryName,
    this.minPrice,
    this.maxPrice,
    this.orderBy,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredProductsProvider(category));
    final count = productsAsync.value?.length;
    return CustomScrollView(
      slivers: [
        const HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
        ResponsiveTheme.isMobile(context)
            ? MobileHeaderBar(colorLerp: false)
            : ResponsiveTheme.isTablet(context)
            ? const TabletHeaderBar(colorLerp: false)
            : const HeaderBar(colorLerp: false),
        SliverPadding(
          padding: ResponsiveTheme.isMobile(context)
              ? EdgeInsetsGeometry.symmetric(horizontal: 5)
              : EdgeInsetsGeometry.symmetric(horizontal: 20),
          sliver: SliverMainAxisGroup(
            slivers: [
              if (ResponsiveTheme.isDesktopWithLimitedSpace(context) ||
                  ResponsiveTheme.isTablet(context) ||
                  ResponsiveTheme.isMobile(context))
                SliverToBoxAdapter(child: BackScreenButton(label: title)),
              SliverToBoxAdapter(
                child: FilterWidget(
                  category: category,
                  count: count,
                  showInStock: showInStock,
                  showOutOfStock: showOutOfStock,
                  query: query,
                  categoryName: categoryName,
                  minPrice: minPrice,
                  maxPrice: maxPrice,
                  orderBy: orderBy,
                ),
              ),
              SliverGap(10),
              productsAsync.when(
                data: (products) => ProductGrid<FilteredProductsNotifier>(
                  itemCount: products.length,
                  productsProvider: filteredProductsProvider(category),
                  isCatalog: true,
                  isMobile:
                      ResponsiveTheme.isMobile(context) ||
                      ResponsiveTheme.isTablet(context) ||
                      ResponsiveTheme.isDesktopWithLimitedSpace(context),
                ),
                loading: () => const ProductGridShimmer(itemCount: 20),
                error: (error, stackTrace) => const SliverToBoxAdapter(
                  child: Center(child: Text('Error al cargar productos')),
                ),
              ),
            ],
          ),
        ),
        SliverGap(50),
        FooterBar(),
      ],
    );
  }
}
