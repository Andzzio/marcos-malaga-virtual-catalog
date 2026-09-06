import 'package:equatable/equatable.dart';

class PaymentMethodEntity extends Equatable {
  final String id;
  final String label;
  final bool enabled;
  final String type;
  final String instructions;
  final Map<String, dynamic> details;

  const PaymentMethodEntity({
    required this.id,
    required this.label,
    required this.enabled,
    required this.type,
    required this.instructions,
    required this.details,
  });

  @override
  List<Object?> get props => [id, label, enabled, type, instructions, details];
}
