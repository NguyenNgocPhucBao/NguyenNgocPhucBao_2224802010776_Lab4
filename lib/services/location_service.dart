import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/location_model.dart';

class LocationService {
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  Future<Position> getCurrentPosition() async {
    bool hasPermission = await checkPermission();
    if (!hasPermission) throw Exception('Quyền vị trí bị từ chối');

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getCityName(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        return placemarks[0].locality ?? 'Unknown';
      }
      return 'Unknown';
    } catch (e) {
      throw Exception('Không thể lấy tên thành phố');
    }
  }

  Future<LocationModel> getCurrentLocation() async {
    final position = await getCurrentPosition();
    final cityName = await getCityName(position.latitude, position.longitude);
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      cityName: cityName,
    );
  }
}