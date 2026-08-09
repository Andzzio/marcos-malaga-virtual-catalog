import 'package:marcos_malaga_app/app/core/domain/entities/time_shift_entity.dart';

class TimeShiftModel {
  final DateTime openTime;
  final DateTime closeTime;

  const TimeShiftModel({required this.openTime, required this.closeTime});

  factory TimeShiftModel.fromJson(Map<String, dynamic> json) {
    return TimeShiftModel(
      openTime: DateTime.parse(json['openTime'] as String),
      closeTime: DateTime.parse(json['closeTime'] as String),
    );
  }

  TimeShiftEntity toEntity() {
    return TimeShiftEntity(openTime: openTime, closeTime: closeTime);
  }
}
