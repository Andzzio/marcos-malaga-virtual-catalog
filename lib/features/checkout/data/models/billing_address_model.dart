import 'package:marcos_malaga_app/features/checkout/domain/entities/billing_address.dart';

class BillingAddressModel extends BillingAddress {
  const BillingAddressModel({
    required super.country,
    required super.firstName,
    required super.lastName,
    required super.dni,
    required super.address,
    required super.department,
    required super.province,
    required super.district,
    required super.phone,
  });

  factory BillingAddressModel.fromJson(Map<String, dynamic> json) {
    return BillingAddressModel(
      country: json['country'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      dni: json['dni'] as String? ?? '',
      address: json['address'] as String? ?? '',
      department: json['department'] as String? ?? '',
      province: json['province'] as String? ?? '',
      district: json['district'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'firstName': firstName,
      'lastName': lastName,
      'dni': dni,
      'address': address,
      'department': department,
      'province': province,
      'district': district,
      'phone': phone,
    };
  }

  factory BillingAddressModel.fromEntity(BillingAddress entity) {
    return BillingAddressModel(
      country: entity.country,
      firstName: entity.firstName,
      lastName: entity.lastName,
      dni: entity.dni,
      address: entity.address,
      department: entity.department,
      province: entity.province,
      district: entity.district,
      phone: entity.phone,
    );
  }

  BillingAddress toEntity() {
    return BillingAddress(
      country: country,
      firstName: firstName,
      lastName: lastName,
      dni: dni,
      address: address,
      department: department,
      province: province,
      district: district,
      phone: phone,
    );
  }
}
