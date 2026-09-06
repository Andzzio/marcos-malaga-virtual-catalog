import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/department_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/district_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/province_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/ubigeo_model.dart';

void main() {
  const tDepartment = DepartmentModel(code: '15', name: 'Lima');

  const tProvince = ProvinceModel(
    code: '1501',
    name: 'Lima',
    departmentCode: '15',
  );

  const tDistrict = DistrictModel(
    code: '150122',
    name: 'Miraflores',
    provinceCode: '1501',
  );

  const tUbigeo = UbigeoModel(
    departments: [tDepartment],
    provinces: [tProvince],
    districts: [tDistrict],
  );

  final tJson = {
    'departments': [
      {'code': '15', 'name': 'Lima'},
    ],
    'provinces': [
      {'code': '1501', 'name': 'Lima', 'departmentCode': '15'},
    ],
    'districts': [
      {'code': '150122', 'name': 'Miraflores', 'provinceCode': '1501'},
    ],
  };

  group('UbigeoModel', () {
    test('supports value equality', () {
      const otherModel = UbigeoModel(
        departments: [tDepartment],
        provinces: [tProvince],
        districts: [tDistrict],
      );
      expect(tUbigeo, equals(otherModel));
    });

    test('fromJson returns a valid model from JSON map', () {
      final result = UbigeoModel.fromJson(tJson);
      expect(result, equals(tUbigeo));
    });

    test('toJson returns a JSON map containing the proper data', () {
      final result = tUbigeo.toJson();
      expect(result, equals(tJson));
    });

    test('bidirectional serialization preserves equality', () {
      final json = tUbigeo.toJson();
      final fromJson = UbigeoModel.fromJson(json);
      expect(fromJson, equals(tUbigeo));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tUbigeo.copyWith(departments: const []);
      expect(updated.departments, isEmpty);
      expect(updated.provinces, [tProvince]);
      expect(updated.districts, [tDistrict]);
    });
  });
}
