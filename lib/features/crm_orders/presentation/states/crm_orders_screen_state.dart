import 'package:flutter/foundation.dart';

@immutable
class CrmOrdersScreenState {
  final String searchQuery;
  final String? selectedStatus;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedOrderId;

  const CrmOrdersScreenState({
    this.searchQuery = '',
    this.selectedStatus,
    this.startDate,
    this.endDate,
    this.selectedOrderId,
  });

  CrmOrdersScreenState copyWith({
    String? searchQuery,
    String? selectedStatus,
    bool clearStatus = false,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    String? selectedOrderId,
    bool clearOrderId = false,
  }) {
    return CrmOrdersScreenState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: clearStatus ? null : (selectedStatus ?? this.selectedStatus),
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      selectedOrderId: clearOrderId ? null : (selectedOrderId ?? this.selectedOrderId),
    );
  }
}
