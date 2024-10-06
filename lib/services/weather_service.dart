import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/meteo.dart';
import 'location_service.dart';

class WeatherService {
  // https://github.com/Yeqzids/7timer-issues/wiki/Wiki
  static const apiUrl = 'https://www.7timer.info/bin/civil.php';

  Future<Meteo> fetchWeatherData(final LatLng location) async {
    final url = Uri.parse(apiUrl).replace(queryParameters: {
      'lat': location.lat.toString(),
      'lon': location.lon.toString(),
      'unit': 'metric',
      'output': 'json',
      'product': 'civil',
    });

    debugPrint(url.toString());

    http.Response data = await http.get(url);

    Meteo meteo = Meteo.fromJsonString(data.body);

    debugPrint('init: ${meteo.initDateTime}');

    return meteo;
  }
}
