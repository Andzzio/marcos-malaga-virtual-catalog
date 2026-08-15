import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class SearchHeadBar extends StatefulWidget {
  final double progress;
  final String? initialQuery;
  final void Function(String)? onSubmittedOverride;
  const SearchHeadBar({
    super.key,
    this.progress = 1.0,
    this.initialQuery,
    this.onSubmittedOverride,
  });

  @override
  State<SearchHeadBar> createState() => _SearchHeadBarState();
}

class _SearchHeadBarState extends State<SearchHeadBar> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery ?? '';
  }

  @override
  void didUpdateWidget(covariant SearchHeadBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialQuery != widget.initialQuery) {
      if (_searchController.text != (widget.initialQuery ?? '')) {
        Future.microtask(() {
          _searchController.text = widget.initialQuery ?? '';
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final query = _searchController.text.trim();

    if (widget.onSubmittedOverride != null) {
      widget.onSubmittedOverride!(query);
      return;
    }

    final uri = GoRouterState.of(context).uri;
    final Map<String, dynamic> queryParams = Map.of(uri.queryParameters);

    if (query.isEmpty) {
      queryParams.remove('q');
    } else {
      queryParams['q'] = query;
    }

    final currentPath = uri.path;
    String newPath = '/search/catalog';
    if (currentPath.contains('xl-sizes')) {
      newPath = '/search/xl-sizes';
    } else if (currentPath.contains('new-arrivals')) {
      newPath = '/search/new-arrivals';
    }

    final newUri = Uri(
      path: newPath,
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    context.go(newUri.toString());
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
