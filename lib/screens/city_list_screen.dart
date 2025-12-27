import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class CityListScreen extends StatefulWidget {
  const CityListScreen({super.key});

  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  final List<String> sampleCities = [
    'Hebron', 'Nablus', 'Bethlehem', 'Jenin', 'Ramallah', 'Gaza', 'Jerusalem', 'Jericho'
  ];
  String filter = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final filtered = sampleCities
        .where((c) => c.toLowerCase().contains(filter.toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Cities')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Filter cities',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() {
                filter = v;
              }),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, idx) {
                final city = filtered[idx];
                return ListTile(
                  title: Text(city),
                  subtitle: const Text('Tap to load current weather'),
                  trailing: ElevatedButton(
                    child: const Text('Show'),
                    onPressed: () async {
                      final safeContext = context;

                      await provider.fetchCurrent(city);
                      await provider.fetch3Day(city);
                      await provider.fetchHourly(city);

                      if (!safeContext.mounted) return;

                      showModalBottomSheet(
                        context: safeContext,
                        builder: (_) {
                          final cur = provider.current;
                          if (cur == null) {
                            return const SizedBox(
                              height: 200,
                              child: Center(child: Text('No data')),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  cur.cityName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${cur.tempC} °C'),
                                    Text(cur.conditionText),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  child: const Text('More details'),
                                  onPressed: () {
                                    Navigator.pop(safeContext); 
                                    Navigator.pushNamed(
                                      safeContext,
                                      '/detail3',
                                      arguments: city,
                                    );
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}