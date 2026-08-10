import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const BottomBar({super.key, required this.navigationShell});

  int get _currentIndex {
    if (navigationShell.currentIndex == 0) {
      return 0;
    }
    if (navigationShell.currentIndex == 1) {
      return 1;
    }
    if (navigationShell.currentIndex == 2) {
      return 3;
    }
    return 0;
  }

  void _onTap(BuildContext context, int newIndex) {
    if (newIndex == 2) {
      return;
    }

    int branchIndex = newIndex;
    if (newIndex == 3) {
      branchIndex = 2;
    }

    navigationShell.goBranch(
      branchIndex,
      initialLocation: newIndex == _currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final bottomBarBgColor = Color.lerp(primaryColor, Colors.black, 0.2);
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(color: Colors.white, fontSize: 12);
    const double iconSize = 22;

    final List<_BottomBarItemData> buttons = [
      _BottomBarItemData(
        icon: FontAwesomeIcons.house,
        selectedIcon: FontAwesomeIcons.solidHouse,
        selectedColor: Colors.white,
        title: 'Inicio',
      ),
      _BottomBarItemData(
        icon: FontAwesomeIcons.magnifyingGlass,
        selectedColor: Colors.white,
        title: 'Buscar',
      ),
      _BottomBarItemData(
        icon: FontAwesomeIcons.whatsapp,
        selectedColor: Colors.white,
        title: 'Whatsapp',
      ),
      _BottomBarItemData(
        icon: FontAwesomeIcons.user,
        selectedIcon: FontAwesomeIcons.solidUser,
        selectedColor: Colors.white,
        title: 'Perfil',
      ),
    ];

    return StylishBottomBar(
      currentIndex: _currentIndex,
      onTap: (newIndex) => _onTap(context, newIndex),
      fabLocation: StylishBarFabLocation.center,
      hasNotch: true,
      notchStyle: NotchStyle.circle,
      backgroundColor: bottomBarBgColor,
      option: AnimatedBarOptions(iconStyle: IconStyle.Default),
      items: List.generate(buttons.length, (index) {
        final selected = _currentIndex == index;
        final button = buttons[index];
        return BottomBarItem(
          icon: FaIcon(
            selected && button.selectedIcon != null
                ? button.selectedIcon
                : button.icon,
            size: iconSize,
          ),
          selectedColor: button.selectedColor,
          title: Text(
            button.title,
            style: style?.copyWith(
              color: selected ? Colors.white : Colors.grey,
            ),
          ),
        );
      }),
    );
  }
}

class _BottomBarItemData {
  final FaIconData icon;
  final FaIconData? selectedIcon;
  final Color selectedColor;
  final String title;
  _BottomBarItemData({
    required this.icon,
    required this.selectedColor,
    required this.title,
    this.selectedIcon,
  });
}
