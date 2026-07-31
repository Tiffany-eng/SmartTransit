/// Build-time configuration for the optional RapidAPI Street View fallback.
///
/// Supply the value with `--dart-define=RAPIDAPI_KEY=...`; never commit the
/// key to source control.
class MapApiConfig {
  MapApiConfig._();

  static const rapidApiKey = String.fromEnvironment('RAPIDAPI_KEY');
  static const rapidApiHost = 'google-map-places.p.rapidapi.com';

  static bool get hasRapidApiKey => rapidApiKey.isNotEmpty;
}
