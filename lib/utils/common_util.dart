import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommonUtil {
  static String getWeatherEndpoint(String lat, String long) {
    String key = dotenv.env['OPEN_WEATHER_API_KEY'] ?? "";
    String openWeatherApiBaseUrl =
        'https://api.openweathermap.org/data/2.5/weather';
    return '$openWeatherApiBaseUrl?lat=$lat&lon=$long&appid=$key';
  }
}
