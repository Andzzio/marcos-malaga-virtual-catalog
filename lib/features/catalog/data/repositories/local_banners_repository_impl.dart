import 'package:marcos_malaga_app/features/catalog/data/datasources/local_banners_datasource.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/banner_model.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';

class LocalBannersRepositoryImpl implements BannersRepository {
  final LocalBannersDatasource datasource;
  final List<BannerEntity> _cache = [];

  LocalBannersRepositoryImpl({required this.datasource});

  @override
  Future<List<BannerEntity>> getBanners() async {
    if (_cache.isNotEmpty) return List.unmodifiable(_cache);
    final List<BannerModel> bannersModels = await datasource.fetchBanners();
    _cache.clear();
    _cache.addAll(bannersModels.map((b) => b.toEntity()));
    return List.unmodifiable(_cache);
  }

  @override
  Future<void> createBanner(BannerEntity banner) async {
    _cache.add(banner);
  }

  @override
  Future<void> updateBanner(BannerEntity banner) async {
    final index = _cache.indexWhere((b) => b.id == banner.id);
    if (index != -1) {
      _cache[index] = banner;
    }
  }

  @override
  Future<void> deleteBanner(String id) async {
    _cache.removeWhere((b) => b.id == id);
  }

  @override
  Future<void> reorderBanners(List<String> bannerIds) async {
    final reordered = <BannerEntity>[];
    for (final id in bannerIds) {
      final banner = _cache.firstWhere((b) => b.id == id, orElse: () => _cache.first);
      reordered.add(banner);
    }
    _cache.clear();
    _cache.addAll(reordered);
  }
}
