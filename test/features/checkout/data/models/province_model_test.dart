import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/province_model.dart';

void main() {
  const tModel = ProvinceModel(
    code: '1501',
    name: 'Lima',
    departmentCode: '15',
  );

  final tJson = {
    'code': '1501',
    'name': 'Lima',
    'departmentCode': '15',
  };

  group('ProvinceModel', () {
    test('supports value equality', () {
      const otherModel = ProvinceModel(
        code: '1501',
        name: 'Lima',
        departmentCode: '15',
      );
      expect(tModel, equals(otherModel));
    });

    test('fromJson returns a valid model from JSON map', () {
      final result = ProvinceModel.fromJson(tJson);
      expect(result, equals(tModel));
    });

    test('toJson returns a JSON map containing the proper data', () {
      final result = tModel.toJson();
      expect(result, equals(tJson));
    });

    test('bidirectional serialization preserves equality', () {
      final json = tModel.toJson();
      final fromJson = ProvinceModel.fromJson(json);
      expect(fromJson, equals(tModel));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tModel.copyWith(name: 'Huaral');
      expect(updated.name, 'Huaral');
      expect(updated.code, tModel.code);
      expect(updated.departmentCode, tModel.departmentCode);
    });
  });
}
