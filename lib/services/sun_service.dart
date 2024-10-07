import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/sunrise_sunset.dart';
import '../utils/date_utils.dart';
import 'location_service.dart';

/// Servei per obtenir les hores de sortida i posta de sol
class SunService {
  // https://sunrise-sunset.org/api
  static const apiUrl = 'https://api.sunrise-sunset.org/json';

  /// Format de les dates que s'envien a la API
  static final format = DateFormat('yyyy-MM-dd');

  // Singleton per controlar una única caché
  static final SunService _instance = SunService._();
  factory SunService() => _instance;
  SunService._();

  /// Guarda les dades per una ubicació i data determinades
  final Map<String, SunriseSunset> _cache = {};

  static String _key(LatLng location, DateTime date) =>
      '${location.lat},${location.lon}-${date.toIso8601String()}';

  Future<SunriseSunset> fetchSunData(
    final LatLng location, {
    required DateTime date,
  }) async {
    final String key = _key(location, date);

    // Comprova si està a la caché
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    final url = Uri.parse(apiUrl).replace(queryParameters: {
      'lat': location.lat.toString(),
      'lng': location.lon.toString(),
      'date': date.format(format),
      'tzid': 'UTC',
      'formatted': '0',
    });

    debugPrint(url.toString());

    http.Response data = await http.get(url);

    SunriseSunset sun = SunriseSunset.fromJsonString(data.body);

    if (sun.status != 'OK') {
      throw HttpException(sun.status, uri: url);
    }

    // Actualitza la caché
    _cache[key] = sun;

    return sun;
  }
}
