import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_config_entity.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/ubigeo_entities.dart';
import 'package:marcos_malaga_app/providers/features/checkout/checkout_providers.dart';

typedef CheckoutConfigCombined = ({
  CheckoutConfigEntity config,
  UbigeoEntity ubigeo,
});

final checkoutConfigProvider = FutureProvider<CheckoutConfigCombined>((
  ref,
) async {
  final getCheckoutConfig = ref.watch(getCheckoutConfigUseCaseProvider);
  final getUbigeo = ref.watch(getUbigeoUseCaseProvider);

  final results = await Future.wait([getCheckoutConfig(), getUbigeo()]);

  return (
    config: results[0] as CheckoutConfigEntity,
    ubigeo: results[1] as UbigeoEntity,
  );
});
