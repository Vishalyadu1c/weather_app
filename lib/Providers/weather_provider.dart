import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import '../service/location_Service.dart';
import '../service/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService.instance;
  WeatherModel? weatherModel;
  String? currentArea;
  String?area;

  bool isLoading = false;
  String error = '';

  Future<void> fetchWeatherData() async {
    final city = searchController.text.trim();
    if (city.isEmpty) return;
    isLoading = true;
    error = '';
    notifyListeners();

    try {
      final weather = await _weatherService.getWeather(city);

      weatherModel = weather;
      isLoading = false;
      currentArea = weather.cityName;
      searchController.clear();
      notifyListeners();
    } catch (e) {
      error = 'Could not fetch weather.';
      isLoading = false;
      searchController.clear();
      notifyListeners();
    }
  }

  Future<void> initDefaultWeather() async {
    isLoading = true;
    error = '';
    notifyListeners();
    try {
      final location = await LocationService().getCurrentLocation();
      currentArea = location?['area'];
      area = currentArea;
      final weather = await _weatherService.getWeather(currentArea!);
      weatherModel = weather;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      log(":${e.toString()}");
    }
  }

  List<Color> getGradientColors(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('rain')) {
      return [const Color(0xFF2193b0), const Color(0xFF6dd5ed)];
    } else if (lower.contains('sun')) {
      return [const Color(0xFFf7971e), const Color(0xFFffd200)];
    } else if (lower.contains('cloud')) {
      return [const Color(0xFF757F9A), const Color(0xFFD7DDE8)];
    } else if (lower.contains('snow')) {
      return [const Color(0xFF83a4d4), const Color(0xFFb6fbff)];
    } else {
      return [const Color(0xFF56CCF2), const Color(0xFF2F80ED)];
    }
  }

  String getEmoji(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('sun')) return '☀️';
    if (lower.contains('rain')) return '🌧️';
    if (lower.contains('cloud')) return '☁️';
    if (lower.contains('snow')) return '❄️';
    if (lower.contains('storm')) return '⛈️';
    return '🌤️';
  }

  String getMessage(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('rain')) return "Don't forget your umbrella!";
    if (lower.contains('sun')) return "Damn, it's too hot!";
    if (lower.contains('snow')) return "I love snow!";
    if (lower.contains('cloud')) return "A cloudy calm day!";
    return "Nice weather outside!";
  }
}
