import 'package:marcos_malaga_app/app/core/data/models/time_shift_model.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/business_day_entity.dart';

class BusinessDayModel {
  final int dayOfWeek;
  final bool isClosed;
  final List<TimeShiftModel> shifts;

  const BusinessDayModel({
    required this.dayOfWeek,
    required this.isClosed,
    required this.shifts,
  });

  factory BusinessDayModel.fromJson(Map<String, dynamic> json) {
    return BusinessDayModel(
      dayOfWeek: json['dayOfWeek'] as int? ?? 1,
      isClosed: json['isClosed'] as bool? ?? false,
      shifts:
          (json['shifts'] as List<dynamic>?)
              ?.map((e) => TimeShiftModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  BusinessDayEntity toEntity() {
    return BusinessDayEntity(
      dayOfWeek: dayOfWeek,
      isClosed: isClosed,
      shifts: shifts.map((e) => e.toEntity()).toList(),
    );
  }
}
