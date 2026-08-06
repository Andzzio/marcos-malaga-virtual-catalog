import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/banners_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/custom_image.dart';

class BannerCarousel extends ConsumerStatefulWidget {
  const BannerCarousel({super.key});

  @override
  ConsumerState<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends ConsumerState<BannerCarousel> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final asyncBanners = ref.watch(bannersProvider);

    return SliverToBoxAdapter(
      child: asyncBanners.when(
        data: (banners) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider.builder(
                itemCount: banners.length,
                options: CarouselOptions(
                  height: size.height * 0.95,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final banner = banners[index];
                  return CustomImage(
                    banner.desktopImageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
              Positioned(
                bottom: 30,
                child: AnimatedSmoothIndicator(
                  activeIndex: currentIndex,
                  count: banners.length,
                  curve: Curves.easeInOut,
                  effect: WormEffect(
                    radius: 2,
                    dotWidth: 10,
                    dotHeight: 10,
                    activeDotColor: Colors.white,
                    spacing: 15,
                  ),
                ),
              ),
            ],
          );
        },
        error: (Object error, StackTrace stackTrace) => Container(
          decoration: BoxDecoration(color: Colors.grey),
          child: FaIcon(FontAwesomeIcons.circleXmark),
        ),
        loading: () => Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
