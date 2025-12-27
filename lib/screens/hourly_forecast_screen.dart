import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class HourlyForecastScreen extends StatefulWidget {
  const HourlyForecastScreen({super.key});

  @override
  State<HourlyForecastScreen> createState() =>
      _HourlyForecastScreenState();
}

class _HourlyForecastScreenState
    extends State<HourlyForecastScreen> {
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasFetched) {
      final query =
          ModalRoute.of(context)?.settings.arguments as String?;

      if (query != null && query.isNotEmpty) {
        Provider.of<WeatherProvider>(
          context,
          listen: false,
        ).fetchHourly(query);

        _hasFetched = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    if (provider.isLoadingHourly) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hourly Forecast')),
        body: Center(
          child: Text(
            provider.error,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final data = provider.hourly;

    if (data == null || data.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No hourly data')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Hourly Forecast')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final h = data[index];
          final time =
              h.time.contains(' ') ? h.time.split(' ')[1] : h.time;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: Image.network(h.iconUrl, width: 40),
              title: Text(time),
              subtitle: Text(h.conditionText),
              trailing:
                  Text('${h.tempC.toStringAsFixed(0)}°C'),
            ),
          );
        },
      ),
    );
  }
}
