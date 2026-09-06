import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/ubigeo_entities.dart';

class DepartmentModel extends Equatable {
  final String code;
  final String name;

  const DepartmentModel({required this.code, required this.name});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name};
  }

  DepartmentModel copyWith({String? code, String? name}) {
    return DepartmentModel(code: code ?? this.code, name: name ?? this.name);
  }

  DepartmentEntity toEntity() {
    return DepartmentEntity(code: code, name: name);
  }

  @override
  List<Object?> get props => [code, name];
}
