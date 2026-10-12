/// Build-time configuration.
///
/// Values are injected with `--dart-define` (or `--dart-define-from-file=env.json`)
/// so that no API key or backend host is committed to the repository.
/// See README > Configuration.
class Env {
  Env._();

  /// Google Maps / Places / Directions web-service key.
  static const String mapsApiKey = String.fromEnvironment('MAPS_API_KEY');

  /// Base URL of the Visit Egypt content API (companies, events, culture, comments).
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com/api',
  );

  /// OpenWeatherMap key used by the weather screen.
  static const String openWeatherApiKey =
      String.fromEnvironment('OPENWEATHER_API_KEY');

  /// free.currconv.com key used by the currency converter.
  static const String currencyApiKey = String.fromEnvironment('CURRCONV_API_KEY');

  /// Inbox that receives "report a problem" e-mails.
  static const String supportEmail = String.fromEnvironment('SUPPORT_EMAIL');

  /// WhatsApp support number in international format without "+".
  static const String supportWhatsApp = String.fromEnvironment('SUPPORT_WHATSAPP');
}
