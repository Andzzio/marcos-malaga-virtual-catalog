import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';

class CustomerInfoModel extends CustomerInfo {
  const CustomerInfoModel({
    required super.firstName,
    required super.lastName,
    required super.dni,
    required super.phone,
  });

  factory CustomerInfoModel.fromJson(Map<String, dynamic> json) {
    return CustomerInfoModel(
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      dni: json['dni'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );
  }

  factory CustomerInfoModel.fromEntity(CustomerInfo entity) {
    return CustomerInfoModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      dni: entity.dni,
      phone: entity.phone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'dni': dni,
      'phone': phone,
    };
  }

  @override
  CustomerInfoModel copyWith({
    String? firstName,
    String? lastName,
    String? dni,
    String? phone,
  }) {
    return CustomerInfoModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      dni: dni ?? this.dni,
      phone: phone ?? this.phone,
    );
  }

  CustomerInfo toEntity() {
    return CustomerInfo(
      firstName: firstName,
      lastName: lastName,
      dni: dni,
      phone: phone,
    );
  }
}
