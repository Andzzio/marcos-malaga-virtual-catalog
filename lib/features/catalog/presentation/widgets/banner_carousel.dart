import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/core/utils/string_capitalize.dart';
import 'package:marcos_malaga_app/app/shared/widgets/image/custom_image.dart';
import 'package:marcos_malaga_app/app/shared/widgets/video/app_video_player.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/banners_provider.dart';
import 'package:marcos_malaga_app/providers/core/core_providers.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerCarousel extends ConsumerStatefulWidget {
  const BannerCarousel({super.key});

  @override
  ConsumerState<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends ConsumerState<BannerCarousel> {
  int currentIndex = 0;

  void _handleBannerTap(BuildContext context, BannerEntity banner) {
    switch (banner.actionType) {
      case BannerActionType.openCategory:
        if (banner.actionValue != null && banner.actionValue!.trim().isNotEmpty) {
          final categoryName = banner.actionValue!.trim().capitalize();
          context.go('/search/catalog?category=$categoryName');
        }
        break;
      case BannerActionType.openProduct:
        if (banner.actionValue != null && banner.actionValue!.trim().isNotEmpty) {
          context.go('/products/${banner.actionValue!.trim()}');
        }
        break;
      case BannerActionType.openUrl:
        if (banner.actionValue != null && banner.actionValue!.trim().isNotEmpty) {
          ref.read(launchExternalUrlUsecaseProvider)(banner.actionValue!.trim());
        }
        break;
      case BannerActionType.none:
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final asyncBanners = ref.watch(bannersProvider);

    return SliverToBoxAdapter(
      child: asyncBanners.when(
        data: (allBanners) {
          final banners = allBanners.where((b) => b.isActive).toList();
          if (banners.isEmpty) return const SizedBox.shrink();

          return Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider.builder(
                itemCount: banners.length,
                options: CarouselOptions(
                  height: ResponsiveTheme.isMobile(context)
                      ? size.height * 0.95 - 15
                      : size.height * 0.95,
                  viewportFraction: 1.0,
                  autoPlay: banners.length > 1,
                  autoPlayInterval: const Duration(seconds: 10),
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final banner = banners[index];
                  final isMobile = ResponsiveTheme.isMobile(context);
                  final mediaUrl = isMobile ? banner.mobileUrl : banner.desktopUrl;
                  final mediaType = isMobile ? banner.mobileMediaType : banner.desktopMediaType;
                  final isAsset = mediaUrl.startsWith('assets/');

                  Widget mediaWidget;
                  if (mediaType == BannerMediaType.video) {
                    mediaWidget = AppVideoPlayer(
                      videoUrl: mediaUrl,
                      fit: BoxFit.cover,
                    );
                  } else {
                    mediaWidget = CustomImage(
                      mediaUrl,
                      isAsset: isAsset,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      quality: ImageQuality.highRes,
                    );
                  }

                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    hitTestBehavior: HitTestBehavior.opaque,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _handleBannerTap(context, banner),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: IgnorePointer(
                          child: mediaWidget,
                        ),
                      ),
                    ),
                  );
                },
              ),
              if (banners.length > 1)
                Positioned(
                  bottom: 30,
                  child: AnimatedSmoothIndicator(
                    activeIndex: currentIndex < banners.length ? currentIndex : 0,
                    count: banners.length,
                    curve: Curves.easeInOut,
                    effect: const WormEffect(
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
          height: 300,
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: const FaIcon(FontAwesomeIcons.circleXmark, color: Colors.grey),
        ),
        loading: () => Container(
          height: 300,
          color: Colors.white,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
