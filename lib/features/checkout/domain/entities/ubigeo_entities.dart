import 'package:equatable/equatable.dart';

class DepartmentEntity extends Equatable {
  final String code;
  final String name;

  const DepartmentEntity({
    required this.code,
    required this.name,
  });

  @override
  List<Object?> get props => [code, name];
}

class ProvinceEntity extends Equatable {
  final String code;
  final String name;
  final String departmentCode;

  const ProvinceEntity({
    required this.code,
    required this.name,
    required this.departmentCode,
  });

  @override
  List<Object?> get props => [code, name, departmentCode];
}

class DistrictEntity extends Equatable {
  final String code;
  final String name;
  final String provinceCode;

  const DistrictEntity({
    required this.code,
    required this.name,
    required this.provinceCode,
  });

  @override
  List<Object?> get props => [code, name, provinceCode];
}

class UbigeoEntity extends Equatable {
  final List<DepartmentEntity> departments;
  final List<ProvinceEntity> provinces;
  final List<DistrictEntity> districts;

  const UbigeoEntity({
    this.departments = const [],
    this.provinces = const [],
    this.districts = const [],
  });

  @override
  List<Object?> get props => [departments, provinces, districts];
}
