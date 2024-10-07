import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Coordenades
typedef LatLng = ({double lat, double lon});

/// Servei per obtenir la localització de l'usuari
class LocationService {
  /// Obté la posició actual del dispositiu
  static Future<LatLng> getCurrentLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw LocationServiceDisabledException();
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Sol·licita permissos d'ubicació
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw LocationPermissionDeniedException(permission);
    }

    final Position position = await Geolocator.getCurrentPosition();

    return (lat: position.latitude, lon: position.longitude);
  }

  /// Comprova si té permissos d'ubicació
  static Future<bool> hasPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Obre la configuració del dispositiu per habilitar la localització
  static Future<void> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  /// Obre la configuració del dispositiu per habilitar els permissos
  static Future<void> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  //
  // Geocoding
  //

  /// Obté l'adreça més pròxima a partir d'unes coordenades
  static Future<Placemark> getAddress(
    final LatLng location, [
    String? locale,
  ]) async {
    if (!(await isPresent())) {
      throw GeocodingNotImplementedException();
    }

    if (locale != null) {
      await setGeocodingLocale(locale);
    }

    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.lat, location.lon);

    if (placemarks.isEmpty) {
      throw GeocodingPlacemarkNotFoundException();
    }

    return placemarks.first;
  }

  /// Especifica el locale dels resultats del servei de geocoding
  static Future<void> setGeocodingLocale(String locale) {
    return setLocaleIdentifier(locale);
  }
}

//
// Exceptions
//

/// Excepció base per les excepcions del servei de localització
abstract interface class LocationException implements Exception {
  String get message;

  @override
  String toString() => message;
}

/// Excepció: l'usuari no té la ubicació activada al dispositiu
class LocationServiceDisabledException extends LocationException {
  @override
  String get message => 'Location services are disabled';
}

/// Excepció: l'usuari ha denegat els permissos d'ubicació
class LocationPermissionDeniedException extends LocationException {
  final LocationPermission permission;

  LocationPermissionDeniedException(this.permission) {
    assert(permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever);
  }

  @override
  String get message {
    String message = 'Location permissions are denied';

    if (permission == LocationPermission.deniedForever) {
      message += ' (forever)';
    }

    return message;
  }
}

/// Excepció base per les excepcions del servei de geocoding
abstract interface class GeocodingException extends LocationException {}

/// Excepció: el dispositiu no té servei de geocoding
class GeocodingNotImplementedException extends GeocodingException {
  // El servei de Geocoding no està implementat en aquest dispositiu
  @override
  String get message => 'Geocoding service is not implemented on this device';
}

/// Excepció: no s'ha trobat una adreça apropiada
class GeocodingPlacemarkNotFoundException extends GeocodingException {
  // No s'ha pogut determinar l'adreça de la ubicació
  @override
  String get message => "Geocoding couldn't find a location address";
}
