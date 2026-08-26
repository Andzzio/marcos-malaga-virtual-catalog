import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<void> createOrder(OrderEntity order);
}
