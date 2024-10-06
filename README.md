# weather_example

**Repositori d'aplicacions: [cifo_flutter](https://github.com/Carleslc/cifo_flutter)**

Aplicació d'exemple per aprendre a utilitzar APIs externes amb Flutter.

S'utilitza l'API [7timer](https://github.com/Yeqzids/7timer-issues/wiki/Wiki) per obtenir informació meteorològica.

La previsió meteorològica per les pròximes hores i dies es mostra en una llista amb diferents icones utilitzant la llibreria [`weather_icons`](https://pub.dev/packages/weather_icons).

Per cada dia es mostra també la sortida i posta de sol, utilitzant l'API [Sunrise Sunset](https://sunrise-sunset.org/api).

La ubicació de la previsió és fixa utilitzant coordenades latitud i longitud (constant `location` a `lib/services/location_service.dart`).

Codi original: [https://github.com/poqueque/cifo_2024s2_app_weather/](https://github.com/poqueque/cifo_2024s2_app_weather/)

<a href="https://idx.google.com/import?url=https%3A%2F%2Fgithub.com%2FCarleslc%2Fcifo_flutter_weather_example%2F" target="_blank">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://cdn.idx.dev/btn/open_dark_32.svg">
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://cdn.idx.dev/btn/open_light_32.svg">
    <img
      height="32"
      alt="Open in IDX"
      src="https://cdn.idx.dev/btn/open_purple_32.svg">
  </picture>
</a>

## Instal·lació

1. S'ha d'haver instal·lat el [Flutter SDK](https://docs.flutter.dev/get-started/install).

2. Clonar el repositori:

```sh
git pull https://github.com/Carleslc/cifo_flutter_weather_example.git
# GitHub CLI: gh repo clone Carleslc/cifo_flutter_weather_example

cd cifo_flutter_weather_example
```

3. Instal·lar les dependències:

```sh
flutter pub get
```

4. Executar l'aplicació amb `flutter run` o desde l'IDE.

## Estructura de l'aplicació

```
lib
├── main.dart
├── models
│   ├── meteo.dart
│   ├── sunrise_sunset.dart
│   └── weather.dart
├── screens
│   └── weather_screen.dart
├── services
│   ├── location_service.dart
│   ├── sun_service.dart
│   └── weather_service.dart
├── utils
│   └── date_utils.dart
└── widgets
    ├── forecast_day.dart
    ├── forecast_list.dart
    └── sun_widget.dart
```

L'inici de l'aplicació és a `main.dart`, a `models` hi ha els models de dades com las clases `Meteo` i `SunriseSunset` que s'ha generat amb l'ajuda de la web [quicktype](https://app.quicktype.io/), a `screens` està el codi de la pantalla `WeatherList`, a `services` hi ha els serveis que obtenen les dades de les APIs externes (`WeatherService` i `SunService`) i a `widgets` es troben els widgets propis que no corresponen a una pantalla determinada, com `ForecastList` que obté les dades meteorològiques i mostra la llista de dies utilitzant el widget `ForecastDay`, que obté les dades de la sortida i posta de sol (`SunWidget`) i mostra la previsió de les hores del dia corresponent.

## Imatges

![weather_example.png](<./images/weather_example.png>)

## Recursos

- [Quicktype](https://app.quicktype.io/)
- [7timer API](https://github.com/Yeqzids/7timer-issues/wiki/Wiki)
- [7timer Web](https://www.7timer.info/index.php?product=civil&lat=41.359&lon=2.099&unit=metric)
- [Weather Icons](https://erikflowers.github.io/weather-icons/) ([`weather_icons`](https://pub.dev/packages/weather_icons))
- [Sunrise Sunset API](https://sunrise-sunset.org/api)

### Docs

- [Networking](https://docs.flutter.dev/data-and-backend/networking)
- [JSON Serialization](https://docs.flutter.dev/data-and-backend/serialization/json)
- [Internationalization](https://flutter.dev/to/internationalization/)

### Llibreries externes

- [http](https://pub.dev/packages/http)
- [intl](https://pub.dev/packages/intl)
- [convert](https://pub.dev/packages/convert)
- [weather_icons](https://pub.dev/packages/weather_icons)
