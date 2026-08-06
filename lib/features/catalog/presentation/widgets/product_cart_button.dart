import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductCartButton extends StatefulWidget {
  const ProductCartButton({super.key});

  @override
  State<ProductCartButton> createState() => _ProductCartButtonState();
}

class _ProductCartButtonState extends State<ProductCartButton> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (event) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHovered = false;
        });
      },
      child: AnimatedSize(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInCubic,
        alignment: Alignment.centerLeft,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInCubic,
          height: 37,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 6,
            children: [
              FaIcon(FontAwesomeIcons.cartPlus, size: 14, color: Colors.black),
              if (_isHovered)
                Text(
                  'Elegir',
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(fontSize: 14),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
