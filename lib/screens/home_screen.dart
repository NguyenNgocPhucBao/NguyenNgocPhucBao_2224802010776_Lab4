import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/weather_detail_item.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';
import '../models/forecast_model.dart';
import 'package:intl/intl.dart';
import 'search_screen.dart';
import 'forecast_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  LinearGradient _getGradient(String condition) {
    final hour = DateTime.now().hour;
    final isNight = hour < 6 || hour > 18;

    if (isNight) {
      return LinearGradient(
        colors: [Color(0xFF2D3748), Color(0xFF1A202C)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    switch (condition.toLowerCase()) {
      case 'clear':
        return LinearGradient(
          colors: [Color(0xFF87CEEB), Color(0xFFFDB813)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'rain':
      case 'drizzle':
        return LinearGradient(
          colors: [Color(0xFF4A5568), Color(0xFF718096)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'clouds':
        return LinearGradient(
          colors: [Color(0xFFA0AEC0), Color(0xFFCBD5E0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'thunderstorm':
        return LinearGradient(
          colors: [Color(0xFF2D3748), Color(0xFF4A5568)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'snow':
        return LinearGradient(
          colors: [Color(0xFFE2E8F0), Color(0xFFCBD5E0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'haze':
      case 'mist':
      case 'fog':
        return LinearGradient(
          colors: [Color(0xFFA0AEC0), Color(0xFF718096)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return LinearGradient(
          colors: [Color(0xFF87CEEB), Color(0xFFFDB813)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WeatherProvider>(
        builder: (context, provider, _) {
          if (provider.state == WeatherState.loading) {
            return LoadingShimmer();
          }

          if (provider.state == WeatherState.error &&
              provider.currentWeather == null) {
            return ErrorWidgetCustom(
              message: provider.errorMessage,
              onRetry: () => provider.fetchWeatherByLocation(),
            );
          }

          if (provider.currentWeather == null) {
            return Center(child: Text('Không có dữ liệu'));
          }

          final weather = provider.currentWeather!;

          return Container(
            decoration: BoxDecoration(
              gradient: _getGradient(weather.mainCondition),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: provider.refresh,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.my_location, color: Colors.white),
                            onPressed: () => provider.fetchWeatherByLocation(),
                          ),
                          Column(
                            children: [
                              Text(
                                weather.cityName,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                weather.country,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  provider.isFavorite(weather.cityName)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.white,
                                ),
                                onPressed: () =>
                                    provider.toggleFavorite(weather.cityName),
                              ),
                              IconButton(
                                icon: Icon(Icons.search, color: Colors.white),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SearchScreen()),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Cache badge
                      if (provider.isFromCache)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '📦 Dữ liệu từ cache',
                            style: TextStyle(
                                color: Colors.orange[200], fontSize: 12),
                          ),
                        ),

                      SizedBox(height: 16),

                      // Current weather card
                      CurrentWeatherCard(weather: weather),

                      SizedBox(height: 24),

                      // Weather details
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            WeatherDetailItem(
                              icon: Icons.water_drop,
                              value: '${weather.humidity}%',
                              label: 'Độ ẩm',
                            ),
                            WeatherDetailItem(
                              icon: Icons.air,
                              value: '${weather.windSpeed.round()} m/s',
                              label: 'Gió',
                            ),
                            WeatherDetailItem(
                              icon: Icons.compress,
                              value: '${weather.pressure} hPa',
                              label: 'Áp suất',
                            ),
                            if (weather.visibility != null)
                              WeatherDetailItem(
                                icon: Icons.visibility,
                                value:
                                    '${(weather.visibility! / 1000).round()} km',
                                label: 'Tầm nhìn',
                              ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Hourly forecast
                      if (provider.forecast.isNotEmpty)
                        HourlyForecastList(forecasts: provider.forecast),

                      SizedBox(height: 24),

                      // Daily forecast
                      if (provider.forecast.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Dự báo 5 ngày',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ForecastScreen()),
                              ),
                              child: Text(
                                'Xem thêm →',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        ..._getDailyForecasts(provider.forecast)
                            .map((f) => DailyForecastCard(forecast: f)),
                      ],

                      SizedBox(height: 16),

                      // Settings button
                      TextButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SettingsScreen()),
                        ),
                        icon: Icon(Icons.settings, color: Colors.white70),
                        label: Text(
                          'Cài đặt',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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