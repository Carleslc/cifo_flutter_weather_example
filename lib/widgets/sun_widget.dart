import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

import '../models/sunrise_sunset.dart';
import '../services/location_service.dart';
import '../utils/date_utils.dart';

class SunWidget extends StatelessWidget {
  final SunriseSunset data;
  final DateTime date;
  final LatLng location;

  const SunWidget({
    super.key,
    required this.data,
    required this.date,
    required this.location,
  });

  Text _time(DateTime dt) {
    return Text(
      dt.toLocal().formatTime(),
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    Results sun = data.results;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            date.toLocal().formatDate(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Row(
          children: [
            const Icon(
              WeatherIcons.sunrise,
              size: 32,
              color: Colors.orange,
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                _time(sun.civilTwilightBegin),
                _time(sun.sunrise),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              WeatherIcons.sunset,
              size: 32,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                _time(sun.sunset),
                _time(sun.civilTwilightEnd),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
