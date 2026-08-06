import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';

class GetBannersUsecase {
  final BannersRepository repo;
  GetBannersUsecase({required this.repo});

  Future<List<BannerEntity>> call() async {
    return await repo.getBanners();
  }
}
