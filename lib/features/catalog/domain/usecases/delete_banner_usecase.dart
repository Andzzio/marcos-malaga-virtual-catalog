import 'package:marcos_malaga_app/app/shared/data/datasources/firebase_storage_datasource.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';

class DeleteBannerUsecase {
  final BannersRepository repo;
  final FirebaseStorageDatasource? storage;

  DeleteBannerUsecase({required this.repo, this.storage});

  Future<void> call(BannerEntity banner) async {
    // 1. Borrar medios de Firebase Storage usando las URLs directas del banner
    if (storage != null) {
      await _deleteMedia(banner.desktopUrl, banner.desktopMediaType);
      await _deleteMedia(banner.mobileUrl, banner.mobileMediaType);
    }

    // 2. Borrar documento de Firestore
    await repo.deleteBanner(banner.id);
  }

  Future<void> _deleteMedia(String url, BannerMediaType mediaType) async {
    if (url.isEmpty || !url.startsWith('https://') || !url.contains('firebasestorage.googleapis.com')) {
      return;
    }

    await storage?.deleteFileByUrl(url);

    // Si es imagen y tiene versión de alta resolución (_original.webp), también borrar la miniatura (_800.webp)
    if (mediaType == BannerMediaType.image && url.contains('_original.webp')) {
      final thumbUrl = url.replaceAll('_original.webp', '_800.webp');
      await storage?.deleteFileByUrl(thumbUrl);
    }
  }
}
