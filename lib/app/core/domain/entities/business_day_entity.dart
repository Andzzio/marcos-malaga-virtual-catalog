import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/time_shift_entity.dart';

class BusinessDayEntity extends Equatable {
  final int dayOfWeek; // 1 = Lunes, 7 = Domingo (ISO 8601)
  final bool isClosed;
  final List<TimeShiftEntity> shifts;

  const BusinessDayEntity({
    required this.dayOfWeek,
    required this.isClosed,
    required this.shifts,
  });

  @override
  List<Object?> get props => [dayOfWeek, isClosed, shifts];
}
