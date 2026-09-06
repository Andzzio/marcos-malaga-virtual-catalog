import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/data/datasources/local_checkout_config_datasource.dart';
import 'package:marcos_malaga_app/features/checkout/data/datasources/local_checkout_session_datasource.dart';
import 'package:marcos_malaga_app/features/checkout/data/repositories/local_checkout_config_repository_impl.dart';
import 'package:marcos_malaga_app/features/checkout/data/repositories/local_checkout_session_repository_impl.dart';
import 'package:marcos_malaga_app/features/checkout/domain/repositories/checkout_config_repository.dart';
import 'package:marcos_malaga_app/features/checkout/domain/repositories/checkout_session_repository.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/calculate_shipping_cost_usecase.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/create_checkout_session_usecase.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/get_checkout_config_usecase.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/get_checkout_session_usecase.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/get_ubigeo_usecase.dart';
import 'package:marcos_malaga_app/providers/core/core_providers.dart';

final localCheckoutConfigDatasourceProvider =
    Provider<LocalCheckoutConfigDatasource>((ref) {
      return LocalCheckoutConfigDatasource();
    });

final checkoutConfigRepositoryProvider = Provider<CheckoutConfigRepository>((
  ref,
) {
  final datasource = ref.watch(localCheckoutConfigDatasourceProvider);
  return LocalCheckoutConfigRepositoryImpl(datasource);
});

final localCheckoutSessionDatasourceProvider =
    Provider<LocalCheckoutSessionDatasource>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return LocalCheckoutSessionDatasource(prefs: prefs);
    });

final checkoutSessionRepositoryProvider = Provider<CheckoutSessionRepository>((
  ref,
) {
  final datasource = ref.watch(localCheckoutSessionDatasourceProvider);
  return LocalCheckoutSessionRepositoryImpl(datasource);
});

final getCheckoutConfigUseCaseProvider = Provider<GetCheckoutConfigUseCase>((
  ref,
) {
  final repository = ref.watch(checkoutConfigRepositoryProvider);
  return GetCheckoutConfigUseCase(repository);
});

final getUbigeoUseCaseProvider = Provider<GetUbigeoUseCase>((ref) {
  final repository = ref.watch(checkoutConfigRepositoryProvider);
  return GetUbigeoUseCase(repository);
});

final calculateShippingCostUseCaseProvider =
    Provider<CalculateShippingCostUseCase>((ref) {
      return const CalculateShippingCostUseCase();
    });

final createCheckoutSessionUseCaseProvider =
    Provider<CreateCheckoutSessionUseCase>((ref) {
      final repository = ref.watch(checkoutSessionRepositoryProvider);
      return CreateCheckoutSessionUseCase(repository);
    });

final getCheckoutSessionUseCaseProvider = Provider<GetCheckoutSessionUseCase>((
  ref,
) {
  final repository = ref.watch(checkoutSessionRepositoryProvider);
  return GetCheckoutSessionUseCase(repository);
});

final checkoutSessionFutureProvider =
    FutureProvider.family<CheckoutSession?, String>((ref, sessionId) async {
      final getSession = ref.read(getCheckoutSessionUseCaseProvider);
      return getSession(sessionId);
    });
