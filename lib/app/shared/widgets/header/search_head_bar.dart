import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SearchHeadBar extends StatefulWidget {
  final double progress;
  final void Function(String)? onSubmittedOverride;
  const SearchHeadBar({super.key, this.progress = 1.0, this.onSubmittedOverride});

  @override
  State<SearchHeadBar> createState() => _SearchHeadBarState();
}

class _SearchHeadBarState extends State<SearchHeadBar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    
    if (widget.onSubmittedOverride != null) {
      widget.onSubmittedOverride!(query);
      return;
    }
    
    final currentPath = GoRouterState.of(context).uri.path;

    if (currentPath.contains('xl-sizes')) {
       context.go('/search/xl-sizes?q=$query');
    } else if (currentPath.contains('new-arrivals')) {
       context.go('/search/new-arrivals?q=$query');
    } else {
       context.go('/search/catalog?q=$query');
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Color.lerp(
      Colors.white.withValues(alpha: 0.4),
      Colors.black.withValues(alpha: 0.3),
      widget.progress,
    );
    final focusedBorderColor = Color.lerp(
      Colors.white,
      Theme.of(context).colorScheme.primary,
      widget.progress,
    );
    final hintColor = Color.lerp(
      Colors.white.withValues(alpha: 0.7),
      Colors.black.withValues(alpha: 0.4),
      widget.progress,
    );
    final textColor = Color.lerp(Colors.white, Colors.black, widget.progress);
    final iconColor = Color.lerp(
      Colors.white.withValues(alpha: 0.9),
      Colors.black.withValues(alpha: 0.7),
      widget.progress,
    );

    return SizedBox(
      width: 280,
      height: 40,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            _onSubmit();
          }
        },
        child: TextField(
          controller: _searchController,
          style: TextStyle(color: textColor, fontSize: 13),
          cursorColor: textColor,
          decoration: InputDecoration(
            filled: false,
            hintText: 'Buscar productos...',
            hintStyle: TextStyle(
              color: hintColor,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: borderColor!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: focusedBorderColor!, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            suffixIcon: IconButton(
              onPressed: _onSubmit,
              icon: FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                color: iconColor,
                size: 14,
              ),
            ),
          ),
          onSubmitted: (_) => _onSubmit(),
        ),
      ),
    );
  }
}
