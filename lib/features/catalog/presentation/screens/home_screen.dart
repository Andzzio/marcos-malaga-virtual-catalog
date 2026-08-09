import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/footer_bar.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/map_view.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/consumer_products_widget.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_grid.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/banner_carousel.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_view.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/title_section.dart';
import 'package:shimmer/shimmer.dart';
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
                  ProductGrid<ProductsProvider>(
                    itemCount: 8,
                    productsProvider: productsProvider,
                    titleSection: TitleSection(
                      topLabel: 'NUESTROS',
                      bottomLabel: 'NUEVOS PRODUCTOS',
                    ),
                    maxWidth: 1500,
                  ),
                  SliverGap(50),
                  ConsumerProductsWidget(
                    builder: (context, ref, productsAsync) {
                      return productsAsync.when(
                        data: (products) {
                          final heroProduct = products.first;
                          return ProductView(
                            product: heroProduct,
                            maxWidth: 1500,
                            heroPrefix: 'home',
                            titleSection: TitleSection(
                              topLabel: 'CONOCE NUESTRO',
                              bottomLabel: 'PRODUCTO MÁS VENDIDO',
                            ),
                          );
                        },
                        error: (error, stackTrace) =>
                            Center(child: FaIcon(FontAwesomeIcons.circleXmark)),
                        loading: () {
                          final size = MediaQuery.of(context).size;
                          return SliverToBoxAdapter(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 11,
                                  child: SizedBox(
                                    height: size.height,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 9,
                                  child: SizedBox(
                                    height: size.height,
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SliverGap(50),
                  MapView(
                    titleSection: TitleSection(
                      topLabel: 'MIRA',
                      bottomLabel: 'COMO ENCONTRARNOS',
                    ),
                  ),
                  FooterBar(),
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
