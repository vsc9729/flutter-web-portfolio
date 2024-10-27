import 'package:portfolio/imports.dart';

class WeatherWidget extends StatelessWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        if (state is WeatherStateSuccess) {
          Weather selectedWeather = state.weathers.firstWhere(
            (element) => element.city == state.selectedCity,
          );

          return BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return Container(
                  height: 75,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  decoration: BoxDecoration(
                    color: state is DarkTheme
                        ? const Color(0xff292929)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: NetworkImage(
                          "https://openweathermap.org/img/wn/${selectedWeather.iconId}.png",
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "${(selectedWeather.temp! - 273.15).floor()}°",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .color!
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ));
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xffc97dbd),
          ),
        );
      },
    );
  }
}