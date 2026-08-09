import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/time_shift_entity.dart';

class ScheduleExceptionEntity extends Equatable {
  final DateTime date;
  final bool isClosed;
  final List<TimeShiftEntity>? customShifts;

  const ScheduleExceptionEntity({
    required this.date,
    required this.isClosed,
    this.customShifts,
  });

  @override
  List<Object?> get props => [date, isClosed, customShifts];
}
