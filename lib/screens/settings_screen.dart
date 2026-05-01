import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: Color(0xFF1A202C),
      appBar: AppBar(
        backgroundColor: Color(0xFF2D3748),
        title: Text('Cài đặt', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          // Đơn vị nhiệt độ
          _SectionHeader(title: '🌡️ Đơn vị nhiệt độ'),
          RadioListTile<String>(
            title: Text('Celsius (°C)', style: TextStyle(color: Colors.white)),
            value: 'metric',
            groupValue: provider.tempUnit,
            onChanged: (val) => provider.setTempUnit(val!),
            activeColor: Colors.blue,
          ),
          RadioListTile<String>(
            title: Text('Fahrenheit (°F)',
                style: TextStyle(color: Colors.white)),
            value: 'imperial',
            groupValue: provider.tempUnit,
            onChanged: (val) => provider.setTempUnit(val!),
            activeColor: Colors.blue,
          ),

          Divider(color: Colors.white24),

          // Thành phố yêu thích
          _SectionHeader(title: '❤️ Thành phố yêu thích'),
          if (provider.favoriteCities.isEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Chưa có thành phố yêu thích.\nNhấn ❤️ ở màn hình chính để thêm.',
                style: TextStyle(color: Colors.white54),
              ),
            )
          else
            ...provider.favoriteCities.map(
              (city) => ListTile(
                leading: Icon(Icons.location_city, color: Colors.white70),
                title: Text(city, style: TextStyle(color: Colors.white)),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red[300]),
                  onPressed: () => provider.toggleFavorite(city),
                ),
                onTap: () {
                  provider.fetchWeatherByCity(city);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ),

          Divider(color: Colors.white24),

          // Thông tin app
          _SectionHeader(title: 'ℹ️ Thông tin'),
          ListTile(
            leading: Icon(Icons.info_outline, color: Colors.white70),
            title: Text('Phiên bản', style: TextStyle(color: Colors.white)),
            trailing:
                Text('1.0.0', style: TextStyle(color: Colors.white54)),
          ),
          ListTile(
            leading: Icon(Icons.cloud, color: Colors.white70),
            title: Text('Nguồn dữ liệu',
                style: TextStyle(color: Colors.white)),
            trailing: Text('OpenWeatherMap',
                style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}