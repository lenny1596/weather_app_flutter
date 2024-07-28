import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_flutter/models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherViewModel {
  final String apiKey;
  final String baseUrl;

  WeatherViewModel()
      : apiKey = dotenv.env['API_KEY']!,
        baseUrl = dotenv.env['BASE_URL']!;

  // method to get weather by city name
  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

  // method to get current city of user
  Future<String> getCurrentCity() async {
    // check & get permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    // otherwise
    // get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // convert position to list of place marks
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // extract city name
    String? city = placemarks[0].locality;
    return city ?? '';
  }
}
