import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ProductGrid extends ConsumerWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'NUESTROS',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    'NUEVOS PRODUCTOS',
                    style: Theme.of(
                      context,
                    ).textTheme.displayMedium?.copyWith(fontSize: 18),
                  ),
                  Gap(30),
                ],
              ),
            ),
          ),
        ),
        SliverCrossAxisConstrained(
          maxCrossAxisExtent: 1500,
          child: SliverGrid.builder(
            itemCount: 8,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 60,
              crossAxisSpacing: 15,
              childAspectRatio: 0.55,
            ),
            itemBuilder: (context, index) {
              return productsAsync.when(
                data: (products) {
                  final product = products[index];
                  return ProductCard(product: product);
                },
                error: (error, stackTrace) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Center(
                        child: FaIcon(FontAwesomeIcons.circleXmark),
                      ),
                    ),
                  );
                },
                loading: () {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
