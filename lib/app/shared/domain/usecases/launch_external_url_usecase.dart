import 'package:marcos_malaga_app/app/shared/domain/services/url_launcher_service.dart';

/// Caso de uso para lanzar una URL externa.
class LaunchExternalUrlUsecase {
  final UrlLauncherService service;

  const LaunchExternalUrlUsecase({required this.service});

  Future<bool> call(String url) {
    return service.launchUrlString(url);
  }
}
