import 'package:marcos_malaga_app/app/core/data/models/business_day_model.dart';
import 'package:marcos_malaga_app/app/core/data/models/schedule_exception_model.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_schedule_entity.dart';

class StoreScheduleModel {
  final List<BusinessDayModel> regularHours;
  final List<ScheduleExceptionModel> exceptions;
  final String timeZone;

  const StoreScheduleModel({
    required this.regularHours,
    required this.exceptions,
    required this.timeZone,
  });

  factory StoreScheduleModel.fromJson(Map<String, dynamic> json) {
    return StoreScheduleModel(
      regularHours:
          (json['regularHours'] as List<dynamic>?)
              ?.map((e) => BusinessDayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      exceptions:
          (json['exceptions'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ScheduleExceptionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      timeZone: json['timeZone'] as String? ?? 'America/Lima',
    );
  }

  StoreScheduleEntity toEntity() {
    return StoreScheduleEntity(
      regularHours: regularHours.map((e) => e.toEntity()).toList(),
      exceptions: exceptions.map((e) => e.toEntity()).toList(),
      timeZone: timeZone,
    );
  }
}
