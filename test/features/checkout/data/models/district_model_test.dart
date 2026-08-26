import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/district_model.dart';

void main() {
  const tModel = DistrictModel(
    code: '150122',
    name: 'Miraflores',
    provinceCode: '1501',
  );

  final tJson = {
    'code': '150122',
    'name': 'Miraflores',
    'provinceCode': '1501',
  };

  group('DistrictModel', () {
    test('supports value equality', () {
      const otherModel = DistrictModel(
        code: '150122',
        name: 'Miraflores',
        provinceCode: '1501',
      );
      expect(tModel, equals(otherModel));
    });

    test('fromJson returns a valid model from JSON map', () {
      final result = DistrictModel.fromJson(tJson);
      expect(result, equals(tModel));
    });

    test('toJson returns a JSON map containing the proper data', () {
      final result = tModel.toJson();
      expect(result, equals(tJson));
    });

    test('bidirectional serialization preserves equality', () {
      final json = tModel.toJson();
      final fromJson = DistrictModel.fromJson(json);
      expect(fromJson, equals(tModel));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tModel.copyWith(name: 'San Isidro');
      expect(updated.name, 'San Isidro');
      expect(updated.code, tModel.code);
      expect(updated.provinceCode, tModel.provinceCode);
    });
  });
}
