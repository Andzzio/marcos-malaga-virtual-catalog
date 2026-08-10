import 'package:marcos_malaga_app/app/core/domain/entities/store_location_entity.dart';

class StoreLocationModel {
  final double latitude;
  final double longitude;

  const StoreLocationModel({required this.latitude, required this.longitude});

  factory StoreLocationModel.fromJson(Map<String, dynamic> json) {
    return StoreLocationModel(
      latitude: json['latitude'] as double? ?? 0.0,
      longitude: json['longitude'] as double? ?? 0.0,
    );
  }

  StoreLocationEntity toEntity() {
    return StoreLocationEntity(latitude: latitude, longitude: longitude);
  }
}
