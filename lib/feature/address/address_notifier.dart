// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AddressNotifier extends ChangeNotifier {
//   String _confirmedAddress = '';
//   double? _latitude;
//   double? _longitude;
//
//   String get confirmedAddress => _confirmedAddress;
//   double? get latitude => _latitude;
//   double? get longitude => _longitude;
//
//   AddressNotifier() {
//     _loadConfirmedAddress();
//   }
//
//   Future<void> _loadConfirmedAddress() async {
//     final prefs = await SharedPreferences.getInstance();
//     final city = prefs.getString('user_city');
//     final state = prefs.getString('user_state');
//     _latitude = prefs.getDouble('user_lat');
//     _longitude = prefs.getDouble('user_lng');
//
//     if (city != null && state != null) {
//       _confirmedAddress = '$city, $state';
//     } else {
//       _confirmedAddress = '';
//     }
//     notifyListeners();
//   }
//
//   Future<void> setConfirmedAddress(
//       String city,
//       String state, {
//         double? lat,
//         double? lng,
//       }) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('user_city', city);
//     await prefs.setString('user_state', state);
//
//     if (lat != null && lng != null) {
//       await prefs.setDouble('user_lat', lat);
//       await prefs.setDouble('user_lng', lng);
//       _latitude = lat;
//       _longitude = lng;
//     }
//
//     _confirmedAddress = '$city, $state';
//     notifyListeners();
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class AddressNotifier extends ChangeNotifier {
  String _confirmedAddress = '';
  double? _latitude;
  double? _longitude;

  String get confirmedAddress => _confirmedAddress;
  double? get latitude => _latitude;
  double? get longitude => _longitude;

  AddressNotifier() {
    _initLocation();
  }

  Future<void> _initLocation() async {
    await _loadConfirmedAddress();
    await _fetchCurrentLocation();
  }

  Future<void> _loadConfirmedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final city = prefs.getString('user_city');
    final state = prefs.getString('user_state');
    _latitude = prefs.getDouble('user_lat');
    _longitude = prefs.getDouble('user_lng');

    if (city != null && state != null) {
      _confirmedAddress = '$city, $state';
    } else {
      _confirmedAddress = '';
    }
    notifyListeners();
  }

  Future<void> _fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _latitude = position.latitude;
    _longitude = position.longitude;

    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(_latitude!, _longitude!);

      if (placemarks.isNotEmpty) {
        String city = placemarks.first.locality ?? '';
        String state = placemarks.first.administrativeArea ?? '';
        _confirmedAddress = '$city, $state';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_city', city);
        await prefs.setString('user_state', state);
        await prefs.setDouble('user_lat', _latitude!);
        await prefs.setDouble('user_lng', _longitude!);
      }
    } catch (e) {
      print('Error in reverse geocoding: $e');
    }

    notifyListeners();
  }

  Future<void> setConfirmedAddress(String city, String state,
      {double? lat, double? lng}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_city', city);
    await prefs.setString('user_state', state);

    if (lat != null && lng != null) {
      await prefs.setDouble('user_lat', lat);
      await prefs.setDouble('user_lng', lng);
      _latitude = lat;
      _longitude = lng;
    }

    _confirmedAddress = '$city, $state';
    notifyListeners();
  }
}
