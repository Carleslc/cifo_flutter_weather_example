import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/location_service.dart';

class ForecastLocation extends StatelessWidget {
  final LatLng location;

  const ForecastLocation({super.key, required this.location});

  String get coordinates => '${location.lat}, ${location.lon}';

  String get mapsUrl =>
      'https://maps.google.com/maps?q=${location.lat},${location.lon}';

  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).toLanguageTag();

    return FutureBuilder(
      future: LocationService.getAddress(location, locale),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Tooltip(
            message: coordinates,
            child: const SizedBox(height: 32),
          );
        }
        String? locationName;

        if (snapshot.hasData) {
          final placemark = snapshot.data;
          locationName = placemark?.locality ?? placemark?.administrativeArea;
        } else if (snapshot.hasError) {
          final Object error = snapshot.error!;
          debugPrint('Error [${error.runtimeType}]: $error');
        }

        locationName ??= coordinates;

        return Tooltip(
          message: coordinates,
          showDuration: const Duration(seconds: 30),
          child: GestureDetector(
            onTap: () => launchUrl(Uri.parse(mapsUrl)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                locationName,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
