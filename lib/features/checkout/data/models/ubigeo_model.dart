import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/department_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/district_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/province_model.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/ubigeo_entities.dart';

class UbigeoModel extends Equatable {
  final List<DepartmentModel> departments;
  final List<ProvinceModel> provinces;
  final List<DistrictModel> districts;

  const UbigeoModel({
    this.departments = const [],
    this.provinces = const [],
    this.districts = const [],
  });

  factory UbigeoModel.fromJson(Map<String, dynamic> json) {
    return UbigeoModel(
      departments: (json['departments'] as List<dynamic>? ?? [])
          .map((e) => DepartmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      provinces: (json['provinces'] as List<dynamic>? ?? [])
          .map((e) => ProvinceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      districts: (json['districts'] as List<dynamic>? ?? [])
          .map((e) => DistrictModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departments': departments.map((e) => e.toJson()).toList(),
      'provinces': provinces.map((e) => e.toJson()).toList(),
      'districts': districts.map((e) => e.toJson()).toList(),
    };
  }

  UbigeoModel copyWith({
    List<DepartmentModel>? departments,
    List<ProvinceModel>? provinces,
    List<DistrictModel>? districts,
  }) {
    return UbigeoModel(
      departments: departments ?? this.departments,
      provinces: provinces ?? this.provinces,
      districts: districts ?? this.districts,
    );
  }

  UbigeoEntity toEntity() {
    return UbigeoEntity(
      departments: departments.map((e) => e.toEntity()).toList(),
      provinces: provinces.map((e) => e.toEntity()).toList(),
      districts: districts.map((e) => e.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [departments, provinces, districts];
}
