class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static String apiKey = '';

  static String buildUrl(String endpoint, Map<String, dynamic> params) {
    params['appid'] = apiKey;
    params['units'] = 'metric';
    final uri = Uri.parse('$baseUrl$endpoint')
        .replace(queryParameters: params.map((k, v) => MapEntry(k, v.toString())));
    return uri.toString();
  }
}