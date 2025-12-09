import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import 'package:intl/intl.dart';

class HourlyForecastScreen extends StatefulWidget {
  const HourlyForecastScreen({super.key});
  @override
  State<HourlyForecastScreen> createState() => _HourlyForecastScreenState();
}

class _HourlyForecastScreenState extends State<HourlyForecastScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final city = ModalRoute.of(context)!.settings.arguments as String?;
    if (city != null) {
      Provider.of<WeatherProvider>(context, listen: false).fetchHourly(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Hourly Forecast')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.hourly == null
              ? const Center(child: Text('No data'))
              : ListView.builder(
                  itemCount: provider.hourly!.length,
                  itemBuilder: (context, idx) {
                    final h = provider.hourly![idx];
                    final time = h.time;
                    // show only hour portion if format includes space
                    final displayTime = time;
                    return ListTile(
                      leading: Image.network(h.iconUrl),
                      title: Text('$displayTime'),
                      subtitle: Text(h.conditionText),
                      trailing: Text('${h.tempC.toStringAsFixed(0)}°C'),
                    );
                  },
                ),
    );
  }
}
