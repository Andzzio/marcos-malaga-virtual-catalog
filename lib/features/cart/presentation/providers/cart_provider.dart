import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/add_to_cart_result.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:marcos_malaga_app/features/cart/presentation/states/cart_state.dart';
import 'package:marcos_malaga_app/features/cart/presentation/states/cart_display_item.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';
import 'package:marcos_malaga_app/providers/features/cart/cart_providers.dart';
import 'package:marcos_malaga_app/providers/features/checkout/checkout_providers.dart';

class CartProvider extends AsyncNotifier<CartState> {
  @override
  FutureOr<CartState> build() async {
    final getCart = ref.watch(getCartUsecaseProvider);
    final cart = await getCart();

    final products = await ref.watch(productsProvider.future);

    final displayItems = <CartDisplayItem>[];
    for (final item in cart.items) {
      final product = products.where((p) => p.id == item.productId).firstOrNull;
      if (product == null) continue;

      final design = product.designs
          .where((d) => d.id == item.designId)
          .firstOrNull;
      if (design == null) continue;

      final size = design.sizes
          .where((s) => s.size == item.sizeName)
          .firstOrNull;
      if (size == null) continue;

      final unitPrice = product.discountPrice ?? product.basePrice;

      displayItems.add(
        CartDisplayItem(
          cartItemId: item.id,
          productId: item.productId,
          designId: item.designId,
          productName: product.name,
          designName: design.name,
          sizeName: item.sizeName,
          thumbnailUrl: design.imageUrls.isNotEmpty
              ? design.imageUrls.first
              : '',
          basePrice: product.basePrice,
          discountPrice: product.discountPrice,
          unitPrice: unitPrice,
          quantity: item.quantity,
          stock: size.stock,
        ),
      );
    }

    return CartState(items: displayItems);
  }

  String _compositeId(String productId, String designId, String sizeName) {
    return '${productId}_${designId}_$sizeName';
  }

  Future<AddToCartResult> addItem({
    required String productId,
    required String designId,
    required String sizeName,
    required int quantity,
    required int maxStock,
  }) async {
    final addUseCase = ref.read(addCartItemUsecaseProvider);
    final newItem = CartItemEntity(
      id: _compositeId(productId, designId, sizeName),
      productId: productId,
      designId: designId,
      sizeName: sizeName,
      quantity: quantity,
    );
    final result = await addUseCase(newItem, maxStock: maxStock);
    ref.invalidateSelf();
    await future;
    return result;
  }

  Future<void> removeItem(String cartItemId) async {
    final removeUseCase = ref.read(removeCartItemUsecaseProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await removeUseCase(cartItemId);
      ref.invalidateSelf();
      return await future;
    });
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    final updateUseCase = ref.read(updateCartItemQuantityUsecaseProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await updateUseCase(cartItemId, newQuantity);
      ref.invalidateSelf();
      return await future;
    });
  }

  Future<void> proceedToCheckout(BuildContext context) async {
    final currentState = state.value;
    if (currentState == null || currentState.items.isEmpty) return;

    final orderItems = currentState.items.map((item) {
      return OrderItem(
        productId: item.productId,
        designId: item.designId,
        sizeName: item.sizeName,
        quantity: item.quantity,
        productName: item.productName,
        designName: item.designName,
        imageUrl: item.thumbnailUrl,
        unitPrice: item.unitPrice,
        discountPrice: item.discountPrice,
      );
    }).toList();

    final createSession = ref.read(createCheckoutSessionUseCaseProvider);
    final session = await createSession.call(
      items: orderItems,
      clearCartOnSuccess: true,
    );

    if (context.mounted) {
      context.go('/checkout/${session.id}');
    }
  }

  Future<void> clearCart() async {
    // Empty implementation for simplicity
  }
}

final cartProvider = AsyncNotifierProvider<CartProvider, CartState>(
  CartProvider.new,
);
