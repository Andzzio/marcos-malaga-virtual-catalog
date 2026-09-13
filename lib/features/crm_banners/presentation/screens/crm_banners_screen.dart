import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/config/theme/app_theme.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/banners_provider.dart';
import 'package:marcos_malaga_app/features/crm_banners/presentation/widgets/banner_form_dialog.dart';
import 'package:marcos_malaga_app/features/crm_banners/presentation/widgets/banner_item_card.dart';

class CrmBannersScreen extends ConsumerWidget {
  const CrmBannersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsync = ref.watch(bannersProvider);
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = style?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabecera superior
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ADMINISTRADOR DE BANNERS', style: titleStyle),
                      const Gap(4),
                      Text(
                        'Configura los banners promocionales del catálogo (imágenes y videos independientes para escritorio y móvil).',
                        style: style?.copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: () => BannerFormDialog.show(context),
                  icon: const Icon(Icons.add, size: 16),
                  label: Text('Nuevo Banner', style: style?.copyWith(color: Colors.white)),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const Gap(16),

            // Tarjetas de Estadísticas / Resumen
            bannersAsync.when(
              data: (banners) {
                final total = banners.length;
                final activeCount = banners.where((b) => b.isActive).length;
                final inactiveCount = total - activeCount;

                return Row(
                  children: [
                    _buildStatChip(
                      label: 'Total Banners',
                      value: '$total',
                      icon: Icons.view_carousel_outlined,
                      color: Colors.blueGrey,
                      style: style,
                    ),
                    const Gap(12),
                    _buildStatChip(
                      label: 'Activos en Tienda',
                      value: '$activeCount',
                      icon: Icons.check_circle_outline,
                      color: Colors.green,
                      style: style,
                    ),
                    const Gap(12),
                    _buildStatChip(
                      label: 'Inactivos',
                      value: '$inactiveCount',
                      icon: Icons.pause_circle_outline,
                      color: Colors.orange,
                      style: style,
                    ),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (e, s) => const SizedBox.shrink(),
            ),
            const Gap(20),

            // Lista de Banners
            Expanded(
              child: bannersAsync.when(
                data: (banners) {
                  if (banners.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_library_outlined, size: 56, color: Colors.grey.shade400),
                          const Gap(16),
                          Text('No hay banners configurados', style: titleStyle),
                          const Gap(6),
                          Text(
                            'Crea el primer banner promocional para el carrusel de tu tienda.',
                            style: style?.copyWith(color: Colors.grey.shade600),
                          ),
                          const Gap(16),
                          FilledButton.icon(
                            onPressed: () => BannerFormDialog.show(context),
                            icon: const Icon(Icons.add, size: 16),
                            label: Text('Crear Primer Banner', style: style?.copyWith(color: Colors.white)),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      final banner = banners[index];
                      return BannerItemCard(
                        key: ValueKey(banner.id),
                        banner: banner,
                        index: index,
                        totalCount: banners.length,
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const Gap(12),
                      Text('Error al cargar banners: $error', style: style?.copyWith(color: Colors.red)),
                      const Gap(12),
                      OutlinedButton(
                        onPressed: () => ref.invalidate(bannersProvider),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Reintentar', style: style),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required TextStyle? style,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const Gap(8),
          Text('$label: ', style: style?.copyWith(color: Colors.grey.shade600)),
          Text(
            value,
            style: style?.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
