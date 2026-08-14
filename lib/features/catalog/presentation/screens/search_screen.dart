import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/core/utils/string_capitalize.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/footer_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/header_bar.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/mobile_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/tablet_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/search_head_bar.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/catalog_chip.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 15);
    List<CatalogChipData> catalogChips = [
      CatalogChipData(
        label: 'Ver Todo',
        iconData: FontAwesomeIcons.bagShopping,
        onPressed: () => context.go('/search/catalog'),
      ),
      CatalogChipData(
        label: 'Nuevos Ingresos',
        iconData: FontAwesomeIcons.solidNewspaper,
        onPressed: () => context.go('/search/new-arrivals'),
      ),
      CatalogChipData(
        label: 'Tallas XL',
        iconData: FontAwesomeIcons.solidStar,
        onPressed: () => context.go('/search/xl-sizes'),
      ),
    ];

    final productsAsync = ref.watch(productsProvider);

    return CustomScrollView(
      slivers: [
        const HomeLabel(label: 'NUESTROS CATÁLOGOS'),
        ResponsiveTheme.isMobile(context)
            ? const MobileHeaderBar(colorLerp: false)
            : ResponsiveTheme.isTablet(context)
            ? const TabletHeaderBar(colorLerp: false)
            : const HeaderBar(colorLerp: false),
        SliverPadding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          sliver: SliverMainAxisGroup(
            slivers: [SliverToBoxAdapter(child: const SearchHeadBar())],
          ),
        ),
        SliverGap(20),
        SliverCrossAxisGroup(
          slivers: List.generate(catalogChips.length, (index) {
            final catalogChip = catalogChips[index];
            return CatalogChip(
              label: catalogChip.label,
              iconData: catalogChip.iconData,
              onPressed: catalogChip.onPressed,
            );
          }),
        ),
        SliverGap(20),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Categorías',
              style: style?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SliverGap(10),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: productsAsync.when(
            data: (products) {
              final Set<String> categories = {};
              for (final p in products) {
                if (p.isVisible) {
                  categories.addAll(p.categoryIds);
                }
              }
              final categoryList = categories.toList()..sort();
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final categoryName = categoryList[index].capitalize();
                  return ListTile(
                    title: Text(categoryName, style: style),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      context.go('/search/catalog?category=$categoryName');
                    },
                  );
                }, childCount: categoryList.length),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, st) => const SliverToBoxAdapter(
              child: Center(child: Text('Error al cargar categorías')),
            ),
          ),
        ),
        const SliverGap(50),
        const FooterBar(),
      ],
    );
  }
}
