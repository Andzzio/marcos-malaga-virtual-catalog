import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class YesFilledButton extends StatefulWidget {
  final FaIconData? icon;
  final String label;
  final double contentSize;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final Color filledColor;
  final Color contentColor;
  final MainAxisAlignment mainAxisAlignment;
  final bool reverse;
  final bool enabled;
  const YesFilledButton({
    super.key,
    this.icon,
    required this.label,
    required this.onPressed,
    this.width,
    this.height,
    this.contentSize = 15,
    this.filledColor = Colors.black,
    this.contentColor = Colors.white,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.reverse = false,
    this.enabled = true,
  });

  @override
  State<YesFilledButton> createState() => _YesFilledButtonState();
}

class _YesFilledButtonState extends State<YesFilledButton> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.5,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.forbidden,
        onHover: (event) {
          if (widget.enabled) {
            setState(() {
              _isHovered = true;
            });
          }
        },
        onExit: (event) {
          if (widget.enabled) {
            setState(() {
              _isHovered = false;
            });
          }
        },
        child: GestureDetector(
          onTap: widget.enabled ? widget.onPressed : null,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: widget.filledColor,
              border: Border.all(
                color: _isHovered
                    ? widget.filledColor
                    : widget.filledColor.withValues(alpha: 0.4),
              ),
              borderRadius: BorderRadiusGeometry.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: widget.mainAxisAlignment,
                children: [
                  if (widget.reverse) ...[
                    FaIcon(
                      widget.icon,
                      size: widget.contentSize,
                      color: widget.contentColor,
                    ),
                    AnimatedContainer(
                      width: _isHovered ? 20 : 10,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: widget.contentSize,
                        color: widget.contentColor,
                      ),
                    ),
                  ] else ...[
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: widget.contentSize,
                        color: widget.contentColor,
                      ),
                    ),
                    AnimatedContainer(
                      width: _isHovered ? 20 : 10,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    FaIcon(
                      widget.icon,
                      size: widget.contentSize,
                      color: widget.contentColor,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
