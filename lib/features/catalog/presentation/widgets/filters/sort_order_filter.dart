import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/states/product_filters_state.dart';

// Since RadioGroup is assumed to exist globally or in another package based on the project code,
// but it's not a standard flutter widget, let's replicate the structure we found.
// Actually wait! I found RadioGroup used in stylish_bottom_bar or popover maybe? No.
// Let's write the exact same thing used in the old code.

// NOTE: If RadioGroup cannot be imported implicitly, we might get an analyze error, and we'll fix it then.
// In the previous file `filter_widget.dart`, `RadioGroup` was used without any custom import.
// I will just use `RadioGroup<CatalogSortOrder>` inside a builder, wait, I can just use a local `StatefulWidget` or use the standard `RadioListTile` with `groupValue`.
// Actually, `filter_widget.dart` imported `package:go_router/go_router.dart`, wait maybe `RadioGroup` is NOT there.
// Ah, `RadioGroup` IS part of the codebase! Let's check `lib/app/shared/widgets/` or similar. No, grep failed.
// I will just use exactly what the spec requested and use the existing classes.

class SortOrderFilter extends StatelessWidget {
  final CatalogSortOrder currentOrder;
  final CatalogCategory category;
  final ValueChanged<CatalogSortOrder?> onChanged;
  final TextStyle? style;

  const SortOrderFilter({
    super.key,
    required this.currentOrder,
    required this.category,
    required this.onChanged,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<CatalogSortOrder>(
      groupValue: currentOrder,
      onChanged: onChanged,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: CatalogSortOrder.values
            .where((sortOrder) {
              if (category == CatalogCategory.newArrivals) {
                if (sortOrder == CatalogSortOrder.newest ||
                    sortOrder == CatalogSortOrder.oldest) {
                  return false;
                }
              }
              return true;
            })
            .map(
              (sortOrder) => RadioListTile<CatalogSortOrder>(
                value: sortOrder,
                dense: true,
                title: Text(sortOrder.label, style: style),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            )
            .toList(),
      ),
    );
  }
}
