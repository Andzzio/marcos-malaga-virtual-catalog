import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/products_provider.dart';

class ConsumerProductsWidget extends ConsumerWidget {
  final Widget Function(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<ProductEntity>> productsAsync,
  )
  builder;
  const ConsumerProductsWidget({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    return builder(context, ref, productsAsync);
  }
}
