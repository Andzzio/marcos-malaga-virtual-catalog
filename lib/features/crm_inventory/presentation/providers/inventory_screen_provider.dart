import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/inventory_screen_state.dart';

class InventoryScreenProvider extends Notifier<InventoryScreenState> {
  @override
  InventoryScreenState build() {
    return const InventoryScreenState();
  }

  void toggleSelection(String productId) {
    final currentSet = Set<String>.from(state.selectedProductIds);
    if (currentSet.contains(productId)) {
      currentSet.remove(productId);
    } else {
      currentSet.add(productId);
    }
    state = state.copyWith(selectedProductIds: currentSet);
  }

  void clearSelection() {
    state = state.copyWith(selectedProductIds: const {});
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }
}

final inventoryScreenProvider =
    NotifierProvider<InventoryScreenProvider, InventoryScreenState>(
  InventoryScreenProvider.new,
);
