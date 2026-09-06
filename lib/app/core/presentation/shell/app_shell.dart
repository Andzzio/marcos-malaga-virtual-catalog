import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/features/cart/presentation/widgets/cart_view.dart';
import 'package:marcos_malaga_app/app/shared/widgets/bottom/bottom_bar.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final bool hideBottomElements;

  const AppShell({
    super.key,
    required this.navigationShell,
    this.hideBottomElements = false,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hideController;
  late final Animation<double> _hideAnimation;
  final double _hideOffset = 130;
  @override
  void initState() {
    super.initState();
    _hideController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _hideAnimation = CurvedAnimation(
      parent: _hideController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _hideController.dispose();
    super.dispose();
  }

  Widget _hideAnimationWrapper({required Widget child}) {
    return AnimatedBuilder(
      animation: _hideAnimation,
      builder: (context, child) {
        final dy = _hideOffset * (1 - _hideController.value);
        return Transform.translate(
          offset: Offset(0, dy),
          child: FadeTransition(opacity: _hideAnimation, child: child),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveTheme.isMobile(context);
    final showBottomElements = isMobile && !widget.hideBottomElements;
    return Scaffold(
      extendBody: isMobile,
      floatingActionButton: showBottomElements
          ? _hideAnimationWrapper(child: _buildFab(context))
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: showBottomElements
          ? _hideAnimationWrapper(
              child: BottomBar(navigationShell: widget.navigationShell),
            )
          : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis != Axis.vertical) {
            return false;
          }
          if (notification.metrics.pixels <= 0) {
            if (_hideController.value != 0) {
              _hideController.value = 0;
              return false;
            }
          }
          if (notification is ScrollUpdateNotification) {
            final delta = notification.scrollDelta ?? 0.0;
            if (delta != 0) {
              final scrollProgress =
                  _hideController.value - (delta / _hideOffset);
              _hideController.value = scrollProgress.clamp(0.0, 1.0);
            }
          }
          if (notification is ScrollEndNotification) {
            if (_hideController.value < 1.0 && _hideController.value > 0.0) {
              if (_hideController.value >= 0.3) {
                _hideController.forward();
              } else {
                _hideController.reverse();
              }
            }
          }
          return false;
        },
        child: widget.navigationShell,
      ),
      endDrawer: Drawer(
        width: ResponsiveTheme.isMobile(context)
            ? MediaQuery.of(context).size.width * 0.85
            : ResponsiveTheme.isTablet(context)
            ? 400
            : 400,
        child: SafeArea(child: CartView()),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      shape: const CircleBorder(),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          useSafeArea: true,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8),
          ),
          builder: (context) {
            return CartView();
          },
        );
      },
      child: const FaIcon(FontAwesomeIcons.cartShopping, color: Colors.white),
    );
  }
}
