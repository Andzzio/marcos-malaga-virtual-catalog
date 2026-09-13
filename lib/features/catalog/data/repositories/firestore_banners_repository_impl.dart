import 'package:marcos_malaga_app/features/catalog/data/datasources/firestore_banners_datasource.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/banner_model.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';

class FirestoreBannersRepositoryImpl implements BannersRepository {
  final FirestoreBannersDatasource datasource;

  FirestoreBannersRepositoryImpl({required this.datasource});

  @override
  Future<List<BannerEntity>> getBanners() async {
    final models = await datasource.fetchBanners();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> createBanner(BannerEntity banner) async {
    final model = BannerModel.fromEntity(banner);
    await datasource.createBanner(model);
  }

  @override
  Future<void> updateBanner(BannerEntity banner) async {
    final model = BannerModel.fromEntity(banner);
    await datasource.updateBanner(model);
  }

  @override
  Future<void> deleteBanner(String id) async {
    await datasource.deleteBanner(id);
  }

  @override
  Future<void> reorderBanners(List<String> bannerIds) async {
    await datasource.saveBannersOrder(bannerIds);
  }
}
