import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/weather_provider.dart';
import 'screens/home_screen.dart';
import 'screens/city_list_screen.dart';
import 'screens/city_detail_3days_screen.dart';
import 'screens/hourly_forecast_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/cities': (context) => const CityListScreen(),
          '/detail3': (context) => const CityDetail3DaysScreen(),
          '/hourly': (context) => const HourlyForecastScreen(),
        },
      ),
    );
  }
}
