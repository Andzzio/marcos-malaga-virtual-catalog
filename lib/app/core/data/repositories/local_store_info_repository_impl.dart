import 'package:marcos_malaga_app/app/core/data/datasources/local_store_info_datasource.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_info_entity.dart';
import 'package:marcos_malaga_app/app/core/domain/repositories/store_info_repository.dart';

class LocalStoreInfoRepositoryImpl implements StoreInfoRepository {
  final LocalStoreInfoDatasource datasource;

  LocalStoreInfoRepositoryImpl({required this.datasource});

  @override
  Future<StoreInfoEntity> getStoreInfo() async {
    final model = await datasource.fetchStoreInfo();
    if (model == null) {
      throw Exception('Store info could not be fetched');
    }
    return model.toEntity();
  }
}
