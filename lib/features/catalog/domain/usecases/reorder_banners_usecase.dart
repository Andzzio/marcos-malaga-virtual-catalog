import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';

class ReorderBannersUsecase {
  final BannersRepository repo;
  ReorderBannersUsecase({required this.repo});

  Future<void> call(List<String> bannerIds) async {
    return await repo.reorderBanners(bannerIds);
  }
}
