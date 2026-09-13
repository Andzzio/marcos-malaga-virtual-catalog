import 'package:flutter/foundation.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';

class InventoryScreenState {
  final Set<String> selectedProductIds;
  final String searchQuery;
  final String selectedFilter;
  final Map<String, ProductEntity> pendingEdits;
  final bool isSaving;

  const InventoryScreenState({
    this.selectedProductIds = const {},
    this.searchQuery = '',
    this.selectedFilter = 'Todos',
    this.pendingEdits = const {},
    this.isSaving = false,
  });

  bool get hasPendingEdits => pendingEdits.isNotEmpty;
  int get pendingEditsCount => pendingEdits.length;

  InventoryScreenState copyWith({
    Set<String>? selectedProductIds,
    String? searchQuery,
    String? selectedFilter,
    Map<String, ProductEntity>? pendingEdits,
    bool? isSaving,
  }) {
    return InventoryScreenState(
      selectedProductIds: selectedProductIds ?? this.selectedProductIds,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      pendingEdits: pendingEdits ?? this.pendingEdits,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InventoryScreenState &&
        setEquals(other.selectedProductIds, selectedProductIds) &&
        other.searchQuery == searchQuery &&
        other.selectedFilter == selectedFilter &&
        mapEquals(other.pendingEdits, pendingEdits) &&
        other.isSaving == isSaving;
  }

  @override
  int get hashCode =>
      selectedProductIds.hashCode ^
      searchQuery.hashCode ^
      selectedFilter.hashCode ^
      pendingEdits.hashCode ^
      isSaving.hashCode;
}
