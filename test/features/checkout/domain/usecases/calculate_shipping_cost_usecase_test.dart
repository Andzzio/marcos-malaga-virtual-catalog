import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/calculate_shipping_cost_usecase.dart';

void main() {
  late CalculateShippingCostUseCase useCase;

  setUp(() {
    useCase = const CalculateShippingCostUseCase();
  });

  group('CalculateShippingCostUseCase', () {
    test('should return 0.0 when subtotal meets freeShippingThreshold', () {
      final result = useCase(
        subtotal: 150.0,
        baseShippingCost: 15.0,
        freeShippingThreshold: 150.0,
      );

      expect(result, 0.0);
    });

    test('should return 0.0 when subtotal exceeds freeShippingThreshold', () {
      final result = useCase(
        subtotal: 200.0,
        baseShippingCost: 15.0,
        freeShippingThreshold: 150.0,
      );

      expect(result, 0.0);
    });

    test('should return baseShippingCost when subtotal is below freeShippingThreshold', () {
      final result = useCase(
        subtotal: 149.99,
        baseShippingCost: 15.0,
        freeShippingThreshold: 150.0,
      );

      expect(result, 15.0);
    });

    test('should return baseShippingCost when freeShippingThreshold is null', () {
      final result = useCase(
        subtotal: 500.0,
        baseShippingCost: 20.0,
        freeShippingThreshold: null,
      );

      expect(result, 20.0);
    });
  });
}
