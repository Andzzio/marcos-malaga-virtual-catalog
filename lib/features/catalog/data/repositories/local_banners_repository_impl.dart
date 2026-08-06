import 'package:marcos_malaga_app/features/catalog/data/datasources/local_banners_datasource.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/banner_model.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';

class LocalBannersRepositoryImpl implements BannersRepository {
  final LocalBannersDatasource datasource;
  LocalBannersRepositoryImpl({required this.datasource});

  @override
  Future<List<BannerEntity>> getBanners() async {
    final List<BannerModel> bannersModels = await datasource.fetchBanners();
    return bannersModels.map((b) => b.toEntity()).toList();
  }
}
