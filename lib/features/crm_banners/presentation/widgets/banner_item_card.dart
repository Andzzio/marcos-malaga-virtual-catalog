import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/config/theme/app_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/image/custom_image.dart';
import 'package:marcos_malaga_app/app/shared/widgets/video/app_video_player.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/banners_provider.dart';
import 'package:marcos_malaga_app/features/crm_banners/presentation/widgets/banner_form_dialog.dart';

class BannerItemCard extends ConsumerWidget {
  final BannerEntity banner;
  final int index;
  final int totalCount;

  const BannerItemCard({
    super.key,
    required this.banner,
    required this.index,
    required this.totalCount,
  });

  void _confirmDelete(BuildContext context, WidgetRef ref, TextStyle? style, TextStyle? titleStyle) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Eliminar Banner', style: titleStyle),
        content: Text(
          '¿Estás seguro de que deseas eliminar este banner${banner.title != null ? ' "${banner.title}"' : ''}? Esta acción no se puede deshacer.',
          style: style,
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(bannersProvider.notifier).deleteBanner(banner);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Banner eliminado', style: style?.copyWith(color: Colors.white)),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: Text('Eliminar', style: style?.copyWith(color: Colors.red)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancelar', style: style?.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFirst = index == 0;
    final isLast = index == totalCount - 1;

    final style = Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = style?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: banner.isActive ? Colors.grey.shade300 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      color: banner.isActive ? Colors.white : Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Número de Orden / Posición
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: banner.isActive ? AppTheme.primaryColor : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '#${index + 1}',
                style: style?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const Gap(16),

            // 2. Previews de Medios (Desktop y Mobile)
            // Desktop preview (Aspecto apaisado)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 125,
                height: 70,
                color: Colors.black12,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    banner.desktopMediaType == BannerMediaType.video
                        ? AppVideoPlayer(
                            videoUrl: banner.desktopUrl,
                            fit: BoxFit.cover,
                            autoPlay: false,
                          )
                        : CustomImage(
                            banner.desktopUrl,
                            isAsset: banner.desktopUrl.startsWith('assets/'),
                            fit: BoxFit.cover,
                            quality: ImageQuality.thumbnail,
                          ),
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              banner.desktopMediaType == BannerMediaType.video
                                  ? Icons.videocam
                                  : Icons.image,
                              size: 10,
                              color: Colors.white,
                            ),
                            const Gap(2),
                            Text(
                              'DESK',
                              style: style?.copyWith(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (banner.desktopMediaType == BannerMediaType.video)
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.videocam_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Gap(10),

            // Mobile preview (Aspecto vertical)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 45,
                height: 70,
                color: Colors.black12,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    banner.mobileMediaType == BannerMediaType.video
                        ? AppVideoPlayer(
                            videoUrl: banner.mobileUrl,
                            fit: BoxFit.cover,
                            autoPlay: false,
                          )
                        : CustomImage(
                            banner.mobileUrl,
                            isAsset: banner.mobileUrl.startsWith('assets/'),
                            fit: BoxFit.cover,
                            quality: ImageQuality.thumbnail,
                          ),
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              banner.mobileMediaType == BannerMediaType.video
                                  ? Icons.videocam
                                  : Icons.image,
                              size: 10,
                              color: Colors.white,
                            ),
                            const Gap(2),
                            Text(
                              'MOB',
                              style: style?.copyWith(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (banner.mobileMediaType == BannerMediaType.video)
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.videocam_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const Gap(16),

            // 3. Información del Banner (Título, Acción, Estado)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          banner.title ?? 'Banner sin título',
                          style: titleStyle?.copyWith(
                            color: banner.isActive ? Colors.black87 : Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Gap(8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: banner.isActive ? Colors.green.shade50 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: banner.isActive ? Colors.green.shade300 : Colors.grey.shade400,
                          ),
                        ),
                        child: Text(
                          banner.isActive ? 'ACTIVO' : 'INACTIVO',
                          style: style?.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: banner.isActive ? Colors.green.shade800 : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'ID: ${banner.id}',
                        style: style?.copyWith(color: Colors.grey.shade500),
                      ),
                      Text('•', style: style?.copyWith(color: Colors.grey.shade400)),
                      _buildActionChip(banner, style),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(12),

            // 4. Botones de Ordenamiento (Subir / Bajar)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_up, size: 20),
                  onPressed: isFirst ? null : () => ref.read(bannersProvider.notifier).moveUp(index),
                  tooltip: 'Subir posición',
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                  onPressed: isLast ? null : () => ref.read(bannersProvider.notifier).moveDown(index),
                  tooltip: 'Bajar posición',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const Gap(8),

            // 5. Switch Activar/Desactivar
            Switch(
              value: banner.isActive,
              onChanged: (_) => ref.read(bannersProvider.notifier).toggleActive(banner),
              activeThumbColor: AppTheme.primaryColor,
            ),
            const Gap(8),

            // 6. Botones de Edición y Borrado
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18),
              onPressed: () => BannerFormDialog.show(context, banner: banner),
              tooltip: 'Editar banner',
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const Gap(6),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
              onPressed: () => _confirmDelete(context, ref, style, titleStyle),
              tooltip: 'Eliminar banner',
              style: IconButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(BannerEntity banner, TextStyle? style) {
    String label;
    IconData icon;
    Color color;

    switch (banner.actionType) {
      case BannerActionType.openCategory:
        label = 'Categoría: ${banner.actionValue ?? ''}';
        icon = Icons.category_outlined;
        color = Colors.indigo;
        break;
      case BannerActionType.openProduct:
        label = 'Producto: ${banner.actionValue ?? ''}';
        icon = Icons.shopping_bag_outlined;
        color = Colors.teal;
        break;
      case BannerActionType.openUrl:
        label = 'URL: ${banner.actionValue ?? ''}';
        icon = Icons.link;
        color = Colors.blue;
        break;
      case BannerActionType.none:
        label = 'Sin acción';
        icon = Icons.not_interested;
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const Gap(4),
          Text(
            label,
            style: style?.copyWith(fontSize: 10, fontWeight: FontWeight.w600, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
