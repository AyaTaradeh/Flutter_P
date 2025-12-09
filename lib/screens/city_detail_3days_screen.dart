import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class CityDetail3DaysScreen extends StatefulWidget {
  const CityDetail3DaysScreen({super.key});
  @override
  State<CityDetail3DaysScreen> createState() => _CityDetail3DaysScreenState();
}

class _CityDetail3DaysScreenState extends State<CityDetail3DaysScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final city = ModalRoute.of(context)!.settings.arguments as String?;
    if (city != null) {
      Provider.of<WeatherProvider>(context, listen: false).fetch3Day(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('3-day Forecast')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.threeDay == null
              ? const Center(child: Text('No data'))
              : ListView.builder(
                  itemCount: provider.threeDay!.length,
                  itemBuilder: (context, idx) {
                    final day = provider.threeDay![idx];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Image.network(day.iconUrl),
                        title: Text(day.date),
                        subtitle: Text(day.conditionText),
                        trailing: Text('${day.minTemp.toStringAsFixed(0)}° / ${day.maxTemp.toStringAsFixed(0)}°C'),
                      ),
                    );
                  },
                ),
    );
  }
}
