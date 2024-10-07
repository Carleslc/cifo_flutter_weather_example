import 'package:flutter/material.dart';

import '../models/meteo.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import 'forecast_day.dart';

/// Previsió meteorològica dels pròxims dies en una ubicació determinada
class ForecastList extends StatelessWidget {
  static final WeatherService _weatherService = WeatherService();

  final LatLng location;

  const ForecastList({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _weatherService.fetchWeatherData(location),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  'Carregant meteorologia...',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          debugPrint('Error (Meteo): ${snapshot.error}');
          return Center(
            child: Text(
              'Error obtenint la meteorologia',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 20,
              ),
            ),
          );
        }
        final Meteo meteo = snapshot.data!;

        final forecastDays = _groupByDate(meteo.dataseries);

        return SingleChildScrollView(
          child: Column(
            children: [
              for (final forecastDay in forecastDays)
                ForecastDay(
                  location: location,
                  dataseries: forecastDay,
                )
            ],
          ),
        );
      },
    );
  }

  /// Divideix els dataseries en grups amb el mateix dia
  /// Cada llista L de la llista resultant conté les hores del dia que comparteixen
  /// tots els dataseries de la llista L
  static List<List<Dataserie>> _groupByDate(List<Dataserie> dataseries) {
    List<List<Dataserie>> forecasts = [];

    if (dataseries.isEmpty) return forecasts;

    List<Dataserie> currentGroup = [dataseries.first];

    DateTime currentDate = DateTime(
      dataseries.first.dateTime.year,
      dataseries.first.dateTime.month,
      dataseries.first.dateTime.day,
    );

    for (int i = 1; i < dataseries.length; i++) {
      Dataserie dataserie = dataseries[i];

      DateTime dataserieDate = DateTime(
        dataserie.dateTime.year,
        dataserie.dateTime.month,
        dataserie.dateTime.day,
      );

      if (dataserieDate == currentDate) {
        currentGroup.add(dataserie);
      } else {
        forecasts.add(currentGroup);
        currentGroup = [dataserie];
        currentDate = dataserieDate;
      }
    }

    forecasts.add(currentGroup);

    return forecasts;
  }
}
