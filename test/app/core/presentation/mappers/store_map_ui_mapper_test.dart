import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_info_entity.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_location_entity.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_schedule_entity.dart';
import 'package:marcos_malaga_app/app/core/presentation/mappers/store_map_ui_mapper.dart';

void main() {
  group('StoreMapUiMapper', () {
    test('fromEntity should correctly convert StoreInfoEntity to StoreMapUiModel', () {
      /// Arrange
      const tLatitude = -12.046374;
      const tLongitude = -77.042793;
      
      const tLocation = StoreLocationEntity(
        latitude: tLatitude,
        longitude: tLongitude,
      );

      const tSchedule = StoreScheduleEntity(
        regularHours: [],
        exceptions: [],
        timeZone: 'America/Lima',
      );

      const tStoreInfo = StoreInfoEntity(
        address: 'Test Address',
        reference: 'Test Reference',
        ruc: '10123456789',
        businessName: 'Test Business',
        whatsappNumber: '999999999',
        schedule: tSchedule,
        location: tLocation,
      );

      /// Act
      final result = StoreMapUiMapper.fromEntity(tStoreInfo);

      /// Assert
      expect(result.coordinates, isA<LatLng>());
      expect(result.coordinates.latitude, tLatitude);
      expect(result.coordinates.longitude, tLongitude);
    });
  });
}
