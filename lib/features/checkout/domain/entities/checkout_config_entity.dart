import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/payment_method_entity.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_method_entity.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_zone_entity.dart';

class CheckoutConfigEntity extends Equatable {
  final List<ShippingZoneEntity> shippingZones;
  final List<ShippingMethodEntity> shippingMethods;
  final List<PaymentMethodEntity> paymentMethods;

  const CheckoutConfigEntity({
    this.shippingZones = const [],
    this.shippingMethods = const [],
    this.paymentMethods = const [],
  });

  @override
  List<Object?> get props => [
        shippingZones,
        shippingMethods,
        paymentMethods,
      ];
}
