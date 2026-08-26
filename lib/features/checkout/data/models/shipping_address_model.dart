import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';

class ShippingAddressModel extends ShippingAddress {
  const ShippingAddressModel({
    required super.department,
    required super.province,
    required super.district,
    required super.departmentCode,
    required super.provinceCode,
    required super.districtCode,
    required super.address,
    required super.reference,
    required super.shippingZone,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      department: json['department'] as String? ?? '',
      province: json['province'] as String? ?? '',
      district: json['district'] as String? ?? '',
      departmentCode: json['departmentCode'] as String? ?? '',
      provinceCode: json['provinceCode'] as String? ?? '',
      districtCode: json['districtCode'] as String? ?? '',
      address: json['address'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      shippingZone: json['shippingZone'] as String? ?? '',
    );
  }

  factory ShippingAddressModel.fromEntity(ShippingAddress entity) {
    return ShippingAddressModel(
      department: entity.department,
      province: entity.province,
      district: entity.district,
      departmentCode: entity.departmentCode,
      provinceCode: entity.provinceCode,
      districtCode: entity.districtCode,
      address: entity.address,
      reference: entity.reference,
      shippingZone: entity.shippingZone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'department': department,
      'province': province,
      'district': district,
      'departmentCode': departmentCode,
      'provinceCode': provinceCode,
      'districtCode': districtCode,
      'address': address,
      'reference': reference,
      'shippingZone': shippingZone,
    };
  }

  @override
  ShippingAddressModel copyWith({
    String? department,
    String? province,
    String? district,
    String? departmentCode,
    String? provinceCode,
    String? districtCode,
    String? address,
    String? reference,
    String? shippingZone,
  }) {
    return ShippingAddressModel(
      department: department ?? this.department,
      province: province ?? this.province,
      district: district ?? this.district,
      departmentCode: departmentCode ?? this.departmentCode,
      provinceCode: provinceCode ?? this.provinceCode,
      districtCode: districtCode ?? this.districtCode,
      address: address ?? this.address,
      reference: reference ?? this.reference,
      shippingZone: shippingZone ?? this.shippingZone,
    );
  }

  ShippingAddress toEntity() {
    return ShippingAddress(
      department: department,
      province: province,
      district: district,
      departmentCode: departmentCode,
      provinceCode: provinceCode,
      districtCode: districtCode,
      address: address,
      reference: reference,
      shippingZone: shippingZone,
    );
  }
}
