import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_zone_entity.dart';

class ShippingZoneModel extends Equatable {
  final String id;
  final String name;
  final List<String> departmentCodes;
  final double? freeShippingThreshold;

  const ShippingZoneModel({
    required this.id,
    required this.name,
    required this.departmentCodes,
    this.freeShippingThreshold,
  });

  factory ShippingZoneModel.fromJson(Map<String, dynamic> json) {
    return ShippingZoneModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      departmentCodes: (json['departmentCodes'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      freeShippingThreshold: (json['freeShippingThreshold'] as num?)
          ?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'departmentCodes': departmentCodes,
      'freeShippingThreshold': freeShippingThreshold,
    };
  }

  ShippingZoneModel copyWith({
    String? id,
    String? name,
    List<String>? departmentCodes,
    double? freeShippingThreshold,
  }) {
    return ShippingZoneModel(
      id: id ?? this.id,
      name: name ?? this.name,
      departmentCodes: departmentCodes ?? this.departmentCodes,
      freeShippingThreshold:
          freeShippingThreshold ?? this.freeShippingThreshold,
    );
  }

  ShippingZoneEntity toEntity() {
    return ShippingZoneEntity(
      id: id,
      name: name,
      departmentCodes: departmentCodes,
      freeShippingThreshold: freeShippingThreshold,
    );
  }

  @override
  List<Object?> get props => [id, name, departmentCodes, freeShippingThreshold];
}
