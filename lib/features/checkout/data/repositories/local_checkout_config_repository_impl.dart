import '../../domain/repositories/checkout_config_repository.dart';
import '../../domain/entities/checkout_config_entity.dart';
import '../../domain/entities/ubigeo_entities.dart';
import '../datasources/local_checkout_config_datasource.dart';

class LocalCheckoutConfigRepositoryImpl implements CheckoutConfigRepository {
  final LocalCheckoutConfigDatasource datasource;

  LocalCheckoutConfigRepositoryImpl(this.datasource);

  @override
  Future<UbigeoEntity> getUbigeo() async {
    final model = await datasource.getUbigeo();
    return model.toEntity();
  }

  @override
  Future<CheckoutConfigEntity> getCheckoutConfig() async {
    final model = await datasource.getCheckoutConfig();
    return model.toEntity();
  }
}
