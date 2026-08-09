import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/core/presentation/providers/store_schedule_ui_provider.dart';

class BusinessInfoSection extends ConsumerWidget {
  const BusinessInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStoreInfo = ref.watch(storeScheduleUiProvider);
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(color: Colors.white, fontSize: 14);
    final titleStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
    return asyncStoreInfo.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error al cargar info: $error'),
      data: (uiModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text('Tienda Física', style: titleStyle),
                Text(uiModel.fullAddress, style: style),
              ],
            ),
            const Gap(30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text('Horario de Atención', style: titleStyle),
                Text(uiModel.formattedSchedule, style: style),
              ],
            ),
          ],
        );
      },
    );
  }
}
