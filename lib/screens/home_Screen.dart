// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Providers/weather_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);

    final weather = weatherProvider.weatherModel;
    final condition = weather?.description ?? '';
    final gradient = weatherProvider.getGradientColors(condition);

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: weatherProvider.searchController,
                      onSubmitted: (_) => weatherProvider.fetchWeatherData(),
                      decoration: InputDecoration(
                        hintText: 'Enter city name',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.blueAccent,
                          ),
                          onPressed: weatherProvider.fetchWeatherData,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  if (weatherProvider.isLoading)
                    const CircularProgressIndicator(color: Colors.white)
                  else if (weatherProvider.error.isNotEmpty)
                    Column(
                      children: [
                        Text(
                          weatherProvider.error,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 50),
                        IconButton(
                          onPressed: () => weatherProvider.initDefaultWeather(),
                          icon: Icon(
                            Icons.refresh,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
                      weatherProvider.getEmoji(weather.description),
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
                      weatherProvider.getMessage(weather.description),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 50),
                    if (weatherProvider.currentArea != weatherProvider.area)
                      IconButton(
                        onPressed: () => weatherProvider.initDefaultWeather(),
                        icon: Icon(
                          Icons.refresh,
                          size: 40,
                          color: Colors.white,
                        ),
                      )
                    else
                      SizedBox(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
