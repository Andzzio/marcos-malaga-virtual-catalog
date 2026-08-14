import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/states/product_detail_state.dart';

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
}

final productDetailProvider = NotifierProvider.family
    .autoDispose<ProductDetailProvider, ProductDetailState, ProductEntity>(
      ProductDetailProvider.new,
    );
