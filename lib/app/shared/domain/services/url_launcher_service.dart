/// Contrato de servicio para abrir URLs externas.
abstract class UrlLauncherService {
  /// Abre una URL externa en el navegador o aplicación correspondiente.
  Future<bool> launchUrlString(String url);
}
