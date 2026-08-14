import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/availability_widget.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/design_selector.dart';
import 'package:marcos_malaga_app/app/shared/widgets/buttons/no_filled_button.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_detail_buttons.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_price.dart';

class ProductDetailView extends StatelessWidget {
  final ProductEntity product;
  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 650),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontSize: 25),
              ),
              Gap(10),
              ProductPrice(
                product: product,
                mainAxisAlignment: MainAxisAlignment.start,
              ),
              Gap(30),
              AvailabilityWidget(product: product),
              Gap(20),
              Divider(
                thickness: 0.2,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Gap(20),
              NoFilledButton(
                label: 'Tabla de medidas',
                icon: FontAwesomeIcons.angleRight,
                width: 200,
                borderColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.secondary,
                iconColor: Theme.of(context).colorScheme.secondary,
                onPressed: () {},
              ),
              Gap(50),
              DesignSelector(product: product),
              Gap(50),
              ProductDetailButtons(product: product),
              Gap(50),
              ExpansionTile(
                tilePadding: EdgeInsetsGeometry.zero,
                initiallyExpanded: true,
                shape: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.4,
                  ),
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.4,
                  ),
                ),
                collapsedShape: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.4,
                  ),
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.4,
                  ),
                ),
                iconColor: Theme.of(context).colorScheme.secondary,
                collapsedIconColor: Theme.of(context).colorScheme.secondary,
                title: Text(
                  'DESCRIPCIÓN',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      product.description,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
