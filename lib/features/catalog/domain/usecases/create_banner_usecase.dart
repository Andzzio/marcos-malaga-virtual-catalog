import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';

class CreateBannerUsecase {
  final BannersRepository repo;
  CreateBannerUsecase({required this.repo});

  Future<void> call(BannerEntity banner) async {
    return await repo.createBanner(banner);
  }
}
