import 'package:equatable/equatable.dart';

class ShippingMethodEntity extends Equatable {
  final String id;
  final String label;
  final bool enabled;
  final List<String> availableZones;
  final Map<String, double> prices;
  final String estimatedDays;
  final String description;

  const ShippingMethodEntity({
    required this.id,
    required this.label,
    required this.enabled,
    required this.availableZones,
    required this.prices,
    required this.estimatedDays,
    required this.description,
  });

  @override
  List<Object?> get props => [
    id,
    label,
    enabled,
    availableZones,
    prices,
    estimatedDays,
    description,
  ];
}
