import 'package:flutter/material.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';

enum LocationState { initial, loading, loaded, error }

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();

  LocationModel? _currentLocation;
  LocationState _state = LocationState.initial;
  String _errorMessage = '';

  LocationModel? get currentLocation => _currentLocation;
  LocationState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> fetchCurrentLocation() async {
    _state = LocationState.loading;
    notifyListeners();

    try {
      _currentLocation = await _locationService.getCurrentLocation();
      _state = LocationState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = LocationState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }
}