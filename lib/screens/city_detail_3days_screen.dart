import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class CityDetail3DaysScreen extends StatefulWidget {
  const CityDetail3DaysScreen({super.key});

  @override
  State<CityDetail3DaysScreen> createState() =>
      _CityDetail3DaysScreenState();
}

class _CityDetail3DaysScreenState
    extends State<CityDetail3DaysScreen> {
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
        ).fetch3Day(query);

        _hasFetched = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    if (provider.isLoadingThreeDay) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('3-day Forecast')),
        body: Center(
          child: Text(
            provider.error,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    final data = provider.threeDay;

    if (data == null || data.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No forecast data')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('3-day Forecast')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: data.length,
        itemBuilder: (context, index) {
          final day = data[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: Image.network(day.iconUrl, width: 40),
              title: Text(day.date),
              subtitle: Text(day.conditionText),
              trailing: Text(
                '${day.minTemp.toStringAsFixed(0)}° / '
                '${day.maxTemp.toStringAsFixed(0)}°C',
              ),
            ),
          );
        },
      ),
    );
  }
}
