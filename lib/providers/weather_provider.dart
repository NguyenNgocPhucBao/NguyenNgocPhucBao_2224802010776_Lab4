import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  final StorageService _storageService = StorageService();
  final ConnectivityService _connectivityService = ConnectivityService();

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';
  bool _isFromCache = false;
  String _tempUnit = 'metric';
  List<String> _favoriteCities = [];

  // Getters
  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isFromCache => _isFromCache;
  String get tempUnit => _tempUnit;
  List<String> get favoriteCities => _favoriteCities;

  WeatherProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _tempUnit = await _storageService.getTempUnit();
    _favoriteCities = await _storageService.getFavorites();
    notifyListeners();
  }

  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final isOnline = await _connectivityService.isConnected();
      if (!isOnline) {
        await _loadCachedWeather();
        return;
      }

      _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName);
      _forecast = await _weatherService.getForecast(cityName);
      await _storageService.saveWeather(_currentWeather!);
      _isFromCache = false;
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final isOnline = await _connectivityService.isConnected();
      if (!isOnline) {
        await _loadCachedWeather();
        return;
      }

      final location = await _locationService.getCurrentLocation();
      _currentWeather = await _weatherService.getCurrentWeatherByCoords(
        location.latitude,
        location.longitude,
      );
      _forecast = await _weatherService.getForecast(location.cityName);
      await _storageService.saveWeather(_currentWeather!);
      _isFromCache = false;
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      await _loadCachedWeather();
    }
    notifyListeners();
  }

  Future<void> _loadCachedWeather() async {
    final cached = await _storageService.getCachedWeather();
    if (cached != null) {
      _currentWeather = cached;
      _isFromCache = true;
      _state = WeatherState.loaded;
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }

  Future<void> toggleFavorite(String cityName) async {
    if (_favoriteCities.contains(cityName)) {
      _favoriteCities.remove(cityName);
    } else if (_favoriteCities.length < 5) {
      _favoriteCities.add(cityName);
    }
    await _storageService.saveFavorites(_favoriteCities);
    notifyListeners();
  }

  bool isFavorite(String cityName) => _favoriteCities.contains(cityName);

  Future<void> setTempUnit(String unit) async {
    _tempUnit = unit;
    await _storageService.saveTempUnit(unit);
    notifyListeners();
  }
}