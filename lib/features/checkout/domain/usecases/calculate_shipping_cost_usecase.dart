class CalculateShippingCostUseCase {
  const CalculateShippingCostUseCase();

  double call({
    required double subtotal,
    required double baseShippingCost,
    double? freeShippingThreshold,
  }) {
    if (freeShippingThreshold != null && subtotal >= freeShippingThreshold) {
      return 0.0;
    }
    return baseShippingCost;
  }
}
