import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/core/widgets/custom_text_tield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:geocoding/geocoding.dart' as geoCoding;

import '../address_notifier.dart';

class AddressPickerScreen extends StatefulWidget {
  const AddressPickerScreen({super.key});

  @override
  State<AddressPickerScreen> createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen> {
  String? _currentCity;
  String? _currentState;
  geo.Position? _currentPosition;
  bool _isLoading = false;
  bool _isConfirmLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentCityState();
  }

  Future<void> _getCurrentCityState() async {
    setState(() => _isLoading = true);

    bool serviceEnabled;
    geo.LocationPermission permission;

    serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _updateState(city: "Location services are disabled", state: null, loading: false);
      return;
    }

    permission = await geo.Geolocator.checkPermission();
    if (permission == geo.LocationPermission.denied) {
      permission = await geo.Geolocator.requestPermission();
      if (permission == geo.LocationPermission.denied) {
        _updateState(city: "Location permissions are denied", state: null, loading: false);
        return;
      }
    }

    if (permission == geo.LocationPermission.deniedForever) {
      _updateState(city: "Location permissions are permanently denied", state: null, loading: false);
      return;
    }

    try {
      _currentPosition = await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);

      List<geoCoding.Placemark> placemarks = await geoCoding.placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      geoCoding.Placemark place = placemarks.first;

      _updateState(
        city: place.locality ?? "Unknown City",
        state: place.administrativeArea ?? "Unknown State",
        loading: false,
      );
    } catch (e) {
      debugPrint("Location Error: $e");
      _updateState(city: "Error getting location", state: null, loading: false);
    }
  }

  void _updateState({String? city, String? state, required bool loading}) {
    if (mounted) {
      setState(() {
        _currentCity = city;
        _currentState = state;
        _isLoading = loading;
      });
    }
  }

  Future<void> _confirmAddress() async {
    if (_currentCity != null && _currentState != null && _currentPosition != null) {
      setState(() => _isConfirmLoading = true);

      try {
        await Provider.of<AddressNotifier>(context, listen: false).setConfirmedAddress(
          _currentCity!,
          _currentState!,
          lat: _currentPosition!.latitude,
          lng: _currentPosition!.longitude,
        );

        if (context.mounted) {
          Navigator.of(context).pop(); // स्क्रीन वापस जाए
        }
      } catch (e) {
        showCustomToast('Something went wrong: $e');
      } finally {
        if (mounted) setState(() => _isConfirmLoading = false);
      }
    } else {
      showCustomToast('Please wait for location or refresh.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Address', showBackButton: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomFormField(context, hint: 'Search Address', keyboardType: TextInputType.text),
          ),
          CustomContainer(
            border: true,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 18, color: Colors.grey.shade600),
                    const SizedBox(width: 5),
                    Text('YOUR LOCATION', style: textStyle12(context, color: Colors.grey.shade600)),
                  ],
                ),
                _isLoading
                    ? const Text('Address : Loading...')
                    : Text('Address: ${_currentCity ?? ""}${_currentState != null ? ", ${_currentState!}" : ""}'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                  onPressed: _getCurrentCityState,
                  icon: const Icon(Icons.refresh, size: 20),
                  label: Text('Refresh Location', style: textStyle12(context))),
              const SizedBox(width: 20),
              CustomContainer(
                color: CustomColor.appColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: _isConfirmLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Confirm', style: textStyle12(context, color: CustomColor.whiteColor)),
                onTap: _isConfirmLoading ? null : _confirmAddress,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
