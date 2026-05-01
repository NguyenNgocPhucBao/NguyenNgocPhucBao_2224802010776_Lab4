import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';

class DailyForecastCard extends StatelessWidget {
  final ForecastModel forecast;

  const DailyForecastCard({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              DateFormat('EEE, d/M').format(forecast.dateTime),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          CachedNetworkImage(
            imageUrl:
                'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
            height: 36,
            errorWidget: (_, __, ___) =>
                Icon(Icons.wb_cloudy, color: Colors.white, size: 36),
          ),
          Spacer(),
          Text(
            forecast.description,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          SizedBox(width: 8),
          Text(
            '${forecast.tempMin.round()}° / ${forecast.tempMax.round()}°',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}