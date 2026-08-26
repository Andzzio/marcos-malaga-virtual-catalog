import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/local_order_datasource.dart';
import '../models/order_model.dart';

class LocalOrderRepositoryImpl implements OrderRepository {
  final LocalOrderDatasource datasource;

  LocalOrderRepositoryImpl(this.datasource);

  @override
  Future<void> createOrder(OrderEntity order) async {
    final orderModel = order is OrderModel
        ? order
        : OrderModel.fromEntity(order);
    await datasource.saveOrder(orderModel);
  }
}
