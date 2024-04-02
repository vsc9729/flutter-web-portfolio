part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {}

final class WeatherInitial extends WeatherState {}

class WeatherStateLoading extends WeatherState {}

class WeatherStateSuccess extends WeatherState {
  final List<Weather> weathers;
  final String selectedCity;

  WeatherStateSuccess({
    required this.weathers,
    required this.selectedCity,
  });
}

class WeatherStateFailure extends WeatherState {}
