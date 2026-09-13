import 'package:url_launcher/url_launcher.dart' as ul;
import 'package:marcos_malaga_app/app/shared/domain/services/url_launcher_service.dart';

/// Implementación de [UrlLauncherService] utilizando el paquete `url_launcher`.
class UrlLauncherServiceImpl implements UrlLauncherService {
  const UrlLauncherServiceImpl();

  @override
  Future<bool> launchUrlString(String url) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return false;

    // Si no cuenta con esquema, anteponer https:// por defecto
    final formatted = (!trimmed.startsWith('http://') && !trimmed.startsWith('https://'))
        ? 'https://$trimmed'
        : trimmed;

    final uri = Uri.tryParse(formatted);
    if (uri == null) return false;

    try {
      return await ul.launchUrl(
        uri,
        mode: ul.LaunchMode.externalApplication,
      );
    } catch (_) {
      return false;
    }
  }
}
