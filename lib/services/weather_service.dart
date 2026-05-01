import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/hourly_weather_model.dart';

class WeatherService {
  Future<WeatherModel> getCurrentWeatherByCity(String cityName) async {
    final url = ApiConfig.buildUrl('/weather', {'q': cityName});
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Không tìm thấy thành phố');
    } else {
      throw Exception('Lỗi tải dữ liệu thời tiết');
    }
  }

  Future<WeatherModel> getCurrentWeatherByCoords(double lat, double lon) async {
    final url = ApiConfig.buildUrl('/weather', {
      'lat': lat.toString(),
      'lon': lon.toString(),
    });
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Lỗi tải dữ liệu thời tiết');
    }
  }

  Future<List<ForecastModel>> getForecast(String cityName) async {
    final url = ApiConfig.buildUrl('/forecast', {'q': cityName});
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['list'] as List)
          .map((item) => ForecastModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Lỗi tải dự báo thời tiết');
    }
  }

  Future<List<HourlyWeatherModel>> getHourlyForecast(String cityName) async {
    final url = ApiConfig.buildUrl('/forecast', {'q': cityName, 'cnt': '8'});
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['list'] as List)
          .map((item) => HourlyWeatherModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Lỗi tải dự báo theo giờ');
    }
  }
}