import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/business_day_entity.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/schedule_exception_entity.dart';

class StoreScheduleEntity extends Equatable {
  final List<BusinessDayEntity> regularHours;
  final List<ScheduleExceptionEntity> exceptions;
  final String timeZone;

  const StoreScheduleEntity({
    required this.regularHours,
    required this.exceptions,
    required this.timeZone,
  });

  @override
  List<Object?> get props => [regularHours, exceptions, timeZone];
}
