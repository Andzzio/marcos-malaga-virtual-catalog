import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/banner_model.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';

void main() {
  const tBannerModel = BannerModel(
    id: 'BANNER-001',
    desktopUrl: 'assets/images/banners/banner_1.png',
    desktopMediaType: 'image',
    mobileUrl: 'assets/images/banners/banner_1.png',
    mobileMediaType: 'image',
    title: 'New Arrivals: Warmer Days Ahead',
    actionType: 'openCategory',
    actionValue: 'vestidos',
    isActive: true,
    index: 0,
  );

  const tBannerEntity = BannerEntity(
    id: 'BANNER-001',
    desktopUrl: 'assets/images/banners/banner_1.png',
    desktopMediaType: BannerMediaType.image,
    mobileUrl: 'assets/images/banners/banner_1.png',
    mobileMediaType: BannerMediaType.image,
    title: 'New Arrivals: Warmer Days Ahead',
    actionType: BannerActionType.openCategory,
    actionValue: 'vestidos',
    isActive: true,
    index: 0,
  );

  final tJson = {
    'id': 'BANNER-001',
    'title': 'New Arrivals: Warmer Days Ahead',
    'desktopUrl': 'assets/images/banners/banner_1.png',
    'desktopMediaType': 'image',
    'mobileUrl': 'assets/images/banners/banner_1.png',
    'mobileMediaType': 'image',
    'actionType': 'openCategory',
    'actionValue': 'vestidos',
    'isActive': true,
    'index': 0,
  };

  final tLegacyJson = {
    'id': 'BANNER-001',
    'desktopImageUrl': 'assets/images/banners/banner_1.png',
    'mobileImageUrl': 'assets/images/banners/banner_1.png',
    'title': 'New Arrivals: Warmer Days Ahead',
    'actionType': 'openCategory',
    'actionValue': 'vestidos',
    'isActive': true,
  };

  group('BannerModel Tests', () {
    test('should correctly parse from modern JSON', () {
      final result = BannerModel.fromJson(tJson);
      expect(result.id, tBannerModel.id);
      expect(result.desktopUrl, tBannerModel.desktopUrl);
      expect(result.desktopMediaType, 'image');
      expect(result.mobileUrl, tBannerModel.mobileUrl);
      expect(result.mobileMediaType, 'image');
      expect(result.actionType, tBannerModel.actionType);
      expect(result.index, 0);
    });

    test('should correctly parse from legacy JSON with fallback to desktopImageUrl and mobileImageUrl', () {
      final result = BannerModel.fromJson(tLegacyJson);
      expect(result.id, 'BANNER-001');
      expect(result.desktopUrl, 'assets/images/banners/banner_1.png');
      expect(result.desktopMediaType, 'image');
      expect(result.mobileUrl, 'assets/images/banners/banner_1.png');
      expect(result.mobileMediaType, 'image');
    });

    test('should parse video media types correctly', () {
      final videoJson = {
        'id': 'BANNER-VID',
        'desktopUrl': 'https://example.com/desktop.mp4',
        'desktopMediaType': 'video',
        'mobileUrl': 'https://example.com/mobile.jpg',
        'mobileMediaType': 'image',
        'actionType': 'none',
        'isActive': true,
      };

      final result = BannerModel.fromJson(videoJson);
      expect(result.desktopMediaType, 'video');
      expect(result.desktopUrl, 'https://example.com/desktop.mp4');
      expect(result.mobileMediaType, 'image');
      expect(result.mobileUrl, 'https://example.com/mobile.jpg');
    });

    test('should correctly serialize to JSON', () {
      final result = tBannerModel.toJson();
      expect(result, equals(tJson));
    });

    test('should correctly map to BannerEntity', () {
      final result = tBannerModel.toEntity();
      expect(result, equals(tBannerEntity));
    });

    test('should correctly map from BannerEntity', () {
      final result = BannerModel.fromEntity(tBannerEntity);
      expect(result.id, tBannerModel.id);
      expect(result.desktopUrl, tBannerModel.desktopUrl);
      expect(result.actionType, tBannerModel.actionType);
    });
  });
}
