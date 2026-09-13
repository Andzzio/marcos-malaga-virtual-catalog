import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';
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

  void updateProductDraft(ProductEntity product) {
    final map = Map<String, ProductEntity>.from(state.pendingEdits);
    map[product.id] = product;
    state = state.copyWith(pendingEdits: map);
  }

  void discardDraft(String productId) {
    final map = Map<String, ProductEntity>.from(state.pendingEdits);
    map.remove(productId);
    state = state.copyWith(pendingEdits: map);
  }

  void discardAllDrafts() {
    state = state.copyWith(pendingEdits: const {});
  }

  Future<bool> saveAllPending() async {
    if (state.pendingEdits.isEmpty) return false;
    state = state.copyWith(isSaving: true);
    try {
      final list = state.pendingEdits.values.toList();
      final provider = ref.read(productsProvider.notifier);
      for (final product in list) {
        await provider.updateProduct(product);
      }
      state = state.copyWith(
        pendingEdits: const {},
        isSaving: false,
      );
      return true;
    } catch (_) {
      state = state.copyWith(isSaving: false);
      return false;
    }
  }
}

final inventoryScreenProvider =
    NotifierProvider<InventoryScreenProvider, InventoryScreenState>(
  InventoryScreenProvider.new,
);

final filteredInventoryProductsProvider =
    Provider<AsyncValue<List<ProductEntity>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final searchQuery = ref.watch(
    inventoryScreenProvider.select((s) => s.searchQuery.toLowerCase().trim()),
  );
  final selectedFilter = ref.watch(
    inventoryScreenProvider.select((s) => s.selectedFilter),
  );

  return productsAsync.whenData((products) {
    return products.where((p) {
      // 1. Filtro papelera vs activos
      if (selectedFilter == 'Papelera') {
        if (!p.isDeleted) return false;
      } else {
        if (p.isDeleted) return false;
      }

      // 2. Filtros de estado y existencias
      if (selectedFilter == 'Visibles' && !p.isVisible) {
        return false;
      }
      if (selectedFilter == 'Ocultos' && p.isVisible) {
        return false;
      }
      if (selectedFilter == 'Con stock' && p.totalStock == 0) {
        return false;
      }
      if (selectedFilter == 'Sin stock' && p.totalStock > 0) {
        return false;
      }

      // 3. Búsqueda por texto (nombre o ID)
      if (searchQuery.isNotEmpty) {
        final matchesName = p.name.toLowerCase().contains(searchQuery);
        final matchesId = p.id.toLowerCase().contains(searchQuery);
        if (!matchesName && !matchesId) return false;
      }

      return true;
    }).toList();
  });
});
