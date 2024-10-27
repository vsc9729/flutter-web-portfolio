import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:portfolio/constants/app_constants.dart';
import 'package:portfolio/serializers/weather.dart';
import 'package:portfolio/utils/common_util.dart';
import 'package:http/http.dart' as http;

class WeatherRepository {
  Future<List<Weather>?> getWeather() async {
    try {
      List<Response> responses = await Future.wait(
        cities.map(
          (e) => http.get(
            Uri.parse(
              CommonUtil.getWeatherEndpoint(e.lat, e.long),
            ),
          ),
        ),
      );
      List<Weather> weathers = responses
          .map(
            (e) => Weather.fromJson(
              jsonDecode(
                e.body,
              ),
            ),
          )
          .toList();
      cities.asMap().forEach(
        (index, element) {
          weathers[index].city = element.name;
        },
      );
      return weathers;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
