import 'package:portfolio/imports.dart';

class CommonUtil {
  static String getWeatherEndpoint(String lat, String long) {
    String key = dotenv.env['OPEN_WEATHER_API_KEY'] ?? "";
    String openWeatherApiBaseUrl = AppStrings.weatherURl;
    return '$openWeatherApiBaseUrl?lat=$lat&lon=$long&appid=$key';
  }

  static double scaleText(double fontSize, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width < 480) {
      return fontSize * 1.45;
    } else if (width < 720) {
      return fontSize * 1;
    } else if (width < 1080) {
      return fontSize * 0.85;
    } else if (width < 1440) {
      return fontSize * 0.65;
    } else if (width < 1920) {
      return fontSize * 0.60;
    } else {
      return fontSize * 0.45;
    }
  }

  static double deviceBasedValues(
      BuildContext context, double landscape, double portrait) {
    return MediaQuery.of(context).orientation == Orientation.landscape
        ? landscape
        : portrait;
  }
}
