import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_grid.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/banner_carousel.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/header_bar.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/home_label.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
          SliverStack(
            children: [
              SliverMainAxisGroup(
                slivers: [
                  BannerCarousel(),
                  HomeLabel(label: "DESCUENTOS 2 X 1 POR INAUGURACIÓN"),
                  SliverGap(50),
                  ProductGrid(),
                  SliverGap(50),
                ],
              ),
              SliverPositioned(child: HeaderBar()),
            ],
          ),
        ],
      ),
    );
  }
}
