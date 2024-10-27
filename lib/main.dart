import 'imports.dart';

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
              title: AppStrings.name,
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
