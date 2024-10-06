import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';

import '../utils/date_utils.dart';
import 'weather.dart';

// Code generated with: https://app.quicktype.io/ (modified)
/// To parse this JSON data: `Meteo.fromJsonString(jsonString)`
class Meteo {
  final String product;
  final String init;
  late final List<Dataserie> dataseries;

  final DateTime initDateTime;

  Meteo({
    required this.product,
    required this.init, // 2024100512
    required List<dynamic> dataseriesJson,
  }) : initDateTime = DateUtilsFormatter.toDateTimeMeteo(init) {
    dataseries = List<Dataserie>.from(
      dataseriesJson.map((x) => Dataserie.fromJson(this, x)),
    )..sort((d1, d2) => d1.dateTime.compareTo(d2.dateTime));
  }

  factory Meteo.fromJson(Map<String, dynamic> json) => Meteo(
        product: json['product'],
        init: json['init'],
        dataseriesJson: json['dataseries'],
      );

  factory Meteo.fromJsonString(String jsonString) =>
      Meteo.fromJson(json.decode(jsonString));

  Map<String, dynamic> toJson() => {
        'product': product,
        'init': init,
        'dataseries': List<dynamic>.from(dataseries.map((x) => x.toJson())),
      };

  String toJsonString() => json.encode(toJson());
}

// https://github.com/Yeqzids/7timer-issues/wiki/Wiki#civil-and-civil-light
class Dataserie {
  final int timepoint;
  final int cloudcover;
  final int liftedIndex;
  final String precType;
  final int precAmount;
  final int temperature;
  final int? humidity;
  final Wind wind;
  final String weather;

  late final WeatherIcon icon;
  late final WeatherAlert? alert;

  final DateTime dateTime;

  Dataserie({
    required DateTime initDateTime,
    required this.timepoint,
    required this.cloudcover,
    required this.liftedIndex,
    required String precType,
    required this.precAmount,
    required this.temperature,
    required this.wind,
    required this.weather,
    required String humidity,
  })  : precType = precType == 'rain' && precAmount == 0 ? 'none' : precType,
        humidity = int.tryParse(humidity.split('%').first),
        dateTime = initDateTime.add(Duration(hours: timepoint)) {
    icon = _icon();
    alert = _alert();
  }

  String _label(String label) {
    if (precAmount > 1) {
      label += ' ($precipitation)';
    }
    if (wind.speed >= 3) {
      label += '\n${wind.label}';
    }
    return label;
  }

  bool get day => weather.endsWith('day');

  Color? get tempColor {
    if (temperature <= -10) {
      return Colors.blueAccent.shade700;
    }
    if (temperature <= 0) {
      return Colors.blueAccent;
    }
    if (temperature < 10) {
      return Colors.lightBlueAccent.shade700;
    }
    if (temperature >= 50) {
      return Colors.redAccent.shade700;
    }
    if (temperature >= 40) {
      return Colors.deepOrangeAccent.shade700;
    }
    if (temperature >= 30) {
      return Colors.orange.shade700;
    }
    return null; // default
  }

  WeatherIcon _icon() {
    bool windy = wind.speed >= 3; // > 12 km/h
    bool cloudy = cloudcover >= 7; // >= 69%
    bool thunder = liftedIndex <= -6; // <= -5
    bool lowRain = precAmount < 4;

    IconData cloudyDayNight(
      IconData cloudyIcon,
      IconData dayIcon,
      IconData nightIcon,
    ) {
      if (cloudy) return cloudyIcon;
      return day ? dayIcon : nightIcon;
    }

    if (thunder) {
      if (lowRain) {
        return WeatherIcon(
          _label('Tormenta eléctrica'),
          cloudyDayNight(
            WeatherIcons.lightning,
            WeatherIcons.day_lightning,
            WeatherIcons.night_alt_lightning,
          ),
        );
      } else {
        switch (precType) {
          case 'snow':
            return WeatherIcon(
              _label(
                  precAmount > 4 ? 'Tormenta de nieve' : 'Tormenta con nieve'),
              cloudyDayNight(
                WeatherIcons.storm_showers,
                WeatherIcons.day_snow_thunderstorm,
                WeatherIcons.night_alt_snow_thunderstorm,
              ),
            );
          case 'rain':
            return WeatherIcon(
              _label(precAmount <= 6 ? 'Tormenta' : 'Tormenta intensa'),
              precAmount <= 4
                  ? cloudyDayNight(
                      WeatherIcons.storm_showers,
                      WeatherIcons.day_storm_showers,
                      WeatherIcons.night_alt_storm_showers,
                    )
                  : cloudyDayNight(
                      WeatherIcons.thunderstorm,
                      WeatherIcons.day_thunderstorm,
                      WeatherIcons.night_alt_thunderstorm,
                    ),
            );
          case 'frzr':
            bool mediumRain = precAmount == 4;
            return WeatherIcon(
              _label(mediumRain
                  ? 'Tormenta con aguanieve'
                  : 'Tormenta con lluvia helada'),
              cloudyDayNight(
                mediumRain
                    ? WeatherIcons.storm_showers
                    : WeatherIcons.thunderstorm,
                WeatherIcons.day_sleet_storm,
                WeatherIcons.night_alt_sleet_storm,
              ),
            );
          case 'icep':
            if (precAmount <= 4) {
              return WeatherIcon(
                _label('Tormenta con algo de granizo'),
                cloudyDayNight(
                  WeatherIcons.storm_showers,
                  WeatherIcons.day_snow_thunderstorm,
                  WeatherIcons.night_snow_thunderstorm,
                ),
                windy,
                cloudyDayNight(
                  WeatherIcons.storm_showers,
                  WeatherIcons.day_sleet_storm,
                  WeatherIcons.night_sleet_storm,
                ),
              );
            }
            return WeatherIcon(
                _label('Tormenta con granizo'), WeatherIcons.snowflake_cold);
        }
      }
    }

    switch (precType) {
      case 'snow':
        return WeatherIcon(
          _label('Nieve'),
          cloudyDayNight(
            WeatherIcons.snow,
            WeatherIcons.day_snow,
            WeatherIcons.night_alt_snow,
          ),
          windy,
          cloudyDayNight(
            WeatherIcons.snow_wind,
            WeatherIcons.day_snow_wind,
            WeatherIcons.night_alt_snow_wind,
          ),
        );
      case 'rain':
        if (lowRain) {
          return WeatherIcon(
            _label('Llovizna'),
            cloudyDayNight(
              WeatherIcons.sprinkle,
              WeatherIcons.day_sprinkle,
              WeatherIcons.night_alt_sprinkle,
            ),
            windy,
            cloudyDayNight(
              WeatherIcons.sleet,
              WeatherIcons.day_sleet,
              WeatherIcons.night_alt_sleet,
            ),
          );
        }
        return WeatherIcon(
          _label(precAmount <= 6 ? 'Lluvia' : 'Lluvia fuerte'),
          precAmount <= 4
              ? cloudyDayNight(
                  WeatherIcons.showers,
                  WeatherIcons.day_showers,
                  WeatherIcons.night_alt_showers,
                )
              : cloudyDayNight(
                  WeatherIcons.rain,
                  WeatherIcons.day_rain,
                  WeatherIcons.night_alt_rain,
                ),
          wind.speed >= 4, // 29 km/h
          cloudyDayNight(
            WeatherIcons.rain_wind,
            WeatherIcons.day_rain_wind,
            WeatherIcons.night_alt_rain_wind,
          ),
        );
      case 'frzr':
        if (precAmount <= 4) {
          return WeatherIcon(
            _label('Aguanieve'),
            cloudyDayNight(
              WeatherIcons.sleet,
              WeatherIcons.day_sleet,
              WeatherIcons.night_alt_sleet,
            ),
            windy,
            cloudyDayNight(
              WeatherIcons.rain_mix,
              WeatherIcons.day_rain_mix,
              WeatherIcons.night_alt_rain_mix,
            ),
          );
        }
        return WeatherIcon(
          _label('Lluvia helada'),
          cloudyDayNight(
            WeatherIcons.rain_mix,
            WeatherIcons.day_rain_mix,
            WeatherIcons.night_alt_rain_mix,
          ),
          windy,
          cloudyDayNight(
            WeatherIcons.rain_wind,
            WeatherIcons.day_rain_wind,
            WeatherIcons.night_alt_rain_wind,
          ),
        );
      case 'icep':
        if (precAmount <= 4) {
          return WeatherIcon(
            _label('Granizo ligero'),
            cloudyDayNight(
              WeatherIcons.hail,
              WeatherIcons.day_hail,
              WeatherIcons.night_alt_hail,
            ),
            windy,
            cloudyDayNight(
              WeatherIcons.rain_wind,
              WeatherIcons.day_rain_wind,
              WeatherIcons.night_alt_rain_wind,
            ),
          );
        }
        return WeatherIcon(_label('Granizo'), WeatherIcons.snowflake_cold);
      case 'none':
        if (cloudcover <= 2) {
          // < 20%
          return WeatherIcon(
            _label(day ? 'Soleado' : 'Despejado'),
            day
                ? (temperature >= 40
                    ? WeatherIcons.hot
                    : WeatherIcons.day_sunny)
                : WeatherIcons.stars,
            windy,
            day
                ? (wind.speed >= 4
                    ? WeatherIcons.day_windy
                    : WeatherIcons.day_light_wind)
                : WeatherIcons.night_clear,
          );
        }
        if (cloudcover <= 3) {
          // < 31%
          return WeatherIcon(
            _label('Pocas nubes'),
            day
                ? WeatherIcons.day_sunny_overcast
                : WeatherIcons.night_alt_partly_cloudy,
            windy,
            day ? WeatherIcons.day_haze : WeatherIcons.night_alt_partly_cloudy,
          );
        }
        if (cloudcover <= 6) {
          // < 69%
          return WeatherIcon(
            _label(cloudcover <= 5
                ? 'Algunas nubes'
                : 'Nuboso'), // 31 - 56% : 56 - 69%
            day ? WeatherIcons.day_cloudy : WeatherIcons.night_alt_cloudy,
            windy,
            wind.speed >= 4
                ? (day
                    ? WeatherIcons.day_cloudy_gusts
                    : WeatherIcons.night_alt_cloudy_gusts)
                : (day
                    ? WeatherIcons.day_cloudy_windy
                    : WeatherIcons.night_alt_cloudy_windy),
          );
        }
        if (cloudcover <= 7) {
          // < 81%
          return WeatherIcon(
            _label('Nuboso'),
            WeatherIcons.cloud,
            windy,
            wind.speed >= 4
                ? WeatherIcons.cloudy_gusts
                : WeatherIcons.cloudy_windy,
          );
        }
        // >= 81%
        return WeatherIcon(
          _label('Nublado'),
          WeatherIcons.cloudy,
          wind.speed >= 4,
          WeatherIcons.cloudy_gusts,
        );
    }

    debugPrint('Icon not found (+${timepoint}h, $weather, prec: $precType)');
    return WeatherIcon('?', WeatherIcons.alien);
  }

  String get precipitation {
    switch (precAmount) {
      case 1:
        return '< 0.25 mm/hr';
      case 2:
        return '< 1 mm/hr';
      case 3:
        return '1-4 mm/hr';
      case 4:
        return '4-10 mm/hr';
      case 5:
        return '10-16 mm/hr';
      case 6:
        return '16-30 mm/hr';
      case 7:
        return '30-50 mm/hr';
      case 8:
        return '50-75 mm/hr';
      case 9:
        return '> 75 mm/hr';
      default:
        return 'Sin lluvia';
    }
  }

  WeatherAlert? _alert() {
    if (wind.speed == 8) {
      return WeatherAlert(
          wind.label, WeatherIcons.hurricane_warning, AlertPriority.high);
    } else if (wind.speed == 7) {
      return WeatherAlert(
          wind.label, WeatherIcons.gale_warning, AlertPriority.high);
    } else if (wind.speed == 6) {
      return WeatherAlert(
          wind.label, WeatherIcons.small_craft_advisory, AlertPriority.medium);
    } else if (wind.speed == 5) {
      return WeatherAlert(
        wind.label,
        WeatherIcons.strong_wind,
        AlertPriority.low,
      );
    } else if (wind.speed == 4) {
      return WeatherAlert(
        wind.label,
        WeatherIcons.windy,
        AlertPriority.low,
      );
    }
    if (liftedIndex < -6) {
      return const WeatherAlert(
          'Carga eléctrica muy alta', WeatherIcons.lightning);
    }
    if (humidity != null && humidity! > 90) {
      return WeatherAlert('Humedad elevada ($humidity%)', WeatherIcons.humidity,
          AlertPriority.low);
    }
    return null; // no alert
  }

  factory Dataserie.fromJson(Meteo meteo, Map<String, dynamic> json) =>
      Dataserie(
        initDateTime: meteo.initDateTime,
        timepoint: json['timepoint'],
        cloudcover: json['cloudcover'],
        liftedIndex: json['lifted_index'],
        precType: json['prec_type'],
        precAmount: json['prec_amount'],
        temperature: json['temp2m'],
        humidity: json['rh2m'],
        wind: Wind.fromJson(json['wind10m']),
        weather: json['weather'],
      );

  Map<String, dynamic> toJson() => {
        'timepoint': timepoint,
        'cloudcover': cloudcover,
        'lifted_index': liftedIndex,
        'prec_type': precType,
        'prec_amount': precAmount,
        'temp2m': temperature,
        'rh2m': humidity,
        'wind10m': wind.toJson(),
        'weather': weather,
      };
}

class Wind {
  final String direction;
  final int speed;

  Wind({
    required this.direction,
    required this.speed,
  });

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
        direction: json['direction'],
        speed: json['speed'],
      );

  Map<String, dynamic> toJson() => {
        'direction': direction,
        'speed': speed,
      };

  // https://www.pce-iberica.es/medidor-detalles-tecnicos/tablas-de-velocidades-del-viento.htm
  String get label {
    switch (speed) {
      case 1:
        return 'Viento en calma';
      case 2:
        return 'Viento suave (< 12 km/h)';
      case 3:
        return 'Viento moderado (12 - 29 km/h)';
      case 4:
        return 'Viento vivo (30 - 40 km/h)';
      case 5:
        return 'Viento fuerte (40 - 60 km/h)';
      case 6:
        return 'Viento muy fuerte (> 60 km/h)';
      case 7:
        return 'Viento extremo (> 88 km/h)';
      case 8:
        return 'Huracán (> 117 km/h)';
      default:
        return '';
    }
  }
}
