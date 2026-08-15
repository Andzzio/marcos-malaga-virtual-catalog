import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/product_filters_provider.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/states/product_filters_state.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/search_head_bar.dart';
import 'availability_filter.dart';
import 'price_filter.dart';
import 'sort_order_filter.dart';

class MobileFilterSheet extends ConsumerStatefulWidget {
  final CatalogCategory category;

  const MobileFilterSheet({super.key, required this.category});

  @override
  ConsumerState<MobileFilterSheet> createState() => _MobileFilterSheetState();
}

class _MobileFilterSheetState extends ConsumerState<MobileFilterSheet> {
  final _minController = TextEditingController();
  final _maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final filterState = ref.read(productFiltersProvider(widget.category));
    if (filterState.minPrice != null) {
      _minController.text = filterState.minPrice.toString();
    }
    if (filterState.maxPrice != null) {
      _maxController.text = filterState.maxPrice.toString();
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void updatePath(String key, String? value) {
    final uri = GoRouter.of(context).state.uri;
    final Map<String, dynamic> queryParams = Map.of(uri.queryParameters);
    if (value == null || value.isEmpty) {
      queryParams.remove(key);
    } else {
      queryParams[key] = value;
    }
    final newUri = Uri(
      path: uri.path,
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    context.replace(newUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(productFiltersProvider(widget.category));

    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 14);
    final titleStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Filtros', style: titleStyle),
            SearchHeadBar(
              progress: 1.0,
              initialQuery: filterState.query,
              onSubmittedOverride: (query) => updatePath('q', query),
            ),
            Text('Disponibilidad', style: titleStyle),
            AvailabilityFilter(
              showInStock: filterState.showInStock,
              showOutOfStock: filterState.showOutOfStock,
              onInStockChanged: (val) => updatePath('inStock', val.toString()),
              onOutStockChanged: (val) =>
                  updatePath('outStock', val.toString()),
              style: style,
            ),
            Text('Precio', style: titleStyle),
            PriceFilter(
              minController: _minController,
              maxController: _maxController,
              onMinSubmitted: (val) => updatePath('min', val),
              onMaxSubmitted: (val) => updatePath('max', val),
              style: style,
            ),
            Text('Ordenar', style: titleStyle),
            SortOrderFilter(
              currentOrder: filterState.sortOrder,
              category: widget.category,
              onChanged: (val) => updatePath('order', val?.name),
              style: style,
            ),
            SizedBox(
              height: 45,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(8),
                  ),
                ),
                onPressed: () => context.pop(),
                child: Text(
                  'Ver Resultados',
                  style: style?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
