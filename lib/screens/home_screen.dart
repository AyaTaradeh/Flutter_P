import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  Future<void> _openMap(double lat, double lon) async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lon');

    if (await canLaunchUrl(url)) {
      await launchUrl(url,
          mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'City or lat,lon',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final q = _searchController.text.trim();
                  if (q.isNotEmpty) {
                    provider.fetchCurrent(q);
                    provider.fetch3Day(q);
                    provider.fetchHourly(q);
                  }
                },
                child: const Text('Search'),
              )
            ],
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.my_location),
            label: const Text('Use Current Location'),
            onPressed: () => provider.fetchByLocation(),
          ),
          const SizedBox(height: 12),
          if (provider.current != null) ...[
            WeatherCard(current: provider.current!),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/detail3',
                      arguments: provider.lastQuery,
                    );
                  },
                  child: const Text('3-day Forecast'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/hourly',
                      arguments: provider.lastQuery,
                    );
                  },
                  child: const Text('Hourly'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _openMap(
                provider.current!.lat,
                provider.current!.lon,
              ),
              child: const Text('Open in Maps'),
            )
          ],
          if (provider.isLoadingCurrent ||
              provider.isLoadingThreeDay ||
              provider.isLoadingHourly)
            const Center(child: CircularProgressIndicator()),
          if (provider.error.isNotEmpty)
            Text(provider.error,
                style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
