import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/order_repository.dart';
import 'package:marcos_malaga_app/app/shared/data/datasources/order/local_order_datasource.dart';
import 'package:marcos_malaga_app/app/shared/data/models/order/order_model.dart';

class LocalOrderRepositoryImpl implements OrderRepository {
  final LocalOrderDatasource datasource;

  LocalOrderRepositoryImpl(this.datasource);

  @override
  Future<void> createOrder(OrderEntity order) async {
    final orderModel = OrderModel.fromEntity(order);
    await datasource.saveOrder(orderModel);
  }
}
