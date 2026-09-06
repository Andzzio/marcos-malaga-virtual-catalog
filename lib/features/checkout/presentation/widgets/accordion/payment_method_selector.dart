import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/app/config/theme/app_theme.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/payment_method_entity.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_config_provider.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/states/checkout_state.dart';

class PaymentMethodSelector extends StatelessWidget {
  final CheckoutState state;
  final CheckoutProvider checkoutNotifier;
  final CheckoutConfigCombined configCombined;

  const PaymentMethodSelector({
    super.key,
    required this.state,
    required this.checkoutNotifier,
    required this.configCombined,
  });

  List<PaymentMethodEntity> get paymentMethods =>
      configCombined.config.paymentMethods;

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (state.paymentMethodId == null ||
          (state.paymentMethodId != null && state.paymentMethodId!.isEmpty)) {
        checkoutNotifier.setPaymentMethod(paymentMethods.first.id);
      }
    });

    return Column(
      children: List.generate(paymentMethods.length, (index) {
        final paymentMethod = paymentMethods[index];
        final selected = paymentMethod.id == state.paymentMethodId;
        final first = paymentMethod == paymentMethods.first;
        final last = paymentMethod == paymentMethods.last;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              checkoutNotifier.setPaymentMethod(paymentMethod.id);
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
                            color: selected ? Colors.white : Colors.transparent,
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
                                paymentMethod.label,
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                style: titleStyle,
                              ),
                            ],
                          ),
                          Text(
                            paymentMethod.instructions,
                            softWrap: true,
                            style: style,
                          ),
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
    );
  }
}
