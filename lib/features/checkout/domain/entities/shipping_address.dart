import 'package:equatable/equatable.dart';

class ShippingAddress extends Equatable {
  final String department;
  final String province;
  final String district;
  final String departmentCode;
  final String provinceCode;
  final String districtCode;
  final String address;
  final String reference;
  final String shippingZone;

  const ShippingAddress({
    required this.department,
    required this.province,
    required this.district,
    required this.departmentCode,
    required this.provinceCode,
    required this.districtCode,
    required this.address,
    required this.reference,
    required this.shippingZone,
  });

  const ShippingAddress.empty()
    : department = '',
      province = '',
      district = '',
      departmentCode = '',
      provinceCode = '',
      districtCode = '',
      address = '',
      reference = '',
      shippingZone = '';

  ShippingAddress copyWith({
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
    return ShippingAddress(
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

  @override
  List<Object?> get props => [
    department,
    province,
    district,
    departmentCode,
    provinceCode,
    districtCode,
    address,
    reference,
    shippingZone,
  ];
}
