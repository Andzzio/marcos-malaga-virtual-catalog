import 'package:marcos_malaga_app/features/checkout/domain/entities/billing_address.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/order_entity.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/order_status.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';
import 'package:marcos_malaga_app/features/checkout/domain/repositories/order_repository.dart';

class CreateOrderUseCase {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  Future<void> call({
    OrderEntity? customOrder,
    CheckoutSession? session,
    CustomerInfo? customer,
    ShippingAddress? shipping,
    BillingAddress? billing,
    String? paymentMethodId,
    DeliveryType? deliveryType,
    String? shippingMethodId,
    double? shippingCost,
    String? notes,
  }) async {
    if (customOrder != null) {
      return repository.createOrder(customOrder);
    }

    if (session == null) {
      throw Exception('Sesión de checkout no disponible');
    }
    if (customer == null) {
      throw Exception('Datos de cliente incompletos');
    }
    if (deliveryType == DeliveryType.shipping && shipping == null) {
      throw Exception('Dirección de envío incompleta');
    }
    if (paymentMethodId == null || paymentMethodId.isEmpty) {
      throw Exception('Método de pago no seleccionado');
    }

    final items = session.items;

    final subtotal = items.fold<double>(
      0,
      (sum, item) =>
          sum + ((item.discountPrice ?? item.unitPrice) * item.quantity),
    );
    final finalShippingCost = shippingCost ?? 0.0;

    final order = OrderEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderCode:
          'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      customer: customer,
      shipping: shipping,
      billing: billing,
      items: items,
      subtotal: subtotal,
      shippingCost: finalShippingCost,
      total: subtotal + finalShippingCost,
      paymentMethodId: paymentMethodId,
      shippingMethodId: shippingMethodId,
      status: OrderStatus.pending,
      deliveryType: deliveryType ?? DeliveryType.shipping,
      notes: notes,
      createdAt: DateTime.now(),
    );

    return repository.createOrder(order);
  }
}
