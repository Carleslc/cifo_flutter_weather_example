import 'dart:convert';

// Code generated with: https://app.quicktype.io/ (modified)
/// To parse this JSON data: `SunriseSunset.fromJsonString(jsonString)`
class SunriseSunset {
  final Results results;
  final String status;
  final String tzid;

  SunriseSunset({
    required this.results,
    required this.status,
    required this.tzid,
  });

  factory SunriseSunset.fromJsonString(String jsonString) =>
      SunriseSunset.fromJson(json.decode(jsonString));

  factory SunriseSunset.fromJson(Map<String, dynamic> json) => SunriseSunset(
        results: Results.fromJson(json['results']),
        status: json['status'],
        tzid: json['tzid'],
      );

  Map<String, dynamic> toJson() => {
        'results': results.toJson(),
        'status': status,
        'tzid': tzid,
      };

  String toJsonString() => json.encode(toJson());
}

class Results {
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime solarNoon;
  final int dayLength;
  final DateTime civilTwilightBegin;
  final DateTime civilTwilightEnd;
  final DateTime nauticalTwilightBegin;
  final DateTime nauticalTwilightEnd;
  final DateTime astronomicalTwilightBegin;
  final DateTime astronomicalTwilightEnd;

  Results({
    required this.sunrise,
    required this.sunset,
    required this.solarNoon,
    required this.dayLength,
    required this.civilTwilightBegin,
    required this.civilTwilightEnd,
    required this.nauticalTwilightBegin,
    required this.nauticalTwilightEnd,
    required this.astronomicalTwilightBegin,
    required this.astronomicalTwilightEnd,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        sunrise: DateTime.parse(json['sunrise']),
        sunset: DateTime.parse(json['sunset']),
        solarNoon: DateTime.parse(json['solar_noon']),
        dayLength: json['day_length'],
        civilTwilightBegin: DateTime.parse(json['civil_twilight_begin']),
        civilTwilightEnd: DateTime.parse(json['civil_twilight_end']),
        nauticalTwilightBegin: DateTime.parse(json['nautical_twilight_begin']),
        nauticalTwilightEnd: DateTime.parse(json['nautical_twilight_end']),
        astronomicalTwilightBegin:
            DateTime.parse(json['astronomical_twilight_begin']),
        astronomicalTwilightEnd:
            DateTime.parse(json['astronomical_twilight_end']),
      );

  Map<String, dynamic> toJson() => {
        'sunrise': sunrise.toIso8601String(),
        'sunset': sunset.toIso8601String(),
        'solar_noon': solarNoon.toIso8601String(),
        'day_length': dayLength,
        'civil_twilight_begin': civilTwilightBegin.toIso8601String(),
        'civil_twilight_end': civilTwilightEnd.toIso8601String(),
        'nautical_twilight_begin': nauticalTwilightBegin.toIso8601String(),
        'nautical_twilight_end': nauticalTwilightEnd.toIso8601String(),
        'astronomical_twilight_begin':
            astronomicalTwilightBegin.toIso8601String(),
        'astronomical_twilight_end': astronomicalTwilightEnd.toIso8601String(),
      };
}
