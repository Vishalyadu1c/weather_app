import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/weather_model.dart';


class WeatherService {
  // 1️⃣ Private constructor
  WeatherService._privateConstructor();

  // 2️⃣ Single instance (created only once)
  static final WeatherService _instance = WeatherService._privateConstructor();

  // 3️⃣ Public getter to access instance
  static WeatherService get instance => _instance;

  final String _apiKey = 'cf24dd6881b14a4abc5165123252810';

  // 4️⃣ API call method
  Future<WeatherModel> getWeather(String cityName) async {
    final url = Uri.parse(
      'http://api.weatherapi.com/v1/current.json?key=$_apiKey&q=$cityName',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return WeatherModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
