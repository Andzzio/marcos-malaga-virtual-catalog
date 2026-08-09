import 'package:marcos_malaga_app/app/core/data/models/time_shift_model.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/schedule_exception_entity.dart';

class ScheduleExceptionModel {
  final DateTime date;
  final bool isClosed;
  final List<TimeShiftModel>? customShifts;

  const ScheduleExceptionModel({
    required this.date,
    required this.isClosed,
    this.customShifts,
  });

  factory ScheduleExceptionModel.fromJson(Map<String, dynamic> json) {
    return ScheduleExceptionModel(
      date: DateTime.parse(json['date'] as String),
      isClosed: json['isClosed'] as bool? ?? false,
      customShifts: (json['customShifts'] as List<dynamic>?)
          ?.map((e) => TimeShiftModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ScheduleExceptionEntity toEntity() {
    return ScheduleExceptionEntity(
      date: date,
      isClosed: isClosed,
      customShifts: customShifts?.map((e) => e.toEntity()).toList(),
    );
  }
}
