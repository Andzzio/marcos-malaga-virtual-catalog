import 'package:marcos_malaga_app/app/core/domain/entities/store_info_entity.dart';
import 'package:marcos_malaga_app/app/core/domain/repositories/store_info_repository.dart';

class GetStoreInfoUsecase {
  final StoreInfoRepository repo;

  GetStoreInfoUsecase({required this.repo});

  Future<StoreInfoEntity> call() async {
    return await repo.getStoreInfo();
  }
}
