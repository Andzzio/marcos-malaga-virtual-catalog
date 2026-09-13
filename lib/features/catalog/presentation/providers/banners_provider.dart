import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/providers/features/catalog/catalog_providers.dart';

class BannersProvider extends AsyncNotifier<List<BannerEntity>> {
  @override
  Future<List<BannerEntity>> build() async {
    return await ref.watch(getBannersUsecaseProvider).call();
  }

  Future<void> createBanner(BannerEntity banner) async {
    await ref.read(createBannerUsecaseProvider)(banner);
    ref.invalidateSelf();
  }

  Future<void> updateBanner(BannerEntity banner) async {
    await ref.read(updateBannerUsecaseProvider)(banner);
    ref.invalidateSelf();
  }

  Future<void> deleteBanner(BannerEntity banner) async {
    await ref.read(deleteBannerUsecaseProvider)(banner);
    ref.invalidateSelf();
  }

  Future<void> toggleActive(BannerEntity banner) async {
    final updated = banner.copyWith(isActive: !banner.isActive);
    await ref.read(updateBannerUsecaseProvider)(updated);
    ref.invalidateSelf();
  }

  Future<void> moveUp(int index) async {
    final current = state.value;
    if (current == null || index <= 0) return;
    final list = List<BannerEntity>.from(current);
    final item = list.removeAt(index);
    list.insert(index - 1, item);
    state = AsyncValue.data(list);
    await ref.read(reorderBannersUsecaseProvider)(list.map((b) => b.id).toList());
    ref.invalidateSelf();
  }

  Future<void> moveDown(int index) async {
    final current = state.value;
    if (current == null || index >= current.length - 1) return;
    final list = List<BannerEntity>.from(current);
    final item = list.removeAt(index);
    list.insert(index + 1, item);
    state = AsyncValue.data(list);
    await ref.read(reorderBannersUsecaseProvider)(list.map((b) => b.id).toList());
    ref.invalidateSelf();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final current = state.value;
    if (current == null) return;
    final list = List<BannerEntity>.from(current);
    if (newIndex > oldIndex) newIndex--;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    state = AsyncValue.data(list);
    await ref.read(reorderBannersUsecaseProvider)(list.map((b) => b.id).toList());
    ref.invalidateSelf();
  }
}

final bannersProvider =
    AsyncNotifierProvider<BannersProvider, List<BannerEntity>>(
      BannersProvider.new,
    );
