import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_detail_view.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_image_view.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/header_bar.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/home_label.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
          HeaderBar(colorLerp: false),
          SliverToBoxAdapter(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 11,
                  child: SizedBox(
                    height: size.height,
                    child: ProductImageView(product: product),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: SizedBox(
                    height: size.height,
                    child: ProductDetailView(),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 500, child: Placeholder()),
          ),
        ],
      ),
    );
  }
}
