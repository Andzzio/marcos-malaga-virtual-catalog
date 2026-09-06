import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/ubigeo_entities.dart';

class DistrictModel extends Equatable {
  final String code;
  final String name;
  final String provinceCode;

  const DistrictModel({
    required this.code,
    required this.name,
    required this.provinceCode,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      provinceCode: json['provinceCode'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name, 'provinceCode': provinceCode};
  }

  DistrictModel copyWith({String? code, String? name, String? provinceCode}) {
    return DistrictModel(
      code: code ?? this.code,
      name: name ?? this.name,
      provinceCode: provinceCode ?? this.provinceCode,
    );
  }

  DistrictEntity toEntity() {
    return DistrictEntity(code: code, name: name, provinceCode: provinceCode);
  }

  @override
  List<Object?> get props => [code, name, provinceCode];
}
