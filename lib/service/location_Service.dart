// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/services.dart';

class LocationService {
  static const platform = MethodChannel('com.example.weather_app');

  Future<Map<String, dynamic>?> getCurrentLocation() async {
    try {
      final result = await platform.invokeMethod('getCurrentLocation');
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      log("Failed to get location: ${e.message}");
    }
    return null;
  }
}
