import 'package:marcos_malaga_app/features/checkout/data/datasources/local_checkout_session_datasource.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';
import 'package:marcos_malaga_app/features/checkout/domain/repositories/checkout_session_repository.dart';

class LocalCheckoutSessionRepositoryImpl implements CheckoutSessionRepository {
  final LocalCheckoutSessionDatasource datasource;

  const LocalCheckoutSessionRepositoryImpl(this.datasource);

  @override
  Future<CheckoutSession> createSession({
    required List<OrderItem> items,
    required bool clearCartOnSuccess,
  }) async {
    final model = await datasource.createSession(
      items: items,
      clearCartOnSuccess: clearCartOnSuccess,
    );
    return model.toEntity();
  }

  @override
  Future<CheckoutSession?> getSession(String id) async {
    final model = await datasource.getSession(id);
    return model?.toEntity();
  }

  @override
  Future<void> deleteSession(String id) {
    return datasource.deleteSession(id);
  }
}
