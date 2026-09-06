import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_method_entity.dart';

class ShippingMethodModel extends Equatable {
  final String id;
  final String label;
  final bool enabled;
  final List<String> availableZones;
  final Map<String, double> prices;
  final String estimatedDays;
  final String description;

  const ShippingMethodModel({
    required this.id,
    required this.label,
    required this.enabled,
    required this.availableZones,
    required this.prices,
    required this.estimatedDays,
    required this.description,
  });

  factory ShippingMethodModel.fromJson(Map<String, dynamic> json) {
    return ShippingMethodModel(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? true,
      availableZones: (json['availableZones'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      prices: (json['prices'] as Map<String, dynamic>? ?? {}).map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      ),
      estimatedDays: json['estimatedDays'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'enabled': enabled,
      'availableZones': availableZones,
      'prices': prices,
      'estimatedDays': estimatedDays,
      'description': description,
    };
  }

  ShippingMethodModel copyWith({
    String? id,
    String? label,
    bool? enabled,
    List<String>? availableZones,
    Map<String, double>? prices,
    String? estimatedDays,
    String? description,
  }) {
    return ShippingMethodModel(
      id: id ?? this.id,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      availableZones: availableZones ?? this.availableZones,
      prices: prices ?? this.prices,
      estimatedDays: estimatedDays ?? this.estimatedDays,
      description: description ?? this.description,
    );
  }

  ShippingMethodEntity toEntity() {
    return ShippingMethodEntity(
      id: id,
      label: label,
      enabled: enabled,
      availableZones: availableZones,
      prices: prices,
      estimatedDays: estimatedDays,
      description: description,
    );
  }

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
