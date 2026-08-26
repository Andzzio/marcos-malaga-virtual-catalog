import 'package:equatable/equatable.dart';

class BillingAddress extends Equatable {
  final String country;
  final String firstName;
  final String lastName;
  final String dni;
  final String address;
  final String department;
  final String province;
  final String district;
  final String phone;

  const BillingAddress({
    required this.country,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.address,
    required this.department,
    required this.province,
    required this.district,
    required this.phone,
  });

  BillingAddress copyWith({
    String? country,
    String? firstName,
    String? lastName,
    String? dni,
    String? address,
    String? department,
    String? province,
    String? district,
    String? phone,
  }) {
    return BillingAddress(
      country: country ?? this.country,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dni: dni ?? this.dni,
      address: address ?? this.address,
      department: department ?? this.department,
      province: province ?? this.province,
      district: district ?? this.district,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [
    country,
    firstName,
    lastName,
    dni,
    address,
    department,
    province,
    district,
    phone,
  ];
}
