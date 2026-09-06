import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/config/theme/app_theme.dart';
import 'package:marcos_malaga_app/app/core/presentation/providers/store_schedule_ui_provider.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/ubigeo_entities.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_entity.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_config_provider.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/states/checkout_state.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/widgets/accordion/billing_adress_selector.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/widgets/accordion/shipping_method_selector.dart';
import 'package:shimmer/shimmer.dart';

class CheckoutShippingStep extends ConsumerStatefulWidget {
  final CheckoutSession session;
  final bool isExpanded;
  final bool isCompleted;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const CheckoutShippingStep({
    super.key,
    required this.session,
    required this.isExpanded,
    required this.isCompleted,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  ConsumerState<CheckoutShippingStep> createState() =>
      _CheckoutShippingStepState();
}

class _CheckoutShippingStepState extends ConsumerState<CheckoutShippingStep> {
  final _formKey = GlobalKey<FormState>();
  final _billingFormKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controller with existing address if present
  }

  @override
  void dispose() {
    _addressController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit(CheckoutConfigCombined data, CheckoutState state) {
    if (state.deliveryType == DeliveryType.pickup) {
      final billingValid = _billingFormKey.currentState?.validate() ?? false;
      if (billingValid) widget.onNext();
      return;
    }

    final shippingValid = _formKey.currentState!.validate();
    bool billingValid = true;

    if (!state.billingSameAsShipping && _billingFormKey.currentState != null) {
      billingValid = _billingFormKey.currentState!.validate();
    }

    if (shippingValid && billingValid) {
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncSotreInfo = ref.watch(storeScheduleUiProvider);
    final state = ref.watch(checkoutProvider(widget.session));
    final checkoutNotifier = ref.read(
      checkoutProvider(widget.session).notifier,
    );
    final shipping = state.shippingAddress;
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = style?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    final AsyncValue<CheckoutConfigCombined> configAsync = ref.watch(
      checkoutConfigProvider,
    );

    return configAsync.when(
      data: (checkoutConfigCombined) {
        if (shipping != null) {
          if (_addressController.text.isEmpty && shipping.address.isNotEmpty) {
            _addressController.text = shipping.address;
          }
          if (_referenceController.text.isEmpty &&
              shipping.reference.isNotEmpty) {
            _referenceController.text = shipping.reference;
          }
        }
        if (state.notes != null && _notesController.text.isEmpty) {
          _notesController.text = state.notes!;
        }

        final allowedDepCodes = checkoutConfigCombined.config.shippingZones
            .expand((z) => z.departmentCodes)
            .toSet();

        final filteredDepartments = checkoutConfigCombined.ubigeo.departments
            .where((d) => allowedDepCodes.contains(d.code))
            .toList();

        final filteredProvinces = checkoutConfigCombined.ubigeo.provinces
            .where((p) => p.departmentCode == shipping?.departmentCode)
            .toList();

        final filteredDistricts = checkoutConfigCombined.ubigeo.districts
            .where((d) => d.provinceCode == shipping?.provinceCode)
            .toList();

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
              title: Text('2. Envío', style: titleStyle),
              subtitle: widget.isCompleted && shipping != null
                  ? Text(shipping.address, style: style)
                  : Text('Completar datos de envío', style: style),
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
                    Text('2. Envío', style: titleStyle),
                    const Gap(16),
                    Container(
                      height: 65,
                      decoration: BoxDecoration(
                        color: AppTheme.deadColor,
                        borderRadius: BorderRadiusGeometry.circular(16),
                      ),
                      child: Row(
                        children: DeliveryType.values.map((dT) {
                          String? deliveryName;
                          FaIconData? deliveryIcon;
                          final selected = dT == state.deliveryType;
                          switch (dT) {
                            case DeliveryType.shipping:
                              deliveryName = 'Envío';
                              deliveryIcon = FontAwesomeIcons.truckFast;
                            case DeliveryType.pickup:
                              deliveryName = 'Retiro';
                              deliveryIcon = FontAwesomeIcons.locationDot;
                          }
                          return Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    checkoutNotifier.setDeliveryType(dT);
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 600),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      color: selected ? Colors.white : null,
                                      borderRadius:
                                          BorderRadiusGeometry.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: selected
                                              ? Colors.grey
                                              : Colors.transparent,
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 5,
                                        children: [
                                          FaIcon(deliveryIcon, size: 14),
                                          Text(deliveryName, style: style),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const Gap(16),
                    if (state.deliveryType == DeliveryType.shipping)
                      _buildShippingForm(
                        style,
                        filteredDepartments,
                        filteredProvinces,
                        filteredDistricts,
                        state,
                        checkoutNotifier,
                        checkoutConfigCombined,
                      ),
                    if (state.deliveryType == DeliveryType.shipping) ...[
                      const Gap(16),
                      if (state.shippingAddress?.departmentCode != null) ...[
                        Text('Métodos de envío', style: titleStyle),
                        const Gap(16),
                      ],
                      ShippingMethodSelector(
                        state: state,
                        checkoutConfigCombined: checkoutConfigCombined,
                        checkoutNotifier: checkoutNotifier,
                        session: widget.session,
                      ),
                    ],
                    if (state.deliveryType == DeliveryType.pickup) ...[
                      const Gap(16),
                      asyncSotreInfo.when(
                        data: (uiModel) {
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.mutedColor),
                              borderRadius: BorderRadiusGeometry.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tienda Física', style: titleStyle),
                                  Text(uiModel.fullAddress, style: style),
                                ],
                              ),
                            ),
                          );
                        },
                        loading: () => Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadiusGeometry.circular(8),
                            ),
                          ),
                        ),
                        error: (error, stackTrace) => Center(
                          child: Row(
                            spacing: 10,
                            children: [
                              Text(
                                'Falló la carga de la tienda física, intentelo de nuevo más tarde.',
                                style: style,
                              ),
                              FaIcon(FontAwesomeIcons.circleXmark),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const Gap(16),
                    Text('Dirección de facturación', style: titleStyle),
                    const Gap(16),
                    BillingAdressSelector(
                      state: state,
                      checkoutNotifier: checkoutNotifier,
                      formKey: _billingFormKey,
                      forceExpanded: state.deliveryType == DeliveryType.pickup,
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: widget.onPrevious,
                          child: Text('Volver', style: style),
                        ),
                        const Gap(16),
                        ElevatedButton(
                          onPressed: () =>
                              _submit(checkoutConfigCombined, state),
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
          ),
        );
      },
      loading: () {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
        final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Card(
            child: SizedBox(
              height: widget.isExpanded ? 400 : 72,
              width: double.infinity,
            ),
          ),
        );
      },
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error cargando configuración de envío: $error'),
        ),
      ),
    );
  }

  Column _buildShippingForm(
    TextStyle? style,
    List<DepartmentEntity> filteredDepartments,
    List<ProvinceEntity> filteredProvinces,
    List<DistrictEntity> filteredDistricts,
    CheckoutState state,
    CheckoutProvider checkoutNotifier,
    CheckoutConfigCombined data,
  ) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue:
              (state.shippingAddress?.departmentCode.isNotEmpty ?? false)
              ? state.shippingAddress!.departmentCode
              : null,
          style: style,
          decoration: InputDecoration(
            labelText: 'Departamento',
            labelStyle: style,
          ),
          items: filteredDepartments
              .map(
                (d) => DropdownMenuItem(
                  value: d.code,
                  child: Text(d.name, style: style),
                ),
              )
              .toList(),
          onChanged: (value) async {
            if (value != null) {
              final currentAddress =
                  state.shippingAddress ?? const ShippingAddress.empty();
              final departmentName = data.ubigeo.departments
                  .firstWhere((d) => d.code == value)
                  .name;
              final zone = data.config.shippingZones
                  .firstWhere((z) => z.departmentCodes.contains(value))
                  .id;
              await checkoutNotifier.updateShippingAddress(
                currentAddress.copyWith(
                  departmentCode: value,
                  department: departmentName,
                  provinceCode: '',
                  province: '',
                  districtCode: '',
                  district: '',
                  shippingZone: zone,
                ),
              );
            }
          },
          validator: (value) =>
              value == null ? 'Seleccione departamento' : null,
        ),
        const Gap(16),
        DropdownButtonFormField<String>(
          initialValue:
              (state.shippingAddress?.provinceCode.isNotEmpty ?? false)
              ? state.shippingAddress!.provinceCode
              : null,
          style: style,
          decoration: InputDecoration(
            labelText: 'Provincia',
            labelStyle: style,
          ),
          items: filteredProvinces
              .map(
                (p) => DropdownMenuItem(
                  value: p.code,
                  child: Text(p.name, style: style),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              final currentAddress =
                  state.shippingAddress ?? const ShippingAddress.empty();
              final provinceName = data.ubigeo.provinces
                  .firstWhere((p) => p.code == value)
                  .name;
              checkoutNotifier.updateShippingAddress(
                currentAddress.copyWith(
                  provinceCode: value,
                  province: provinceName,
                  districtCode: '',
                  district: '',
                ),
              );
            }
          },
          validator: (value) => value == null ? 'Seleccione provincia' : null,
        ),
        const Gap(16),
        DropdownButtonFormField<String>(
          initialValue:
              (state.shippingAddress?.districtCode.isNotEmpty ?? false)
              ? state.shippingAddress!.districtCode
              : null,
          style: style,
          decoration: InputDecoration(labelText: 'Distrito', labelStyle: style),
          items: filteredDistricts
              .map(
                (d) => DropdownMenuItem(
                  value: d.code,
                  child: Text(d.name, style: style),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              final currentAddress =
                  state.shippingAddress ?? const ShippingAddress.empty();
              final districtName = data.ubigeo.districts
                  .firstWhere((d) => d.code == value)
                  .name;
              checkoutNotifier.updateShippingAddress(
                currentAddress.copyWith(
                  districtCode: value,
                  district: districtName,
                ),
              );
            }
          },
          validator: (value) => value == null ? 'Seleccione distrito' : null,
        ),
        const Gap(16),
        TextFormField(
          controller: _addressController,
          style: style,
          decoration: InputDecoration(
            labelText: 'Dirección (Calle)',
            labelStyle: style,
          ),
          onChanged: (val) {
            final currentAddress =
                state.shippingAddress ?? const ShippingAddress.empty();
            checkoutNotifier.updateShippingAddress(
              currentAddress.copyWith(address: val),
            );
          },
          validator: (value) =>
              value == null || value.isEmpty ? 'Requerido' : null,
        ),
        const Gap(16),
        TextFormField(
          controller: _referenceController,
          style: style,
          decoration: InputDecoration(
            labelText: 'Referencia (Opcional)',
            labelStyle: style,
          ),
          onChanged: (val) {
            final currentAddress =
                state.shippingAddress ?? const ShippingAddress.empty();
            checkoutNotifier.updateShippingAddress(
              currentAddress.copyWith(reference: val),
            );
          },
        ),
        const Gap(16),
        TextFormField(
          controller: _notesController,
          style: style,
          decoration: InputDecoration(
            labelText: 'Notas del pedido (Opcional)',
            labelStyle: style,
          ),
          onChanged: (val) {
            checkoutNotifier.setNotes(val);
          },
        ),
      ],
    );
  }
}
