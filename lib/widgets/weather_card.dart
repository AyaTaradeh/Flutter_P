import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final CurrentWeather current;
  const WeatherCard({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.network(current.iconUrl, width: 64, height: 64),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(current.cityName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(current.conditionText),
                ],
              ),
            ),
            Text('${current.tempC.toStringAsFixed(0)}°C', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
