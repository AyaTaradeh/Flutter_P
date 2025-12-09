import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // optionally load by GPS on start
    final provider = Provider.of<WeatherProvider>(context, listen: false);
    // we won't auto-fetch here to avoid permission prompt; user can use button
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.location_city),
              title: const Text('Cities'),
              onTap: () => Navigator.pushNamed(context, '/cities'),
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Weather Map'),
              onTap: () async {
                // sample action; user can implement maps link
                // open a generic map link for current city if exists
                if (provider.current != null) {
                  final lat = provider.current!.lat;
                  final lon = provider.current!.lon;
                  final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
                  // use url_launcher
                  // ignore: use_build_context_synchronously
                  // open external
                }
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (provider.current != null) {
            await provider.fetchCurrent(provider.current!.cityName);
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search city (name or lat,lon)',
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
                      provider.fetchHourly(q).then((_) => provider.checkAlertsFromHourlyAndNotify());
                    }
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.my_location),
              label: const Text('Use Current Location'),
              onPressed: () => provider.fetchByLocation(),
            ),
            const SizedBox(height: 16),
            if (provider.isLoading) const Center(child: CircularProgressIndicator()),
            if (provider.error.isNotEmpty) Text('Error: ${provider.error}', style: const TextStyle(color: Colors.red)),
            if (provider.current != null) ...[
              WeatherCard(current: provider.current!),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (provider.current != null) {
                        Navigator.pushNamed(context, '/detail3', arguments: provider.current!.cityName);
                      }
                    },
                    child: const Text('3-day Forecast'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (provider.current != null) {
                        Navigator.pushNamed(context, '/hourly', arguments: provider.current!.cityName);
                      }
                    },
                    child: const Text('Hourly Forecast'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
