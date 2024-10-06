import 'package:flutter/material.dart';

import '../models/meteo.dart';
import '../models/weather.dart';
import '../services/location_service.dart';
import '../services/sun_service.dart';
import '../utils/date_utils.dart';
import 'sun_widget.dart';

class ForecastDay extends StatelessWidget {
  static final SunService _sunService = SunService();

  final LatLng location;
  final List<Dataserie> dataseries;

  const ForecastDay({
    super.key,
    required this.location,
    required this.dataseries,
  });

  Widget _buildForecastRow(BuildContext context, Dataserie dataserie) {
    WeatherIcon weatherIcon = dataserie.icon;
    WeatherAlert? alert = dataserie.alert;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: Column(
            children: [
              Text(dataserie.dateTime.formatTime()),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: alert != null
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              Tooltip(
                message: weatherIcon.label,
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 4),
                child: Icon(
                  weatherIcon.icon,
                  color: dataserie.day
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.inverseSurface,
                  size: 32,
                ),
              ),
              if (alert != null)
                Tooltip(
                  message: alert.label,
                  triggerMode: TooltipTriggerMode.tap,
                  child: Icon(
                    alert.icon,
                    color: alert.color,
                    size: 28,
                  ),
                ),
            ],
          ),
        ),
        Flexible(
          child: Text(
            '${dataserie.temperature} ºC',
            style: TextStyle(
              fontSize: 22,
              color: dataserie.tempColor,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Dataserie? header = dataseries.firstOrNull;

    return Column(
      children: [
        if (header != null)
          FutureBuilder(
            future: _sunService.fetchSunData(location, date: header.dateTime),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black26,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                debugPrint('Error (Sun): ${snapshot.error}');
                return Center(
                  child: Text(
                    'Error obtenint dades (Sunrise / Sunset): ${header.dateTime.formatDate()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 20,
                    ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SunWidget(
                      data: snapshot.data!,
                      date: header.dateTime,
                      location: location,
                    ),
                  ),
                  for (Dataserie dataserie in dataseries)
                    _buildForecastRow(context, dataserie),
                ],
              );
            },
          ),
      ],
    );
  }
}
