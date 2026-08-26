import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/states/product_detail_state.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/order_item.dart';
import 'package:marcos_malaga_app/providers/features/checkout/checkout_providers.dart';

class ProductDetailProvider extends Notifier<ProductDetailState> {
  final ProductEntity product;
  ProductDetailProvider(this.product);
  @override
  ProductDetailState build() {
    final initialState = ProductDetailState(product: product, quantity: 1);
    return initialState.copyWith(
      quantity: initialState.selectedSize.stock > 0 ? 1 : 0,
    );
  }

  void selectDesign(int index) {
    final newState = state.copyWith(
      selectedDesignIndex: index,
      selectedSizeIndex: 0,
    );
    state = newState.copyWith(
      quantity: newState.selectedSize.stock > 0 ? 1 : 0,
    );
  }

  void selectSize(int index) {
    final newState = state.copyWith(selectedSizeIndex: index);
    state = newState.copyWith(
      quantity: newState.selectedSize.stock > 0 ? 1 : 0,
    );
  }

  void selectQuantity(int newQuantity) {
    if (newQuantity < 1) return;
    if (newQuantity > state.selectedSize.stock) return;
    state = state.copyWith(quantity: newQuantity);
  }

  Future<void> buyNow(BuildContext context) async {
    final design = state.selectedDesign;
    final size = state.selectedSize;
    if (state.quantity <= 0) return;

    final price = state.product.discountPrice ?? state.product.basePrice;

    final orderItem = OrderItem(
      productId: state.product.id,
      designId: design.id,
      sizeName: size.size,
      quantity: state.quantity,
      productName: state.product.name,
      designName: design.name,
      imageUrl: design.imageUrls.isNotEmpty ? design.imageUrls.first : '',
      unitPrice: price,
      discountPrice: state.product.discountPrice,
    );

    final createSession = ref.read(createCheckoutSessionUseCaseProvider);
    final session = await createSession.call(
      items: [orderItem],
      clearCartOnSuccess: false,
    );

    if (context.mounted) {
      context.go('/checkout/${session.id}');
    }
  }
}

final productDetailProvider = NotifierProvider.family
    .autoDispose<ProductDetailProvider, ProductDetailState, ProductEntity>(
      ProductDetailProvider.new,
    );
