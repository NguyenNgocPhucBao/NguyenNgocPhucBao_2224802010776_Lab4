import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/weather_provider.dart';
import '../models/forecast_model.dart';
import '../widgets/daily_forecast_card.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();
    final forecasts = provider.forecast;
    final weather = provider.currentWeather;

    return Scaffold(
      backgroundColor: Color(0xFF1A202C),
      appBar: AppBar(
        backgroundColor: Color(0xFF2D3748),
        title: Text(
          weather != null ? 'Dự báo - ${weather.cityName}' : 'Dự báo',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: forecasts.isEmpty
          ? Center(
              child: Text(
                'Không có dữ liệu dự báo',
                style: TextStyle(color: Colors.white70),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dự báo 5 ngày tới',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ..._getDailyForecasts(forecasts)
                      .map((f) => DailyForecastCard(forecast: f)),
                  SizedBox(height: 24),
                  Text(
                    'Chi tiết theo giờ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ...forecasts.map((f) => _HourlyDetailItem(forecast: f)),
                ],
              ),
            ),
    );
  }

  List<ForecastModel> _getDailyForecasts(List<ForecastModel> forecasts) {
    final Map<String, ForecastModel> daily = {};
    for (var f in forecasts) {
      final key = DateFormat('yyyy-MM-dd').format(f.dateTime);
      if (!daily.containsKey(key)) daily[key] = f;
    }
    return daily.values.take(5).toList();
  }
}

class _HourlyDetailItem extends StatelessWidget {
  final ForecastModel forecast;
  const _HourlyDetailItem({required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF2D3748),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              DateFormat('EEE HH:mm').format(forecast.dateTime),
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '${forecast.temperature.round()}°C',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              forecast.description,
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Icon(Icons.water_drop, color: Colors.blue[300], size: 16),
          Text(
            '${forecast.humidity}%',
            style: TextStyle(color: Colors.blue[300], fontSize: 13),
          ),
          SizedBox(width: 8),
          Icon(Icons.air, color: Colors.white54, size: 16),
          Text(
            '${forecast.windSpeed.round()}m/s',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }
}