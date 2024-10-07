import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/weather_screen.dart';
import 'utils/date_utils.dart';

void main() async {
  // Inicialitza la localització
  await DateUtilsFormatter.init(Platform.localeName);

  // Carrega l'aplicació
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  static const String title = 'Weather App';

  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const WeatherScreen(),
      // Localització d'idioma
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('en'), Locale('es'), Locale('ca')],
    );
  }
}
