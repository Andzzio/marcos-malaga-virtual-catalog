import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/app/core/presentation/mappers/store_schedule_ui_mapper.dart';
import 'package:marcos_malaga_app/app/core/presentation/models/store_schedule_ui_model.dart';
import 'package:marcos_malaga_app/app/core/presentation/providers/store_info_provider.dart';

final storeScheduleUiProvider =
    FutureProvider.autoDispose<StoreScheduleUiModel>((ref) async {
      final entity = await ref.watch(storeInfoProvider.future);
      return StoreScheduleUiMapper.fromEntity(entity);
    });
