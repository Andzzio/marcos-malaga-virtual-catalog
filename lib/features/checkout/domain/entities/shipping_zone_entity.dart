import 'package:equatable/equatable.dart';

class ShippingZoneEntity extends Equatable {
  final String id;
  final String name;
  final List<String> departmentCodes;
  final double? freeShippingThreshold;

  const ShippingZoneEntity({
    required this.id,
    required this.name,
    required this.departmentCodes,
    this.freeShippingThreshold,
  });

  @override
  List<Object?> get props => [id, name, departmentCodes, freeShippingThreshold];
}
