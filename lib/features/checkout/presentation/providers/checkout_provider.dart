import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/providers/core/core_providers.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/billing_address.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_entity.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_method_entity.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/states/checkout_state.dart';

import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_config_provider.dart';

class CheckoutProvider extends Notifier<CheckoutState> {
  final CheckoutSession session;

  CheckoutProvider(this.session);

  @override
  CheckoutState build() {
    return CheckoutState(session: session);
  }

  Future<List<ShippingMethodEntity>> get shippingMethods async {
    List<ShippingMethodEntity> shippingMethods = [];
    final checkoutConfigCombined = await ref.read(
      checkoutConfigProvider.future,
    );
    final selectedDepartmentCode = state.shippingAddress?.departmentCode;
    if (selectedDepartmentCode == null || selectedDepartmentCode.isEmpty) {
      return shippingMethods;
    }
    final shippingZones = checkoutConfigCombined.config.shippingZones;
    final List<ShippingMethodEntity> globalShippingMethods =
        checkoutConfigCombined.config.shippingMethods;
    final selectedZone = shippingZones.firstWhere(
      (z) => z.departmentCodes.contains(selectedDepartmentCode),
    );
    shippingMethods = globalShippingMethods
        .where(
          (sM) => sM.enabled && sM.availableZones.contains(selectedZone.id),
        )
        .toList();
    return shippingMethods;
  }

  void updateCustomerInfo(CustomerInfo info) {
    state = state.copyWith(customerInfo: info);
  }

  void toggleBillingSameAsShipping(bool value) {
    state = state.copyWith(billingSameAsShipping: value);
  }

  void updateBillingAddress(BillingAddress address) {
    state = state.copyWith(billingAddress: address);
  }

  Future<void> updateShippingAddress(ShippingAddress address) async {
    state = state.copyWith(shippingAddress: address);
    final shippingMethodsFilteredByZone = await shippingMethods;
    state = state.copyWith(
      shippingMethodId: shippingMethodsFilteredByZone.isEmpty
          ? null
          : shippingMethodsFilteredByZone.first.id,
    );
  }

  void setPaymentMethod(String id) {
    state = state.copyWith(paymentMethodId: id);
  }

  void setDeliveryType(DeliveryType type) {
    if (type == DeliveryType.pickup) {
      state = CheckoutState(
        customerInfo: state.customerInfo,
        shippingAddress: state.shippingAddress,
        billingAddress: state.billingAddress,
        billingSameAsShipping: state.billingSameAsShipping,
        paymentMethodId: state.paymentMethodId,
        session: state.session,
        deliveryType: type,
        shippingMethodId: null,
        shippingCost: 0.0,
      );
    } else {
      state = state.copyWith(deliveryType: type, shippingMethodId: null);
    }
  }

  Future<void> setShippingMethod(String methodId, String zoneId) async {
    final subtotal =
        state.session?.items.fold<double>(
          0.0,
          (sum, item) =>
              sum + ((item.discountPrice ?? item.unitPrice) * item.quantity),
        ) ??
        0.0;

    final configCombined = await ref.read(checkoutConfigProvider.future);
    final config = configCombined.config;

    final zone = config.shippingZones.firstWhere((z) => z.id == zoneId);

    double calculatedCost = 0.0;
    if (zone.freeShippingThreshold != null &&
        subtotal >= zone.freeShippingThreshold!) {
      calculatedCost = 0.0;
    } else {
      final method = config.shippingMethods.firstWhere((m) => m.id == methodId);
      calculatedCost = method.prices[zoneId] ?? 0.0;
    }

    state = CheckoutState(
      customerInfo: state.customerInfo,
      shippingAddress: state.shippingAddress,
      billingAddress: state.billingAddress,
      billingSameAsShipping: state.billingSameAsShipping,
      paymentMethodId: state.paymentMethodId,
      session: state.session,
      deliveryType: state.deliveryType,
      shippingMethodId: methodId,
      shippingCost: calculatedCost,
    );
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  Future<void> submitOrder({OrderEntity? customOrder}) async {
    final createOrder = ref.read(createOrderUseCaseProvider);

    if (customOrder != null) {
      await createOrder(customOrder: customOrder);
      return;
    } else {
      if (state.session == null) return;

      BillingAddress? finalBillingAddress = state.billingAddress;
      if (state.billingSameAsShipping) {
        if (state.customerInfo != null && state.shippingAddress != null) {
          finalBillingAddress = BillingAddress(
            country: 'Perú',
            firstName: state.customerInfo!.firstName,
            lastName: state.customerInfo!.lastName,
            dni: state.customerInfo!.dni,
            phone: state.customerInfo!.phone,
            address: state.shippingAddress!.address,
            department: state.shippingAddress!.department,
            province: state.shippingAddress!.province,
            district: state.shippingAddress!.district,
          );
        }
      }

      await createOrder(
        session: state.session!,
        customer: state.customerInfo,
        shipping: state.shippingAddress,
        billing: finalBillingAddress,
        paymentMethodId: state.paymentMethodId,
        deliveryType: state.deliveryType,
        shippingMethodId: state.shippingMethodId,
        shippingCost: state.shippingCost,
        notes: state.notes,
      );

      if (state.session!.clearCartOnSuccess) {
        // TODO: Orchestrate cart clearing via global UseCase or Event Bus
      }
    }
  }
}

final checkoutProvider =
    NotifierProvider.family<CheckoutProvider, CheckoutState, CheckoutSession>(
      CheckoutProvider.new,
    );
