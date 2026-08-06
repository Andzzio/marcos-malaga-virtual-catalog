import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/banner_model.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';

void main() {
  const tBannerModel = BannerModel(
    id: 'BANNER-001',
    desktopImageUrl: 'assets/images/banners/banner_1.png',
    mobileImageUrl: 'assets/images/banners/banner_1.png',
    title: 'New Arrivals: Warmer Days Ahead',
    actionType: 'openCategory',
    actionValue: 'vestidos',
    isActive: true,
  );

  const tBannerEntity = BannerEntity(
    id: 'BANNER-001',
    desktopImageUrl: 'assets/images/banners/banner_1.png',
    mobileImageUrl: 'assets/images/banners/banner_1.png',
    title: 'New Arrivals: Warmer Days Ahead',
    actionType: BannerActionType.openCategory,
    actionValue: 'vestidos',
    isActive: true,
  );

  final tJson = {
    'id': 'BANNER-001',
    'desktopImageUrl': 'assets/images/banners/banner_1.png',
    'mobileImageUrl': 'assets/images/banners/banner_1.png',
    'title': 'New Arrivals: Warmer Days Ahead',
    'actionType': 'openCategory',
    'actionValue': 'vestidos',
    'isActive': true,
  };

  group('BannerModel Tests', () {
    test('should correctly parse from JSON', () {
      final result = BannerModel.fromJson(tJson);
      expect(result.id, tBannerModel.id);
      expect(result.actionType, tBannerModel.actionType);
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
      expect(result.actionType, tBannerModel.actionType);
    });
  });
}
