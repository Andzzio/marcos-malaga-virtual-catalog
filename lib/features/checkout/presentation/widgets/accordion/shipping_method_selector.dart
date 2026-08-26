import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/app/config/theme/app_theme.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_method_entity.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_zone_entity.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_config_provider.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/states/checkout_state.dart';

class ShippingMethodSelector extends StatelessWidget {
  final CheckoutState state;
  final CheckoutConfigCombined checkoutConfigCombined;
  final CheckoutProvider checkoutNotifier;
  final CheckoutSession session;
  const ShippingMethodSelector({
    super.key,
    required this.state,
    required this.checkoutConfigCombined,
    required this.checkoutNotifier,
    required this.session,
  });
  String? get selectedDepartmentCode => state.shippingAddress?.departmentCode;
  ShippingZoneEntity get selectedZone {
    final shippingZones = checkoutConfigCombined.config.shippingZones;
    final selectedZone = shippingZones.firstWhere(
      (z) => z.departmentCodes.contains(selectedDepartmentCode),
    );
    return selectedZone;
  }

  List<ShippingMethodEntity> get shippingMethods {
    List<ShippingMethodEntity> shippingMethods = [];
    if (selectedDepartmentCode == null ||
        (selectedDepartmentCode != null && selectedDepartmentCode!.isEmpty)) {
      return shippingMethods;
    }
    final List<ShippingMethodEntity> globalShippingMethods =
        checkoutConfigCombined.config.shippingMethods;
    shippingMethods = globalShippingMethods
        .where(
          (sM) => sM.enabled && sM.availableZones.contains(selectedZone.id),
        )
        .toList();
    return shippingMethods;
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = style?.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.bold,
    );
    final primaryColor = Theme.of(context).colorScheme.primary;
    final primaryBackgroundColor = primaryColor.withAlpha(20);
    return SizedBox(
      child: Column(
        children: List.generate(shippingMethods.length, (index) {
          final shippingMethod = shippingMethods[index];
          final price = shippingMethod.prices[selectedZone.id];
          final estimatedDays = shippingMethod.estimatedDays;
          final first = shippingMethod == shippingMethods.first;
          final selected = shippingMethod.id == state.shippingMethodId;
          final last = shippingMethod == shippingMethods.last;
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                await checkoutNotifier.setShippingMethod(
                  shippingMethod.id,
                  selectedZone.id,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: selected
                      ? Border.all(color: Theme.of(context).colorScheme.primary)
                      : Border(
                          top: first
                              ? BorderSide(color: AppTheme.mutedColor)
                              : BorderSide.none,
                          right: BorderSide(color: AppTheme.mutedColor),
                          left: BorderSide(color: AppTheme.mutedColor),
                          bottom: BorderSide(color: AppTheme.mutedColor),
                        ),
                  borderRadius: BorderRadiusGeometry.only(
                    topLeft: first ? Radius.circular(8) : Radius.circular(0),
                    topRight: first ? Radius.circular(8) : Radius.circular(0),
                    bottomLeft: last ? Radius.circular(8) : Radius.circular(0),
                    bottomRight: last ? Radius.circular(8) : Radius.circular(0),
                  ),
                  color: selected ? primaryBackgroundColor : Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.mutedColor),
                          color: selected ? primaryColor : Colors.transparent,
                        ),
                        child: Center(
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected
                                  ? Colors.white
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  shippingMethod.label,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: titleStyle,
                                ),
                                Spacer(),
                                Text(
                                  'S/. ${(price ?? 0.00).toStringAsFixed(2)} PEN',
                                  style: style,
                                ),
                              ],
                            ),
                            Text(
                              shippingMethod.description,
                              softWrap: true,
                              style: style,
                            ),
                            Text(estimatedDays, softWrap: true, style: style),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
