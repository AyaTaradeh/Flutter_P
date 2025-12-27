class CurrentWeather {
  final String cityName;
  final double tempC;
  final String conditionText;
  final String iconUrl;
  final double lat;
  final double lon;

  CurrentWeather({
    required this.cityName,
    required this.tempC,
    required this.conditionText,
    required this.iconUrl,
    required this.lat,
    required this.lon,
  });

  factory CurrentWeather.fromApi(Map<String, dynamic> json) {
    final location = json['location'] ?? {};
    final current = json['current'] ?? {};

    return CurrentWeather(
      cityName: location['name'] ?? '',
      tempC: ((current['temp_c'] ?? 0) as num).toDouble(),
      conditionText: current['condition']?['text'] ?? '',
      iconUrl: 'https:${current['condition']?['icon'] ?? ''}',
      lat: ((location['lat'] ?? 0) as num).toDouble(),
      lon: ((location['lon'] ?? 0) as num).toDouble(),
    );
  }
}

class ForecastDay {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String conditionText;
  final String iconUrl;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.conditionText,
    required this.iconUrl,
  });

  factory ForecastDay.fromApi(Map<String, dynamic> json) {
    final day = json['day'] ?? {};

    return ForecastDay(
      date: json['date'] ?? '',
      maxTemp: ((day['maxtemp_c'] ?? 0) as num).toDouble(),
      minTemp: ((day['mintemp_c'] ?? 0) as num).toDouble(),
      conditionText: day['condition']?['text'] ?? '',
      iconUrl: 'https:${day['condition']?['icon'] ?? ''}',
    );
  }
}

class HourlyForecast {
  final String time;
  final double tempC;
  final String conditionText;
  final String iconUrl;

  HourlyForecast({
    required this.time,
    required this.tempC,
    required this.conditionText,
    required this.iconUrl,
  });

  factory HourlyForecast.fromApi(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['time'] ?? '',
      tempC: ((json['temp_c'] ?? 0) as num).toDouble(),
      conditionText: json['condition']?['text'] ?? '',
      iconUrl: 'https:${json['condition']?['icon'] ?? ''}',
    );
  }
}
