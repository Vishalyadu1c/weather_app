
class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String sunrise; // WeatherAPI current.json doesn't provide this
  final String sunset;  // So this is optional

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    this.sunrise = '',
    this.sunset = '',
  });

  // Factory constructor to create a Weather object from JSON
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['location']['name'],
      temperature: json['current']['temp_c'].toDouble(),
      description: json['current']['condition']['text'],
      humidity: json['current']['humidity'],
      windSpeed: json['current']['wind_kph'].toDouble(),
    );
  }
}