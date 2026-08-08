import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NoFilledButton extends StatefulWidget {
  final FaIconData? icon;
  final String label;
  final double contentSize;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final MainAxisAlignment mainAxisAlignment;
  final bool reverse;
  final Color borderColor;
  final Color? textColor;
  final Color? iconColor;
  final bool enabled;
  const NoFilledButton({
    super.key,
    this.icon,
    required this.label,
    required this.onPressed,
    this.width,
    this.height,
    this.contentSize = 15,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.reverse = false,
    this.borderColor = Colors.black,
    this.textColor,
    this.iconColor,
    this.enabled = true,
  });

  @override
  State<NoFilledButton> createState() => _NoFilledButtonState();
}

class _NoFilledButtonState extends State<NoFilledButton> {
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
              color: Colors.transparent,
              border: Border.all(
                color: _isHovered
                    ? widget.borderColor
                    : widget.borderColor.withValues(alpha: 0.4),
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
                      color: widget.iconColor ?? Colors.black,
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
                        color: widget.textColor,
                      ),
                    ),
                  ] else ...[
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: widget.contentSize,
                        color: widget.textColor,
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
                      color: widget.iconColor ?? Colors.black,
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
