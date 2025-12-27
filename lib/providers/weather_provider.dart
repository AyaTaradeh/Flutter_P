import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service = WeatherService();

  CurrentWeather? current;
  List<ForecastDay>? threeDay;
  List<HourlyForecast>? hourly;

  bool isLoadingCurrent = false;
  bool isLoadingThreeDay = false;
  bool isLoadingHourly = false;
  String error = '';

  String? lastQuery;

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  WeatherProvider() {
    _initNotifications();
  }

  void _initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    await _notificationsPlugin.initialize(
      const InitializationSettings(android: android, iOS: iOS),
    );
  }

  Future<void> fetchCurrent(String query) async {
    try {
      isLoadingCurrent = true;
      error = '';
      lastQuery = query;
      notifyListeners();

      current = await _service.getCurrentByQuery(query);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoadingCurrent = false;
      notifyListeners();
    }
  }

  Future<void> fetch3Day(String query) async {
    try {
      isLoadingThreeDay = true;
      error = '';
      lastQuery = query;
      notifyListeners();

      threeDay = await _service.get3DayForecast(query);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoadingThreeDay = false;
      notifyListeners();
    }
  }

  Future<void> fetchHourly(String query) async {
    try {
      isLoadingHourly = true;
      error = '';
      lastQuery = query;
      notifyListeners();

      hourly = await _service.getHourly(query);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoadingHourly = false;
      notifyListeners();
    }
  }

  /// 📍 جلب الطقس حسب الموقع الحالي (دقيق)
  Future<void> fetchByLocation() async {
    try {
      isLoadingCurrent = true;
      isLoadingThreeDay = true;
      isLoadingHourly = true;
      error = '';
      notifyListeners();

      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        error = 'Location services are disabled';
        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        error = 'Location permission permanently denied';
        return;
      }

      final pos = await Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      ).first;

      final query = '${pos.latitude},${pos.longitude}';
      lastQuery = query;

      current = await _service.getCurrentByQuery(query);
      threeDay = await _service.get3DayForecast(query);
      hourly = await _service.getHourly(query);

      await checkAlertsFromHourlyAndNotify();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoadingCurrent = false;
      isLoadingThreeDay = false;
      isLoadingHourly = false;
      notifyListeners();
    }
  }

  Future<void> checkAlertsFromHourlyAndNotify() async {
    if (hourly == null) return;

    final willRain = hourly!
        .any((h) => h.conditionText.toLowerCase().contains('rain'));

    if (willRain) {
      await _sendNotification(
        'Weather Alert',
        'Rain expected in coming hours ☔',
      );
    }
  }

  Future<void> _sendNotification(String title, String body) async {
    const android = AndroidNotificationDetails(
      'weather_channel',
      'Weather Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iOS = DarwinNotificationDetails();

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: android, iOS: iOS),
    );
  }
}
