import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';

abstract class BannersRepository {
  Future<List<BannerEntity>> getBanners();
}
