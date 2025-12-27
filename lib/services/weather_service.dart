import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String apiKey = '45e2b7b9e40844a6855164615252712';
  static const String baseUrl = 'http://api.weatherapi.com/v1';

  Future<CurrentWeather> getCurrentByQuery(String query) async {
    final url = Uri.parse('$baseUrl/current.json?key=$apiKey&q=$query');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed to load current weather');
    }
    final json = jsonDecode(res.body);
    return CurrentWeather.fromApi(json);
  }

  Future<List<ForecastDay>> get3DayForecast(String query) async {
    final url = Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$query&days=3&aqi=no&alerts=no');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed to load forecast');
    }
    final json = jsonDecode(res.body);
    final forecastDays = (json['forecast']['forecastday'] as List)
        .map((e) => ForecastDay.fromApi(e))
        .toList();
    return forecastDays;
  }

  Future<List<HourlyForecast>> getHourly(String query) async {
    final url = Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$query&hours=24&days=1&aqi=no&alerts=no');
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Failed to load hourly');
    }
    final json = jsonDecode(res.body);
    final list = (json['forecast']['forecastday'][0]['hour'] as List)
        .map((e) => HourlyForecast.fromApi(e))
        .toList();
    return list;
  }

  Future<CurrentWeather> getByLatLon(double lat, double lon) async {
    final q = '$lat,$lon';
    return getCurrentByQuery(q);
  }
}
