// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';

import '../service/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final WeatherService _weatherService = WeatherService();

  WeatherModel? _weather;
  String _error = '';
  bool _isLoading = false;

  Future<void> _fetchWeather() async {
    final city = _controller.text.trim();
    if (city.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Could not fetch weather.';
        _isLoading = false;
      });
    }
  }

  List<Color> _getGradientColors(String condition) {
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

  String _getEmoji(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('sun')) return '☀️';
    if (lower.contains('rain')) return '🌧️';
    if (lower.contains('cloud')) return '☁️';
    if (lower.contains('snow')) return '❄️';
    if (lower.contains('storm')) return '⛈️';
    return '🌤️';
  }

  String _getMessage(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('rain')) return "Don't forget your umbrella!";
    if (lower.contains('sun')) return "Damn, it's too hot!";
    if (lower.contains('snow')) return "I love snow!";
    if (lower.contains('cloud')) return "A cloudy calm day!";
    return "Nice weather outside!";
  }

  @override
  Widget build(BuildContext context) {
    final weather = _weather;
    final condition = weather?.description ?? 'Sunny';
    final gradient = _getGradientColors(condition);

    return Scaffold(

body: Container(
  width: double.infinity,
  height: double.infinity,
  decoration: const BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/bg.png'),
      fit: BoxFit.cover, // makes it full screen
    ),
  ),
  child: Stack(
    alignment: Alignment.center,
    children: [
      // your glowing background (optional)
      Container(
        width: 500,
        height: 500,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(0.2),
              Colors.transparent,
            ],
            stops: const [0.3, 1.0],
          ),
        ),
      ),
            // 📱 Phone structure
            Container(
              width: 350, // phone width
              height: 720, // phone height
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          children: [
                            // 🔋 Fake status bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Icon(Icons.signal_cellular_alt,
                                    color: Colors.white, size: 18),
                                Text("10:24",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                                Icon(Icons.battery_full,
                                    color: Colors.white, size: 18),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Search bar
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextField(
                                controller: _controller,
                                textAlign: TextAlign.center,
                                onSubmitted: (_) => _fetchWeather(),
                                decoration: InputDecoration(
                                  hintText: 'Enter city name',
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.search,
                                        color: Colors.blueAccent),
                                    onPressed: _fetchWeather,
                                  ),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),

                            if (_isLoading)
                              const CircularProgressIndicator(
                                  color: Colors.white)
                            else if (_error.isNotEmpty)
                              Text(
                                _error,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 18),
                              )
                            else if (weather != null) ...[
                              Text(
                                weather.cityName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 25),
                              Text(
                                _getEmoji(weather.description),
                                style: const TextStyle(fontSize: 80),
                              ),
                              const SizedBox(height: 25),
                              Text(
                                '${weather.temperature}°C',
                                style: const TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                _getMessage(weather.description),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}