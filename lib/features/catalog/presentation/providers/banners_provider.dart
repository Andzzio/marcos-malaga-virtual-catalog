import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/providers/features/catalog/catalog_providers.dart';

class BannersProvider extends AsyncNotifier<List<BannerEntity>> {
  @override
  Future<List<BannerEntity>> build() async {
    return await ref.watch(getBannersUsecaseProvider).call();
  }
}

final bannersProvider =
    AsyncNotifierProvider<BannersProvider, List<BannerEntity>>(
      BannersProvider.new,
    );
