import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/footer_bar.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/related_products.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_view.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
          HeaderBar(colorLerp: false),
          ProductView(product: product),
          SliverGap(30),
          RelatedProducts(),
          SliverGap(50),
          FooterBar(),
        ],
      ),
    );
  }
}
