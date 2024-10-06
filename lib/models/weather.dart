import 'package:flutter/material.dart';

class WeatherIcon {
  final String label;
  final IconData icon;

  WeatherIcon(
    this.label,
    IconData icon, [
    bool windy = false,
    IconData? iconWindy,
  ]) : icon = windy ? (iconWindy ?? icon) : icon;
}

class WeatherAlert {
  final String label;
  final IconData icon;
  final AlertPriority priority;

  const WeatherAlert(
    this.label,
    this.icon, [
    this.priority = AlertPriority.medium,
  ]);

  Color get color {
    switch (priority) {
      case AlertPriority.low:
        return Colors.amber.shade400;
      case AlertPriority.medium:
        return Colors.orange.shade600;
      case AlertPriority.high:
        return Colors.red;
    }
  }
}

enum AlertPriority {
  low,
  medium,
  high;
}
