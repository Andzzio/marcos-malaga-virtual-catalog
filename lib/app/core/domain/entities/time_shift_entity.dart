import 'package:equatable/equatable.dart';

class TimeShiftEntity extends Equatable {
  final DateTime openTime;
  final DateTime closeTime;

  const TimeShiftEntity({required this.openTime, required this.closeTime});

  @override
  List<Object?> get props => [openTime, closeTime];
}
