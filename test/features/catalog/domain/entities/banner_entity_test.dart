import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';

void main() {
  const tBanner = BannerEntity(
    id: 'BANNER-001',
    desktopImageUrl: 'assets/images/banners/banner_1.png',
    mobileImageUrl: 'assets/images/banners/banner_1.png',
    title: 'New Arrivals: Warmer Days Ahead',
    actionType: BannerActionType.openCategory,
    actionValue: 'vestidos',
    isActive: true,
  );

  group('BannerEntity Tests', () {
    test('should be a subclass of Equatable and support value equality', () {
      const tBanner2 = BannerEntity(
        id: 'BANNER-001',
        desktopImageUrl: 'assets/images/banners/banner_1.png',
        mobileImageUrl: 'assets/images/banners/banner_1.png',
        title: 'New Arrivals: Warmer Days Ahead',
        actionType: BannerActionType.openCategory,
        actionValue: 'vestidos',
        isActive: true,
      );

      expect(tBanner, equals(tBanner2));
    });

    test('should return a new BannerEntity with copyWith', () {
      final updatedBanner = tBanner.copyWith(isActive: false, title: 'Updated Title');

      expect(updatedBanner.isActive, false);
      expect(updatedBanner.title, 'Updated Title');
      expect(updatedBanner.id, 'BANNER-001'); 
    });
  });
}
