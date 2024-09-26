import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:portfolio/bloc/series_game/series_game_bloc.dart';
import 'package:portfolio/bloc/theme/theme_bloc.dart';
import 'package:portfolio/bloc/weather/weather_bloc.dart';
import 'package:portfolio/screens/home/home.dart';
import 'package:portfolio/services/local_storage/local_storage.dart';
import 'package:portfolio/theme/index.dart';

var keyOne = GlobalKey<NavigatorState>();
var keyTwo = GlobalKey<NavigatorState>();
void main() async {
  await dotenv.load(fileName: "dotenv");
  await MyLocalStorage.init();
  runApp(const MyApp());
}

bool isFirstTime = true;
ThemeState? appThemeState;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(),
          ),
          BlocProvider<WeatherBloc>(
            create: (context) => WeatherBloc(),
          ),
          BlocProvider<SeriesGameBloc>(
            create: (context) => SeriesGameBloc(),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, appThemeState) {
            appThemeState = appThemeState;
            return MaterialApp(
              title: 'Vikrant Singh',
              navigatorKey: keyOne,
              debugShowCheckedModeBanner: false,
              theme: appThemeState is DarkTheme
                  ? AppThemes.darkTheme
                  : AppThemes.lightTheme,
              home: const MyHomePage(),
            ).animate().fadeIn(delay: const Duration(milliseconds: 400));
          },
        ),
      ),
    );
  }
}
