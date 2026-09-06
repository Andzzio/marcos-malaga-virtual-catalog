import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/crm_orders_screen_state.dart';

class CrmOrdersScreenNotifier extends Notifier<CrmOrdersScreenState> {
  @override
  CrmOrdersScreenState build() {
    return const CrmOrdersScreenState();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateStatus(String? status) {
    state = state.copyWith(selectedStatus: status, clearStatus: status == null);
  }

  void setDateRange({DateTime? startDate, DateTime? endDate, bool clearStart = false, bool clearEnd = false}) {
    state = state.copyWith(
      startDate: startDate,
      clearStartDate: clearStart,
      endDate: endDate,
      clearEndDate: clearEnd,
    );
  }

  void selectOrder(String? orderId) {
    state = state.copyWith(selectedOrderId: orderId, clearOrderId: orderId == null);
  }
}

final crmOrdersScreenProvider = NotifierProvider<CrmOrdersScreenNotifier, CrmOrdersScreenState>(
  () => CrmOrdersScreenNotifier(),
);
