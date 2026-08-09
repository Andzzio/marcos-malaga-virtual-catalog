import 'package:marcos_malaga_app/app/core/domain/entities/store_info_entity.dart';

abstract class StoreInfoRepository {
  Future<StoreInfoEntity> getStoreInfo();
}
