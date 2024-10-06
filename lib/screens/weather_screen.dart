import 'package:flutter/material.dart';

import '../main.dart';
import '../services/location_service.dart';
import '../widgets/forecast_list.dart';
import '../widgets/sun_widget.dart';

class WeatherScreen extends StatefulWidget {
  final LatLng location;

  const WeatherScreen({super.key, required this.location});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(WeatherApp.title),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: ForecastList(location: widget.location)),
        ],
      ),
    );
  }
}
