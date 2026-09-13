import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';

abstract class BannersRepository {
  Future<List<BannerEntity>> getBanners();
  Future<void> createBanner(BannerEntity banner);
  Future<void> updateBanner(BannerEntity banner);
  Future<void> deleteBanner(String id);
  Future<void> reorderBanners(List<String> bannerIds);
}
