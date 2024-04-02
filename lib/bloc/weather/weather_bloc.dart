import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:portfolio/constants/app_constants.dart';
import 'package:portfolio/repository/weather_repo.dart';
import 'package:portfolio/serializers/weather.dart';
import 'package:portfolio/utils/common_util.dart';
import 'package:http/http.dart' as http;

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  List<Weather>? allweathers;
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherEvent>(
      (event, emit) {},
    );
    on<WeatherEventFetch>(_fetchWeatherData);
    on<WeatherCityChange>(_weatherCityChange);
  }

  FutureOr<void> _fetchWeatherData(
    WeatherEventFetch event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherStateLoading());
    allweathers = await WeatherRepository().getWeather();
    if (allweathers != null && allweathers!.isNotEmpty) {
      emit(WeatherStateSuccess(
        weathers: allweathers!,
        selectedCity: cities[0].name,
      ));
    } else {
      emit(WeatherStateFailure());
    }
  }

  FutureOr<void> _weatherCityChange(
    WeatherCityChange event,
    Emitter<WeatherState> emit,
  ) {
    emit(WeatherStateLoading());

    emit(WeatherStateSuccess(
      weathers: allweathers!,
      selectedCity: event.city,
    ));
  }
}
