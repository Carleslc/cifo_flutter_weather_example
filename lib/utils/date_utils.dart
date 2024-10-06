import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

extension DateUtilsFormatter on DateTime {
  // https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateFormat = DateFormat.MMMEd();

  /// Inicialitza els formats de data i hora amb un locale determinat
  static Future<void> init([String? locale]) async {
    Intl.defaultLocale = locale;
    debugPrint('Locale: $locale');
    await initializeDateFormatting(locale);
  }

  /// Formateig de l'hora
  ///
  /// `HH:mm` 06:00, 18:20
  String formatTime() => _timeFormat.format(this);

  /// Formateig de la data
  ///
  /// `MMMEd` localized format\
  /// es: `EEE, d MMM` sáb, 5 oct
  String formatDate() => _dateFormat.format(this);

  /// Formateid de data / hora
  ///
  /// Utilitza el `format` especificat, o ISO8601 per defecte (UTC)
  String format([DateFormat? format]) {
    DateTime utc = toUtc();
    return format?.format(utc) ?? utc.toIso8601String();
  }

  // https://pub.dev/documentation/convert/latest/convert/FixedDateTimeFormatter-class.html
  // https://github.com/dart-lang/convert/issues/70
  static final FixedDateTimeFormatter _meteoFormat =
      FixedDateTimeFormatter('YYYYMMDDhhmmss');

  /// Converteix un String amb format `YYYYMMDDhhmmss` (UTC) a DateTime (local)
  static DateTime toDateTimeMeteo(String dt) => _meteoFormat
      .decode(dt.padRight(_meteoFormat.pattern.length, '0'))
      .toLocal();
}
