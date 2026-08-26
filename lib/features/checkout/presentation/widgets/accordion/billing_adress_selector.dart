import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/config/theme/app_theme.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/billing_address.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_config_provider.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/states/checkout_state.dart';

class BillingAdressSelector extends ConsumerStatefulWidget {
  final CheckoutState state;
  final CheckoutProvider checkoutNotifier;
  final GlobalKey<FormState> formKey;
  final bool forceExpanded;
  const BillingAdressSelector({
    super.key,
    required this.checkoutNotifier,
    required this.state,
    required this.formKey,
    this.forceExpanded = false,
  });

  @override
  ConsumerState<BillingAdressSelector> createState() =>
      _BillingAdressSelectorState();
}

class _BillingAdressSelectorState extends ConsumerState<BillingAdressSelector> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dniController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedDepartmentCode;
  String? _selectedProvinceCode;
  String? _selectedDistrictCode;

  @override
  void initState() {
    super.initState();
    final billing = widget.state.billingAddress;
    if (billing != null) {
      _firstNameController.text = billing.firstName;
      _lastNameController.text = billing.lastName;
      _dniController.text = billing.dni;
      _phoneController.text = billing.phone;
      _addressController.text = billing.address;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dniController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _updateBillingAddress(CheckoutConfigCombined data) {
    String departmentName = '';
    String provinceName = '';
    String districtName = '';

    if (_selectedDepartmentCode != null) {
      departmentName = data.ubigeo.departments
          .firstWhere(
            (d) => d.code == _selectedDepartmentCode,
            orElse: () => data.ubigeo.departments.first,
          )
          .name;
    }
    if (_selectedProvinceCode != null) {
      provinceName = data.ubigeo.provinces
          .firstWhere(
            (p) => p.code == _selectedProvinceCode,
            orElse: () => data.ubigeo.provinces.first,
          )
          .name;
    }
    if (_selectedDistrictCode != null) {
      districtName = data.ubigeo.districts
          .firstWhere(
            (d) => d.code == _selectedDistrictCode,
            orElse: () => data.ubigeo.districts.first,
          )
          .name;
    }

    widget.checkoutNotifier.updateBillingAddress(
      BillingAddress(
        country: 'Perú',
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        dni: _dniController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        department: departmentName,
        province: provinceName,
        district: districtName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final primaryBackgroundColor = primaryColor.withAlpha(20);
    final List<_BillingAdressData> billingDatas = [
      _BillingAdressData(title: 'La misma dirección de envío', value: true),
      _BillingAdressData(
        title: 'Usar una dirección de facturación distinta',
        value: false,
      ),
    ];

    final configAsync = ref.watch(checkoutConfigProvider);

    return Column(
      children: [
        if (!widget.forceExpanded) ...[
          ...List.generate(billingDatas.length, (index) {
            final billingData = billingDatas[index];
            final selected =
                billingData.value == widget.state.billingSameAsShipping;
            final first = billingDatas.first == billingData;
            final last = billingDatas.last == billingData;

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  widget.checkoutNotifier.toggleBillingSameAsShipping(
                    billingData.value,
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
                      bottomLeft: !widget.state.billingSameAsShipping
                          ? Radius.circular(0)
                          : last
                          ? Radius.circular(8)
                          : Radius.circular(0),
                      bottomRight: !widget.state.billingSameAsShipping
                          ? Radius.circular(0)
                          : last
                          ? Radius.circular(8)
                          : Radius.circular(0),
                    ),
                    color: selected ? primaryBackgroundColor : Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
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
                        Text(billingData.title, style: style),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
        if (widget.forceExpanded || !widget.state.billingSameAsShipping)
          Container(
            decoration: BoxDecoration(
              color: AppTheme.deadColor,
              border: Border(
                bottom: BorderSide(color: AppTheme.mutedColor),
                left: BorderSide(color: AppTheme.mutedColor),
                right: BorderSide(color: AppTheme.mutedColor),
              ),
              borderRadius: widget.forceExpanded
                  ? BorderRadiusGeometry.circular(8)
                  : BorderRadiusGeometry.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: configAsync.when(
                data: (data) {
                  final allowedDepCodes = data.config.shippingZones
                      .expand((z) => z.departmentCodes)
                      .toSet();
                  final departments = data.ubigeo.departments
                      .where((d) => allowedDepCodes.contains(d.code))
                      .toList();
                  final provinces = data.ubigeo.provinces
                      .where((p) => p.departmentCode == _selectedDepartmentCode)
                      .toList();
                  final districts = data.ubigeo.districts
                      .where((d) => d.provinceCode == _selectedProvinceCode)
                      .toList();

                  return Form(
                    key: widget.formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _firstNameController,
                          style: style,
                          decoration: InputDecoration(
                            labelText: 'Nombres',
                            labelStyle: style,
                            filled: true,
                            fillColor: AppTheme.scaffoldBackground,
                          ),
                          onChanged: (_) => _updateBillingAddress(data),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Requerido'
                              : null,
                        ),
                        const Gap(16),
                        TextFormField(
                          controller: _lastNameController,
                          style: style,
                          decoration: InputDecoration(
                            labelText: 'Apellidos',
                            labelStyle: style,
                            filled: true,
                            fillColor: AppTheme.scaffoldBackground,
                          ),
                          onChanged: (_) => _updateBillingAddress(data),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Requerido'
                              : null,
                        ),
                        const Gap(16),
                        TextFormField(
                          controller: _dniController,
                          style: style,
                          decoration: InputDecoration(
                            labelText: 'DNI',
                            labelStyle: style,
                            filled: true,
                            fillColor: AppTheme.scaffoldBackground,
                          ),
                          onChanged: (_) => _updateBillingAddress(data),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Requerido'
                              : null,
                        ),
                        const Gap(16),
                        TextFormField(
                          controller: _phoneController,
                          style: style,
                          decoration: InputDecoration(
                            labelText: 'Celular',
                            labelStyle: style,
                            filled: true,
                            fillColor: AppTheme.scaffoldBackground,
                          ),
                          onChanged: (_) => _updateBillingAddress(data),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Requerido'
                              : null,
                        ),
                        const Gap(16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedDepartmentCode,
                          style: style,
                          decoration: InputDecoration(
                            labelText: 'Departamento',
                            labelStyle: style,
                            filled: true,
                            fillColor: AppTheme.scaffoldBackground,
                          ),
                          items: departments.map((d) {
                            return DropdownMenuItem(
                              value: d.code,
                              child: Text(d.name, style: style),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDepartmentCode = value;
                              _selectedProvinceCode = null;
                              _selectedDistrictCode = null;
                            });
                            _updateBillingAddress(data);
                          },
                          validator: (value) => value == null || value.isEmpty
                              ? 'Requerido'
                              : null,
                        ),
                        const Gap(16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedProvinceCode,
                          style: style,
                          decoration: InputDecoration(
                            labelText: 'Provincia',
                            labelStyle: style,
                            filled: true,
                            fillColor: AppTheme.scaffoldBackground,
                          ),
                          items: provinces.map((p) {
                            return DropdownMenuItem(
                              value: p.code,
                              child: Text(p.name, style: style),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedProvinceCode = value;
                              _selectedDistrictCode = null;
                            });
                            _updateBillingAddress(data);
                          },
                          validator: (value) => value == null || value.isEmpty
                              ? 'Requerido'
                              : null,
                        ),
                        const Gap(16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedDistrictCode,
                          style: style,
                          decoration: InputDecoration(
                            labelText: 'Distrito',
                            labelStyle: style,
                            filled: true,
                            fillColor: AppTheme.scaffoldBackground,
                          ),
                          items: districts.map((d) {
                            return DropdownMenuItem(
                              value: d.code,
                              child: Text(d.name, style: style),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDistrictCode = value;
                            });
                            _updateBillingAddress(data);
                          },
                          validator: (value) => value == null || value.isEmpty
                              ? 'Requerido'
                              : null,
                        ),
                        const Gap(16),
                        TextFormField(
                          controller: _addressController,
                          style: style,
                          decoration: InputDecoration(
                            labelText: 'Dirección (Calle)',
                            labelStyle: style,
                            filled: true,
                            fillColor: AppTheme.scaffoldBackground,
                          ),
                          onChanged: (_) => _updateBillingAddress(data),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Requerido'
                              : null,
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    Text('Error al cargar ubigeo', style: style),
              ),
            ),
          ),
      ],
    );
  }
}

class _BillingAdressData {
  final String title;
  final bool value;
  _BillingAdressData({required this.title, required this.value});
}
