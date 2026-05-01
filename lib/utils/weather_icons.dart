import 'package:flutter/material.dart';

class WeatherIcons {
  static IconData getIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear': return Icons.wb_sunny;
      case 'clouds': return Icons.cloud;
      case 'rain': return Icons.umbrella;
      case 'drizzle': return Icons.grain;
      case 'thunderstorm': return Icons.bolt;
      case 'snow': return Icons.ac_unit;
      case 'mist':
      case 'fog': return Icons.foggy;
      default: return Icons.wb_cloudy;
    }
  }

  static String getIconUrl(String iconCode) =>
      'https://openweathermap.org/img/wn/$iconCode@2x.png';
}