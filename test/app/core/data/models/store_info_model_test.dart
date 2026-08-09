import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/core/data/models/store_info_model.dart';

void main() {
  group('StoreInfoModel from JSON del Disco', () {
    test('debe parsear correctamente el archivo real store_info.json', () {
      final file = File('assets/json/store_info.json');
      final jsonString = file.readAsStringSync();
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;

      final model = StoreInfoModel.fromJson(jsonMap);

      expect(model.businessName, 'Marcos Malaga SAC');
      expect(model.ruc, '1234567890');
      expect(model.schedule.timeZone, 'America/Lima');
      expect(model.schedule.regularHours.length, 7);
      expect(model.schedule.regularHours.last.isClosed, true); // Domingo cerrado
      expect(model.schedule.exceptions.length, 2);
      expect(model.schedule.exceptions.first.date, DateTime(2026, 12, 25));
      expect(model.schedule.exceptions.first.isClosed, true);
    });

    test('toEntity debe mapear correctamente todos los campos', () {
      final file = File('assets/json/store_info.json');
      final jsonMap = jsonDecode(file.readAsStringSync());
      final model = StoreInfoModel.fromJson(jsonMap);
      
      final entity = model.toEntity();
      
      expect(entity.businessName, 'Marcos Malaga SAC');
      expect(entity.schedule.exceptions.first.date, DateTime(2026, 12, 25));
    });
  });
}
