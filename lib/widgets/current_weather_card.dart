import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          DateFormat('EEEE, d MMMM yyyy').format(weather.dateTime),
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        SizedBox(height: 12),
        CachedNetworkImage(
          imageUrl:
              'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
          height: 120,
          placeholder: (_, __) =>
              CircularProgressIndicator(color: Colors.white),
          errorWidget: (_, __, ___) =>
              Icon(Icons.wb_sunny, size: 100, color: Colors.white),
        ),
        Text(
          '${weather.temperature.round()}°C',
          style: TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.w200,
            color: Colors.white,
          ),
        ),
        Text(
          weather.description.toUpperCase(),
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        SizedBox(height: 4),
        Text(
          'Cảm giác như ${weather.feelsLike.round()}°C',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        SizedBox(height: 4),
        Text(
          '↓ ${weather.tempMin?.round()}°  ↑ ${weather.tempMax?.round()}°',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}