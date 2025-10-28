import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';


class WeatherService {
  final String apiKey = '98fa223ef2684b22a4b165112240502';

  Future<WeatherModel> getWeather(String cityName) async {
    final url = Uri.parse(
      'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$cityName',
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