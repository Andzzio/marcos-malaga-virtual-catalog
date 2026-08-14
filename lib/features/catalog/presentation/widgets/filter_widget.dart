import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/product_filters_provider.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/states/product_filters_state.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/consumer_pop_over_widget.dart';

import 'package:marcos_malaga_app/features/catalog/presentation/widgets/filters/availability_filter.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/filters/price_filter.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/filters/sort_order_filter.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/filters/mobile_filter_sheet.dart';

class FilterWidget extends ConsumerStatefulWidget {
  const FilterWidget({
    super.key,
    required this.category,
    this.count,
    this.showInStock,
    this.showOutOfStock,
    this.query,
    this.categoryName,
    this.minPrice,
    this.maxPrice,
    this.orderBy,
  });

  final CatalogCategory category;
  final int? count;
  final String? showInStock;
  final String? showOutOfStock;
  final String? query;
  final String? categoryName;
  final String? minPrice;
  final String? maxPrice;
  final String? orderBy;

  @override
  ConsumerState<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends ConsumerState<FilterWidget> {
  final _minContoller = TextEditingController();
  final _maxController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.minPrice != null) {
      _minContoller.text = widget.minPrice!;
    }
    if (widget.maxPrice != null) {
      _maxController.text = widget.maxPrice!;
    }
    Future.microtask(() {
      if (widget.query != null) {
        ref
            .read(productFiltersProvider(widget.category).notifier)
            .updateQuery(widget.query!);
      }
      if (widget.categoryName != null) {
        ref
            .read(productFiltersProvider(widget.category).notifier)
            .updateCategory(widget.categoryName);
      }
      ref
          .read(productFiltersProvider(widget.category).notifier)
          .setPriceRange(
            widget.minPrice != null ? double.tryParse(widget.minPrice!) : null,
            widget.maxPrice != null ? double.tryParse(widget.maxPrice!) : null,
          );
      if (widget.showInStock != null) {
        final showInStock =
            bool.tryParse(widget.showInStock!, caseSensitive: false) ?? false;

        ref
            .read(productFiltersProvider(widget.category).notifier)
            .setAvailability(showInStock: showInStock);
      }
      if (widget.showOutOfStock != null) {
        final showOutStock =
            bool.tryParse(widget.showOutOfStock!, caseSensitive: false) ??
            false;

        ref
            .read(productFiltersProvider(widget.category).notifier)
            .setAvailability(showOutOfStock: showOutStock);
      }
      if (widget.orderBy != null) {
        final sortOrder = CatalogSortOrder.values.firstWhere(
          (e) => e.name == widget.orderBy,
          orElse: () => CatalogSortOrder.relevance,
        );
        ref
            .read(productFiltersProvider(widget.category).notifier)
            .setSortOrder(sortOrder);
      }
    });
  }

  @override
  void didUpdateWidget(covariant FilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != null && (oldWidget.query != widget.query)) {
      ref
          .read(productFiltersProvider(widget.category).notifier)
          .updateQuery(widget.query!);
    }
    if (widget.categoryName != null &&
        (oldWidget.categoryName != widget.categoryName)) {
      ref
          .read(productFiltersProvider(widget.category).notifier)
          .updateCategory(widget.categoryName);
    }
    if (widget.minPrice != null && (oldWidget.minPrice != widget.minPrice)) {
      _minContoller.text = widget.minPrice!;
    }
    if (widget.maxPrice != null && (oldWidget.maxPrice != widget.maxPrice)) {
      _maxController.text = widget.maxPrice!;
    }
    Future.microtask(() {
      if (oldWidget.minPrice != widget.minPrice ||
          oldWidget.maxPrice != widget.maxPrice) {
        ref
            .read(productFiltersProvider(widget.category).notifier)
            .setPriceRange(
              widget.minPrice != null
                  ? double.tryParse(widget.minPrice!)
                  : null,
              widget.maxPrice != null
                  ? double.tryParse(widget.maxPrice!)
                  : null,
            );
      }
      if (widget.showInStock != null &&
          (oldWidget.showInStock != widget.showInStock)) {
        final showInStock =
            bool.tryParse(widget.showInStock!, caseSensitive: false) ?? false;
        ref
            .read(productFiltersProvider(widget.category).notifier)
            .setAvailability(showInStock: showInStock);
      }
      if (widget.showOutOfStock != null &&
          (oldWidget.showOutOfStock != widget.showOutOfStock)) {
        final showOutStock =
            bool.tryParse(widget.showOutOfStock!, caseSensitive: false) ??
            false;
        ref
            .read(productFiltersProvider(widget.category).notifier)
            .setAvailability(showOutOfStock: showOutStock);
      }
      if (widget.orderBy != null && (oldWidget.orderBy != widget.orderBy)) {
        final sortOrder = CatalogSortOrder.values.firstWhere(
          (e) => e.name == widget.orderBy,
          orElse: () => CatalogSortOrder.relevance,
        );
        ref
            .read(productFiltersProvider(widget.category).notifier)
            .setSortOrder(sortOrder);
      }
    });
  }

  @override
  void dispose() {
    _minContoller.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _openMobileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
      ),
      builder: (context) => MobileFilterSheet(category: widget.category),
    );
  }

  void updateFilterPath(BuildContext context, String key, String? value) {
    final uri = GoRouter.of(context).state.uri;
    final Map<String, dynamic> queryParams = Map.of(uri.queryParameters);
    if (value == null || value.isEmpty) {
      queryParams.remove(key);
    } else {
      queryParams[key] = value;
    }
    final newUri = uri.replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    return context.replace(newUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 14);

    if (ResponsiveTheme.isMobile(context)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Text('${widget.count ?? '?'} artículos', style: style),
            Spacer(),
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.filter, size: 14),
              onPressed: () => _openMobileSheet(context),
            ),
          ],
        ),
      );
    }

    return Row(
      spacing: 10,
      children: [
        ConsumerPopOverWidget(
          label: 'Disponibilidad',
          bodyBuilder: (context, ref) {
            final filterState = ref.watch(
              productFiltersProvider(widget.category),
            );
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: AvailabilityFilter(
                showInStock: filterState.showInStock,
                showOutOfStock: filterState.showOutOfStock,
                onInStockChanged: (newValue) {
                  updateFilterPath(context, 'inStock', newValue.toString());
                },
                onOutStockChanged: (newValue) {
                  updateFilterPath(context, 'outStock', newValue.toString());
                },
                style: style,
              ),
            );
          },
        ),
        ConsumerPopOverWidget(
          label: 'Precio',
          bodyBuilder: ((context, ref) => Padding(
            padding: const EdgeInsetsGeometry.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: PriceFilter(
              minController: _minContoller,
              maxController: _maxController,
              onMinSubmitted: (value) {
                String? newValue = value.isEmpty ? null : value;
                updateFilterPath(context, 'min', newValue);
              },
              onMaxSubmitted: (value) {
                String? newValue = value.isEmpty ? null : value;
                updateFilterPath(context, 'max', newValue);
              },
              style: style,
            ),
          )),
        ),
        Spacer(),
        Text('${widget.count ?? '?'} artículos', style: style),
        ConsumerPopOverWidget(
          label: 'Ordenar',
          bodyBuilder: ((context, ref) {
            final filterState = ref.watch(
              productFiltersProvider(widget.category),
            );
            return Padding(
              padding: const EdgeInsetsGeometry.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: SortOrderFilter(
                currentOrder: filterState.sortOrder,
                category: widget.category,
                onChanged: (newValue) {
                  updateFilterPath(context, 'order', newValue?.name);
                },
                style: style,
              ),
            );
          }),
        ),
        Gap(10),
      ],
    );
  }
}
