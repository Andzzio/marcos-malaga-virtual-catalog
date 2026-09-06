import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_entity.dart';

abstract class OrderRepository {
  Future<void> createOrder(OrderEntity order);
}
