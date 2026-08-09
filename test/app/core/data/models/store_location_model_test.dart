import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/core/data/models/store_location_model.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_location_entity.dart';

void main() {
  group('StoreLocationModel', () {
    const tLatitude = -12.046374;
    const tLongitude = -77.042793;

    test('fromJson should correctly deserialize latitude and longitude', () {
      /// Arrange
      final Map<String, dynamic> jsonMap = {
        'latitude': tLatitude,
        'longitude': tLongitude,
      };

      /// Act
      final result = StoreLocationModel.fromJson(jsonMap);

      /// Assert
      expect(result.latitude, tLatitude);
      expect(result.longitude, tLongitude);
    });

    test('fromJson should handle missing fields with default values', () {
      /// Arrange
      final Map<String, dynamic> jsonMap = {};

      /// Act
      final result = StoreLocationModel.fromJson(jsonMap);

      /// Assert
      expect(result.latitude, 0.0);
      expect(result.longitude, 0.0);
    });

    test('toEntity should return a valid StoreLocationEntity', () {
      /// Arrange
      const tModel = StoreLocationModel(latitude: tLatitude, longitude: tLongitude);

      /// Act
      final result = tModel.toEntity();

      /// Assert
      expect(result, isA<StoreLocationEntity>());
      expect(result.latitude, tLatitude);
      expect(result.longitude, tLongitude);
    });
  });
}
