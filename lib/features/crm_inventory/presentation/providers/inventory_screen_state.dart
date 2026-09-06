import 'package:flutter/foundation.dart';

class InventoryScreenState {
  final Set<String> selectedProductIds;
  final String searchQuery;
  final String selectedFilter;

  const InventoryScreenState({
    this.selectedProductIds = const {},
    this.searchQuery = '',
    this.selectedFilter = 'Todos',
  });

  InventoryScreenState copyWith({
    Set<String>? selectedProductIds,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return InventoryScreenState(
      selectedProductIds: selectedProductIds ?? this.selectedProductIds,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InventoryScreenState &&
        setEquals(other.selectedProductIds, selectedProductIds) &&
        other.searchQuery == searchQuery &&
        other.selectedFilter == selectedFilter;
  }

  @override
  int get hashCode =>
      selectedProductIds.hashCode ^
      searchQuery.hashCode ^
      selectedFilter.hashCode;
}
