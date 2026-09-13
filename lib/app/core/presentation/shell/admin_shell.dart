import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/config/theme/app_theme.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/image/custom_image.dart';

class AdminShell extends StatelessWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);

    if (ResponsiveTheme.isMobile(context)) {
      return Scaffold(
        drawer: _AdminDrawer(style: style),
        appBar: AppBar(
          leading: Builder(
            builder: (scaffoldCtx) {
              return IconButton(
                icon: FaIcon(FontAwesomeIcons.bars),
                onPressed: () {
                  Scaffold.of(scaffoldCtx).openDrawer();
                },
              );
            },
          ),
        ),
        body: child,
      );
    }
    return Scaffold(
      body: Row(
        children: [
          _AdminSidebar(style: style),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _AdminDrawer extends StatelessWidget {
  final TextStyle? style;
  const _AdminDrawer({this.style});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadiusGeometry.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CustomImage('assets/icons/app_icon.png', isAsset: true),
                    ),
                  ),
                  Text(
                    'MARCOS MÁLAGA',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _AdminNavItems(style: style)),
          ],
        ),
      ),
    );
  }
}

class _AdminSidebar extends StatelessWidget {
  final TextStyle? style;
  const _AdminSidebar({this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        border: Border(right: BorderSide(color: Colors.black12)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadiusGeometry.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CustomImage('assets/icons/app_icon.png', isAsset: true),
                    ),
                  ),
                  Text(
                    'MARCOS MÁLAGA',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _AdminNavItems(style: style)),
          ],
        ),
      ),
    );
  }
}

class _AdminNavItems extends StatelessWidget {
  final TextStyle? style;
  const _AdminNavItems({this.style});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _AdminNavItem(
          style: style,
          icon: FontAwesomeIcons.boxesStacked,
          label: 'Inventario',
          route: '/admin/inventory',
          isActive: currentPath.startsWith('/admin/inventory'),
        ),
        _AdminNavItem(
          style: style,
          icon: FontAwesomeIcons.images,
          label: 'Banners',
          route: '/admin/banners',
          isActive: currentPath.startsWith('/admin/banners'),
        ),
        _AdminNavItem(
          style: style,
          icon: FontAwesomeIcons.clipboardList,
          label: 'Pedidos',
          route: '/admin/orders',
          isActive: currentPath.startsWith('/admin/orders'),
        ),
      ],
    );
  }
}

class _AdminNavItem extends StatefulWidget {
  final FaIconData icon;
  final String label;
  final String route;
  final bool isActive;
  final TextStyle? style;

  const _AdminNavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.isActive,
    this.style,
  });

  @override
  State<_AdminNavItem> createState() => _AdminNavItemState();
}

class _AdminNavItemState extends State<_AdminNavItem> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.white;
    final contentColor = widget.isActive ? primaryColor : Colors.grey[400]!;

    return InkWell(
      onTap: () {
        context.go(widget.route);
        if (ResponsiveTheme.isMobile(context)) {
          Navigator.of(context).pop();
        }
      },
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (event) {
          setState(() {
            _isHovered = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: widget.isActive
                ? primaryColor.withValues(alpha: 0.08)
                : !widget.isActive &&
                      _isHovered &&
                      !ResponsiveTheme.isMobile(context)
                ? primaryColor.withValues(alpha: 0.04)
                : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: widget.isActive ? primaryColor : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            spacing: 10,
            children: [
              FaIcon(widget.icon, color: contentColor, size: 14),
              Text(
                widget.label,
                style: widget.style?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
