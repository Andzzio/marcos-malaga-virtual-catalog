import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_provider.dart';

class CheckoutContactStep extends ConsumerStatefulWidget {
  final CheckoutSession session;
  final bool isExpanded;
  final bool isCompleted;
  final VoidCallback onNext;

  const CheckoutContactStep({
    super.key,
    required this.session,
    required this.isExpanded,
    required this.isCompleted,
    required this.onNext,
  });

  @override
  ConsumerState<CheckoutContactStep> createState() =>
      _CheckoutContactStepState();
}

class _CheckoutContactStepState extends ConsumerState<CheckoutContactStep> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dniController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dniController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(checkoutProvider(widget.session).notifier)
          .updateCustomerInfo(
            CustomerInfo(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              dni: _dniController.text,
              phone: _phoneController.text,
            ),
          );
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checkoutProvider(widget.session));
    final customer = state.customerInfo;
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = style?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    return SizedBox(
      child: AnimatedCrossFade(
        crossFadeState: widget.isExpanded
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 350),
        sizeCurve: Curves.easeInOutCubicEmphasized,
        firstChild: ListTile(
          contentPadding: const EdgeInsetsDirectional.symmetric(
            horizontal: 5,
            vertical: 10,
          ),
          title: Text('1. Contacto', style: titleStyle),
          subtitle: widget.isCompleted && customer != null
              ? Text(
                  '${customer.firstName} ${customer.lastName} - ${customer.dni}',
                  style: style,
                )
              : Text('Completar datos de contacto', style: style),
          trailing: widget.isCompleted
              ? const FaIcon(
                  FontAwesomeIcons.solidCircleCheck,
                  color: Colors.greenAccent,
                )
              : const FaIcon(FontAwesomeIcons.circle),
        ),
        secondChild: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('1. Contacto', style: titleStyle),
                const Gap(16),
                TextFormField(
                  controller: _firstNameController,
                  style: style,
                  decoration: InputDecoration(
                    labelText: 'Nombres',
                    labelStyle: style,
                  ),
                  validator: (value) => value!.isEmpty ? 'Requerido' : null,
                ),
                const Gap(8),
                TextFormField(
                  controller: _lastNameController,
                  style: style,
                  decoration: InputDecoration(
                    labelText: 'Apellidos',
                    labelStyle: style,
                  ),
                  validator: (value) => value!.isEmpty ? 'Requerido' : null,
                ),
                const Gap(8),
                TextFormField(
                  controller: _dniController,
                  style: style,
                  decoration: InputDecoration(
                    labelText: 'DNI',
                    labelStyle: style,
                  ),
                  validator: (value) => value!.isEmpty ? 'Requerido' : null,
                ),
                const Gap(8),
                TextFormField(
                  controller: _phoneController,
                  style: style,
                  decoration: InputDecoration(
                    labelText: 'Celular',
                    labelStyle: style,
                  ),
                  validator: (value) => value!.isEmpty ? 'Requerido' : null,
                ),
                const Gap(8),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    'Continuar',
                    style: style?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
