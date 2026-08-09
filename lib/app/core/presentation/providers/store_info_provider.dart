import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/app/core/domain/entities/store_info_entity.dart';
import 'package:marcos_malaga_app/providers/core/core_providers.dart';

class StoreInfoProvider extends AsyncNotifier<StoreInfoEntity> {
  @override
  Future<StoreInfoEntity> build() async {
    return await ref.watch(getStoreInfoUsecaseProvider).call();
  }
}

final storeInfoProvider =
    AsyncNotifierProvider<StoreInfoProvider, StoreInfoEntity>(
      StoreInfoProvider.new,
    );
