import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:marcos_malaga_app/features/catalog/data/datasources/local_banners_datasource.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/banner_model.dart';

void main() {
  Logger.level = Level.off;
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalBannersDatasource datasource;

  setUp(() {
    datasource = LocalBannersDatasource();
    rootBundle.evict('assets/json/banners.json');
  });

  group('LocalBannersDatasource Tests', () {
    final tJsonString = jsonEncode([
      {
        'id': 'BANNER-001',
        'desktopImageUrl': 'assets/images/banners/banner_1.png',
        'mobileImageUrl': 'assets/images/banners/banner_1.png',
        'title': 'New Arrivals',
        'actionType': 'openCategory',
        'actionValue': 'vestidos',
        'isActive': true,
      },
    ]);

    test(
      'should return a List<BannerModel> when JSON is loaded successfully',
      () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', (ByteData? message) async {
              final String key = utf8.decode(message!.buffer.asUint8List());
              if (key == 'assets/json/banners.json') {
                return ByteData.view(utf8.encoder.convert(tJsonString).buffer);
              }
              return null;
            });

        final result = await datasource.fetchBanners();

        expect(result, isA<List<BannerModel>>());
        expect(result.length, 1);
        expect(result.first.id, 'BANNER-001');
        expect(result.first.title, 'New Arrivals');
      },
    );

    test('should return an empty list when an exception occurs', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
            return null;
          });

      final result = await datasource.fetchBanners();

      expect(result, isA<List<BannerModel>>());
      expect(result, isEmpty);
    });
  });
}
