import 'package:equatable/equatable.dart';

class CustomerInfo extends Equatable {
  final String firstName;
  final String lastName;
  final String dni;
  final String phone;

  const CustomerInfo({
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.phone,
  });

  CustomerInfo copyWith({
    String? firstName,
    String? lastName,
    String? dni,
    String? phone,
  }) {
    return CustomerInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dni: dni ?? this.dni,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [firstName, lastName, dni, phone];
}
