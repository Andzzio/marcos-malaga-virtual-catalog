import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/widgets/image/custom_image.dart';
import 'package:photo_view/photo_view.dart';

class ProductImageView extends StatefulWidget {
  final ProductEntity product;
  final String heroPrefix;
  final BoxFit fit;
  const ProductImageView({
    super.key,
    required this.product,
    this.heroPrefix = 'detail',
    this.fit = BoxFit.contain,
  });

  @override
  State<ProductImageView> createState() => _ProductImageViewState();
}

class _ProductImageViewState extends State<ProductImageView> {
  List<String> get images =>
      widget.product.designs.expand((d) => d.imageUrls).toList();
  late PageController _pageController;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (_pageController.hasClients) {
      _currentPage = _pageController.page!.toInt();
    }
  }

  void _openInteractionImageView({required String imageUrl}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black.withValues(alpha: 0.7),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Material(
            type: MaterialType.transparency,
            child: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(color: Colors.transparent),
                  ),
                  Center(
                    child: PhotoView(
                      tightMode: true,
                      imageProvider: AssetImage(imageUrl),
                      heroAttributes: PhotoViewHeroAttributes(
                        tag:
                            '${widget.heroPrefix}_photo_view_${widget.product.id}',
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      color: Colors.white,
                      icon: FaIcon(FontAwesomeIcons.x),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 9,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 9,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (newPage) {
                  setState(() {
                    _currentPage = newPage;
                  });
                },
                itemBuilder: (context, index) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        _openInteractionImageView(imageUrl: images[index]);
                      },
                      child: Hero(
                        tag:
                            '${widget.heroPrefix}_photo_view_${widget.product.id}',
                        child: CustomImage(images[index], fit: widget.fit),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                left: 10,
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.arrowLeft),
                  onPressed: () {
                    if (_pageController.hasClients) {
                      int nextPage = _pageController.page!.toInt() - 1;
                      if (nextPage < 0) {
                        nextPage = images.length - 1;
                      }
                      _pageController.animateToPage(
                        nextPage,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubicEmphasized,
                      );
                    }
                  },
                ),
              ),
              Positioned(
                right: 10,
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.arrowRight),
                  onPressed: () {
                    if (_pageController.hasClients) {
                      int nextPage = _pageController.page!.toInt() + 1;
                      if (nextPage >= images.length) {
                        nextPage = 0;
                      }
                      _pageController.animateToPage(
                        nextPage,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubicEmphasized,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: images.length,
            separatorBuilder: (context, index) => Gap(4),
            itemBuilder: (context, index) {
              final image = images[index];
              final isSelected = index == _currentPage;
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (_pageController.hasClients) {
                      _pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubicEmphasized,
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: CustomImage(image),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
