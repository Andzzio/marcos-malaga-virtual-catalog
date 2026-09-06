import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_entity.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/billing_address.dart';

class CheckoutState extends Equatable {
  final CustomerInfo? customerInfo;
  final ShippingAddress? shippingAddress;
  final BillingAddress? billingAddress;
  final bool billingSameAsShipping;
  final String? paymentMethodId;
  final CheckoutSession? session;
  final DeliveryType deliveryType;
  final String? shippingMethodId;
  final double? shippingCost;
  final String? notes;

  const CheckoutState({
    this.customerInfo,
    this.shippingAddress,
    this.billingAddress,
    this.billingSameAsShipping = true,
    this.paymentMethodId,
    this.session,
    this.deliveryType = DeliveryType.shipping,
    this.shippingMethodId,
    this.shippingCost,
    this.notes,
  });

  double get total {
    final sub =
        session?.items.fold<double>(
          0,
          (sum, item) =>
              sum + ((item.discountPrice ?? item.unitPrice) * item.quantity),
        ) ??
        0.0;
    return sub + (shippingCost ?? 0.0);
  }

  CheckoutState copyWith({
    CustomerInfo? customerInfo,
    ShippingAddress? shippingAddress,
    BillingAddress? billingAddress,
    bool? billingSameAsShipping,
    String? paymentMethodId,
    CheckoutSession? session,
    DeliveryType? deliveryType,
    String? shippingMethodId,
    double? shippingCost,
    String? notes,
  }) {
    return CheckoutState(
      customerInfo: customerInfo ?? this.customerInfo,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      billingSameAsShipping:
          billingSameAsShipping ?? this.billingSameAsShipping,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      session: session ?? this.session,
      deliveryType: deliveryType ?? this.deliveryType,
      shippingMethodId: shippingMethodId ?? this.shippingMethodId,
      shippingCost: shippingCost ?? this.shippingCost,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    customerInfo,
    shippingAddress,
    billingAddress,
    billingSameAsShipping,
    paymentMethodId,
    session,
    deliveryType,
    shippingMethodId,
    shippingCost,
    notes,
  ];
}
