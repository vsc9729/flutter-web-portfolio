part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent {}

class WeatherEventFetch extends WeatherEvent {}

class WeatherCityChange extends WeatherEvent {
  final String city;

  WeatherCityChange({
    required this.city,
  });
}
