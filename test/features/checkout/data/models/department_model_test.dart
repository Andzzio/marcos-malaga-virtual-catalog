import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/department_model.dart';

void main() {
  const tModel = DepartmentModel(
    code: '15',
    name: 'Lima',
  );

  final tJson = {
    'code': '15',
    'name': 'Lima',
  };

  group('DepartmentModel', () {
    test('supports value equality', () {
      const otherModel = DepartmentModel(
        code: '15',
        name: 'Lima',
      );
      expect(tModel, equals(otherModel));
    });

    test('fromJson returns a valid model from JSON map', () {
      final result = DepartmentModel.fromJson(tJson);
      expect(result, equals(tModel));
    });

    test('toJson returns a JSON map containing the proper data', () {
      final result = tModel.toJson();
      expect(result, equals(tJson));
    });

    test('bidirectional serialization preserves equality', () {
      final json = tModel.toJson();
      final fromJson = DepartmentModel.fromJson(json);
      expect(fromJson, equals(tModel));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tModel.copyWith(name: 'Arequipa');
      expect(updated.name, 'Arequipa');
      expect(updated.code, tModel.code);
    });
  });
}
