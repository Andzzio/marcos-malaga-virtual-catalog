import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/footer/footer_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/mobile_header_bar.dart';
import 'package:marcos_malaga_app/app/shared/widgets/header/home_label.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/back_screen_button.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/screens/desktop_checkout_order_summary.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/widgets/accordion/checkout_contact_step.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/widgets/accordion/checkout_shipping_step.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/widgets/accordion/checkout_payment_step.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/widgets/summary/checkout_order_summary.dart';
import 'package:marcos_malaga_app/providers/features/checkout/checkout_providers.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final String sessionId;

  const CheckoutScreen({super.key, required this.sessionId});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int currentStep = 0;

  Widget _buildMobileUI(BuildContext context, CheckoutSession session) {
    return Column(
      children: [
        CheckoutOrderSummary(session: session),
        Gap(24),
        CheckoutContactStep(
          session: session,
          isExpanded: currentStep == 0,
          isCompleted: currentStep > 0,
          onNext: () => setState(() => currentStep = 1),
        ),
        Gap(24),
        CheckoutShippingStep(
          session: session,
          isExpanded: currentStep == 1,
          isCompleted: currentStep > 1,
          onNext: () => setState(() => currentStep = 2),
          onPrevious: () => setState(() => currentStep = 0),
        ),
        Gap(24),
        CheckoutPaymentStep(
          session: session,
          isExpanded: currentStep == 2,
          isCompleted: currentStep > 2,
          onPrevious: () => setState(() => currentStep = 1),
          onNext: () => setState(() => currentStep = 3),
        ),
        Gap(24),
        Row(
          spacing: 10,
          children: [
            Expanded(
              flex: 2,
              child: OutlinedButton(
                onPressed: currentStep == 3
                    ? () => setState(() {
                        currentStep = 2;
                      })
                    : null,
                child: Text(
                  'Volver',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 11,
                    color: currentStep == 3 ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: ElevatedButton(
                onPressed: currentStep == 3
                    ? () => ref
                          .read(checkoutProvider(session).notifier)
                          .submitOrder()
                    : null,
                child: Text(
                  'Finalizar Pedido',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopUI(BuildContext context, CheckoutSession session) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1200),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CheckoutContactStep(
                    session: session,
                    isExpanded: currentStep == 0,
                    isCompleted: currentStep > 0,
                    onNext: () => setState(() => currentStep = 1),
                  ),
                  const Gap(8),
                  CheckoutShippingStep(
                    session: session,
                    isExpanded: currentStep == 1,
                    isCompleted: currentStep > 1,
                    onNext: () => setState(() => currentStep = 2),
                    onPrevious: () => setState(() => currentStep = 0),
                  ),
                  const Gap(8),
                  CheckoutPaymentStep(
                    session: session,
                    isExpanded: currentStep == 2,
                    isCompleted: currentStep > 2,
                    onPrevious: () => setState(() => currentStep = 1),
                    onNext: () => setState(() => currentStep = 3),
                  ),
                  const Gap(24),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        flex: 3,
                        child: OutlinedButton(
                          onPressed: currentStep == 3
                              ? () => setState(() {
                                  currentStep = 2;
                                })
                              : null,
                          child: Text(
                            'Volver',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  fontSize: 11,
                                  color: currentStep == 3
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: ElevatedButton(
                          onPressed: currentStep == 3
                              ? () => ref
                                    .read(checkoutProvider(session).notifier)
                                    .submitOrder()
                              : null,
                          child: Text(
                            'Finalizar Pedido',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(fontSize: 11, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(36),
            Expanded(
              flex: 4,
              child: DesktopCheckoutOrderSummary(session: session),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionAsync = ref.watch(
      checkoutSessionFutureProvider(widget.sessionId),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const HomeLabel(label: 'INAUGURACIÓN MARCOSMALAGA.COM'),
          ResponsiveTheme.isMobile(context)
              ? const MobileHeaderBar(colorLerp: false)
              : ResponsiveTheme.isTablet(context)
              ? const MobileHeaderBar(colorLerp: false)
              : const MobileHeaderBar(colorLerp: false),
          const SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            sliver: SliverMainAxisGroup(
              slivers: [
                SliverToBoxAdapter(child: BackScreenButton(label: 'Pagar')),
              ],
            ),
          ),
          sessionAsync.when(
            data: (session) {
              if (session == null) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text('Sesión no encontrada')),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                sliver: SliverToBoxAdapter(
                  child:
                      (!ResponsiveTheme.isMobile(context) &&
                          !ResponsiveTheme.isTablet(context))
                      ? _buildDesktopUI(context, session)
                      : _buildMobileUI(context, session),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stackTrace) => SliverFillRemaining(
              child: Center(child: FaIcon(FontAwesomeIcons.circleXmark)),
            ),
          ),
          const SliverGap(30),
          FooterBar(),
        ],
      ),
    );
  }
}
