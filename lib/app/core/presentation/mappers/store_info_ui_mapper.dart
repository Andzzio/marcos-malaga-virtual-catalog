import 'package:marcos_malaga_app/app/core/domain/entities/store_info_entity.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_schedule_entity.dart';
import 'package:marcos_malaga_app/app/core/presentation/models/store_info_ui_model.dart';

class StoreInfoUiMapper {
  static StoreInfoUiModel fromEntity(StoreInfoEntity entity) {
    final scheduleText = _calculateScheduleText(entity.schedule);
    final addressText = '${entity.address}\n(${entity.reference}).';

    return StoreInfoUiModel(
      fullAddress: addressText,
      formattedSchedule: scheduleText,
    );
  }

  static String _calculateScheduleText(StoreScheduleEntity schedule) {
    if (schedule.regularHours.isEmpty) return 'Horario no disponible';

    final closedDays = schedule.regularHours
        .where((d) => d.isClosed)
        .map((d) => _getDayName(d.dayOfWeek))
        .toList();

    final Map<String, List<int>> groupedSchedules = {};

    for (final day in schedule.regularHours) {
      if (day.isClosed || day.shifts.isEmpty) continue;

      final shiftsStr = day.shifts
          .map((shift) {
            return '${_formatTime(shift.openTime)} - ${_formatTime(shift.closeTime)}';
          })
          .join(' y ');

      if (!groupedSchedules.containsKey(shiftsStr)) {
        groupedSchedules[shiftsStr] = [];
      }
      groupedSchedules[shiftsStr]!.add(day.dayOfWeek);
    }

    final buffer = StringBuffer();

    groupedSchedules.forEach((timeStr, days) {
      final daysStr = _formatDaysList(days);
      buffer.writeln('$daysStr: $timeStr');
    });

    if (closedDays.isNotEmpty) {
      final closedStr = closedDays.join(', ');
      buffer.write('$closedStr no hay atención.');
    }

    return buffer.toString().trim();
  }

  static String _getDayName(int day) {
    const days = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    return (day >= 1 && day <= 7) ? days[day - 1] : '';
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final ampm = hour >= 12 ? 'pm' : 'am';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    final minuteStr = minute.toString().padLeft(2, '0');
    return minute == 0 ? '$hour12$ampm' : '$hour12:$minuteStr$ampm';
  }

  static String _formatDaysList(List<int> days) {
    if (days.isEmpty) return '';
    days.sort();

    if (days.length >= 3 && _isConsecutive(days)) {
      return '${_getDayName(days.first)} a ${_getDayName(days.last)}';
    }

    return days.map((d) => _getDayName(d)).join(', ');
  }

  static bool _isConsecutive(List<int> days) {
    for (int i = 0; i < days.length - 1; i++) {
      if (days[i + 1] - days[i] != 1) return false;
    }
    return true;
  }
}
