import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_config_provider.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/widgets/accordion/payment_method_selector.dart';
import 'package:shimmer/shimmer.dart';

class CheckoutPaymentStep extends ConsumerWidget {
  final CheckoutSession session;
  final bool isExpanded;
  final bool isCompleted;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const CheckoutPaymentStep({
    super.key,
    required this.session,
    required this.isExpanded,
    required this.isCompleted,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkoutProvider(session));
    final checkoutNotifier = ref.read(checkoutProvider(session).notifier);
    final configCombinedAsync = ref.watch(checkoutConfigProvider);
    final paymentMethodId = state.paymentMethodId;
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = style?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    return SizedBox(
      child: AnimatedCrossFade(
        crossFadeState: isExpanded
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 350),
        sizeCurve: Curves.easeInOutCubicEmphasized,
        firstChild: ListTile(
          contentPadding: EdgeInsetsGeometry.symmetric(
            horizontal: 5,
            vertical: 10,
          ),
          title: Text('3. Pago', style: titleStyle),
          subtitle: isCompleted && paymentMethodId != null
              ? Text(() {
                  return configCombinedAsync.when(
                    data: (configCombined) {
                      final paymentMethods =
                          configCombined.config.paymentMethods;
                      final paymentMethod = paymentMethods
                          .where(
                            (paymentMethod) =>
                                paymentMethod.id == paymentMethodId,
                          )
                          .firstOrNull;
                      if (paymentMethod == null) {
                        return 'error, no paymentMethod found';
                      }
                      return paymentMethod.label;
                    },
                    loading: () => '...',
                    error: (error, stackTrace) => 'error: $error',
                  );
                }(), style: style)
              : Text('Seleccionar método de pago', style: style),
          trailing: isCompleted
              ? const FaIcon(
                  FontAwesomeIcons.solidCircleCheck,
                  color: Colors.greenAccent,
                )
              : const FaIcon(FontAwesomeIcons.circle),
        ),
        secondChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('3. Pago', style: titleStyle),
              Gap(16),
              configCombinedAsync.when(
                data: (configCombined) {
                  return PaymentMethodSelector(
                    state: state,
                    checkoutNotifier: checkoutNotifier,
                    configCombined: configCombined,
                  );
                },
                loading: () {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.grey[300]!,
                    child: SizedBox(height: 400, width: double.infinity),
                  );
                },
                error: (err, stackTrace) {
                  return Center(
                    child: Text(
                      'Error cargando la configuración de pagos',
                      style: style,
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: onPrevious,
                    child: Text('Volver', style: style),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (paymentMethodId != null) {
                        onNext();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Selecciona un método de pago',
                              style: style,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Continuar',
                      style: style?.copyWith(color: Colors.white),
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
