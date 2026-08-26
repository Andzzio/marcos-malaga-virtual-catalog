import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/ubigeo_entities.dart';

class ProvinceModel extends Equatable {
  final String code;
  final String name;
  final String departmentCode;

  const ProvinceModel({
    required this.code,
    required this.name,
    required this.departmentCode,
  });

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      departmentCode: json['departmentCode'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'departmentCode': departmentCode,
    };
  }

  ProvinceModel copyWith({
    String? code,
    String? name,
    String? departmentCode,
  }) {
    return ProvinceModel(
      code: code ?? this.code,
      name: name ?? this.name,
      departmentCode: departmentCode ?? this.departmentCode,
    );
  }

  ProvinceEntity toEntity() {
    return ProvinceEntity(
      code: code,
      name: name,
      departmentCode: departmentCode,
    );
  }

  @override
  List<Object?> get props => [code, name, departmentCode];
}
