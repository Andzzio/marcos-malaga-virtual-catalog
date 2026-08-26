import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/payment_method_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/shipping_method_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/shipping_zone_model.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_config_entity.dart';

class CheckoutConfigModel extends Equatable {
  final List<ShippingZoneModel> shippingZones;
  final List<ShippingMethodModel> shippingMethods;
  final List<PaymentMethodModel> paymentMethods;

  const CheckoutConfigModel({
    this.shippingZones = const [],
    this.shippingMethods = const [],
    this.paymentMethods = const [],
  });

  factory CheckoutConfigModel.fromJson(Map<String, dynamic> json) {
    return CheckoutConfigModel(
      shippingZones: (json['shippingZones'] as List<dynamic>? ?? [])
          .map((e) => ShippingZoneModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingMethods: (json['shippingMethods'] as List<dynamic>? ?? [])
          .map((e) => ShippingMethodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethods: (json['paymentMethods'] as List<dynamic>? ?? [])
          .map((e) => PaymentMethodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shippingZones': shippingZones.map((e) => e.toJson()).toList(),
      'shippingMethods': shippingMethods.map((e) => e.toJson()).toList(),
      'paymentMethods': paymentMethods.map((e) => e.toJson()).toList(),
    };
  }

  CheckoutConfigModel copyWith({
    List<ShippingZoneModel>? shippingZones,
    List<ShippingMethodModel>? shippingMethods,
    List<PaymentMethodModel>? paymentMethods,
  }) {
    return CheckoutConfigModel(
      shippingZones: shippingZones ?? this.shippingZones,
      shippingMethods: shippingMethods ?? this.shippingMethods,
      paymentMethods: paymentMethods ?? this.paymentMethods,
    );
  }

  CheckoutConfigEntity toEntity() {
    return CheckoutConfigEntity(
      shippingZones: shippingZones.map((e) => e.toEntity()).toList(),
      shippingMethods: shippingMethods.map((e) => e.toEntity()).toList(),
      paymentMethods: paymentMethods.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
        shippingZones,
        shippingMethods,
        paymentMethods,
      ];
}
