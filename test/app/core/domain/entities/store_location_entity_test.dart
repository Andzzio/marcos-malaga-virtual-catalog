import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_location_entity.dart';

void main() {
  group('StoreLocationEntity', () {
    test('should be equal when latitude and longitude are the same', () {
      /// Arrange
      const tLocation1 = StoreLocationEntity(latitude: -12.046374, longitude: -77.042793);
      const tLocation2 = StoreLocationEntity(latitude: -12.046374, longitude: -77.042793);

      /// Act & Assert
      expect(tLocation1, equals(tLocation2));
    });

    test('should not be equal when latitude or longitude are different', () {
      /// Arrange
      const tLocation1 = StoreLocationEntity(latitude: -12.046374, longitude: -77.042793);
      const tLocation2 = StoreLocationEntity(latitude: -12.046375, longitude: -77.042793);
      const tLocation3 = StoreLocationEntity(latitude: -12.046374, longitude: -77.042794);

      /// Act & Assert
      expect(tLocation1, isNot(equals(tLocation2)));
      expect(tLocation1, isNot(equals(tLocation3)));
    });

    test('props should return [latitude, longitude]', () {
      /// Arrange
      const latitude = -12.046374;
      const longitude = -77.042793;
      const tLocation = StoreLocationEntity(latitude: latitude, longitude: longitude);

      /// Act
      final result = tLocation.props;

      /// Assert
      expect(result, [latitude, longitude]);
    });
  });
}
