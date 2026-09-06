import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends Equatable {
  final String id;
  final String label;
  final bool enabled;
  final String type;
  final String instructions;
  final Map<String, dynamic> details;

  const PaymentMethodModel({
    required this.id,
    required this.label,
    required this.enabled,
    required this.type,
    required this.instructions,
    required this.details,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? true,
      type: json['type'] as String? ?? '',
      instructions: json['instructions'] as String? ?? '',
      details: json['details'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'enabled': enabled,
      'type': type,
      'instructions': instructions,
      'details': details,
    };
  }

  PaymentMethodModel copyWith({
    String? id,
    String? label,
    bool? enabled,
    String? type,
    String? instructions,
    Map<String, dynamic>? details,
  }) {
    return PaymentMethodModel(
      id: id ?? this.id,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      type: type ?? this.type,
      instructions: instructions ?? this.instructions,
      details: details ?? this.details,
    );
  }

  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: id,
      label: label,
      enabled: enabled,
      type: type,
      instructions: instructions,
      details: details,
    );
  }

  @override
  List<Object?> get props => [id, label, enabled, type, instructions, details];
}
