import 'package:flutter/material.dart';

import '../main.dart';
import '../services/location_service.dart';
import '../widgets/error_message.dart';
import '../widgets/forecast_list.dart';
import '../widgets/forecast_location.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  /// Ubicació d'on mostrar la meteorologia
  Future<LatLng>? _location;

  @override
  void initState() {
    super.initState();
    _checkLocationPermissions();
  }

  /// Comprova si té permissos i si no els té mostra un missatge d'ús
  void _checkLocationPermissions() {
    // Mostra el diàleg quan hagi terminat el build actual
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool permissionsEnabled = await LocationService.hasPermissions();

      if (!permissionsEnabled && mounted) {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Permissos d'ubicació"),
              content: const Text(
                'Per obtenir la previsió meteorològica de la teva ubicació '
                "has d'acceptar els permissos de localització.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // tanca el diàleg
                  },
                  child: const Text('Continuar'),
                ),
              ],
            );
          },
        );
      }
      // Intenta obtenir la ubicació actual
      _setCurrentLocation();
    });
  }

  void _setCurrentLocation() {
    setState(() {
      _location = LocationService.getCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(WeatherApp.title),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: _location != null
          ? _forecastCurrentLocation()
          : const SizedBox.shrink(),
    );
  }

  /// Mostra la previsió meteorològica de la ubicació actual
  Widget _forecastCurrentLocation() {
    return FutureBuilder(
      future: _location,
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
                  'Obtenint ubicació...',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          Object error = snapshot.error!;

          debugPrint('Error [${error.runtimeType}]: $error');

          String message;
          Widget? settings;

          if (snapshot.error is LocationServiceDisabledException) {
            message = 'La ubicació està desactivada';
            settings = FilledButton(
              onPressed: () async {
                await LocationService.openLocationSettings();
                _setCurrentLocation();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.secondary),
              ),
              child: const Text('Activa la ubicació'),
            );
          } else if (snapshot.error is LocationPermissionDeniedException) {
            message = "S'han denegat els permissos d'ubicació";
            settings = FilledButton(
              onPressed: () async {
                await LocationService.openAppSettings();
                _setCurrentLocation();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.secondary),
              ),
              child: const Text('Habilita els permissos'),
            );
          } else {
            message = 'Error obtenint la ubicació';
            if (error is LocationException) {
              message += ': ${error.message}';
            }
          }

          return ErrorMessage(message: message, child: settings);
        }

        final LatLng location = snapshot.data!;

        debugPrint('Location: ${location.toString()}');

        // Mostra la previsió meteorològica per la ubicació actual
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ForecastLocation(location: location),
            Expanded(child: ForecastList(location: location)),
          ],
        );
      },
    );
  }
}
