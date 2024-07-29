import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_flutter/models/weather.dart';
import 'package:weather_app_flutter/viewmodels/weather_view_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // initialize weather
  Weather? _weather;

  // fetch weather method
  _fetchWeather() async {
    final String cityName = await WeatherViewModel().getCurrentCity();
    try {
      final weather = await WeatherViewModel().getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      throw Exception('error message: $e');
    }
  }

  // weather animations
  String getWeatherAnimations(String? condition) {
    if (condition == null) return 'assets/Animation - sunny.json';
    switch (condition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
      case 'dust':
        return 'assets/Animation - cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/Animation - rainy.json';
      case 'thunderstorm':
        return 'assets/Animation - thunder.json';
      case 'clear':
        return 'assets/Animation - sunny.json';
      default:
        return 'assets/Animation - sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // city name
          Text(
            _weather?.cityName ?? 'Loading city...',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),

          // animation
          Lottie.asset(
            getWeatherAnimations(_weather?.condition),
          ),
          // temperature
          Column(
            children: [
              Text(
                '${_weather?.temperature.round()}\u00B0C',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              // weather condition
              Text(
                _weather?.condition ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
