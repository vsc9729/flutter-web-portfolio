import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:portfolio/bloc/series_game/series_game_bloc.dart';
import 'package:portfolio/bloc/theme/theme_bloc.dart';
import 'package:portfolio/bloc/weather/weather_bloc.dart';
import 'package:portfolio/constants/common_assets.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/serializers/series_info.dart';
import 'package:portfolio/serializers/weather.dart';
import 'package:portfolio/services/local_storage/local_storage.dart';
import 'package:portfolio/utils/app_scroll_behaviour.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class MobileWidget extends StatefulWidget {
  const MobileWidget({
    super.key,
    required this.pageController,
  });
  final PageController pageController;

  @override
  State<MobileWidget> createState() => _MobileWidgetState();
}

class _MobileWidgetState extends State<MobileWidget>
    with TickerProviderStateMixin {
  late AnimationController transitionControllerLeft;
  late AnimationController opacityController;

  ValueNotifier<double> animationValue = ValueNotifier(-500);

  @override
  void initState() {
    transitionControllerLeft = AnimationController(
      duration: const Duration(milliseconds: 1300),
      lowerBound: -500,
      upperBound: 0,
      vsync: this,
    )..forward();

    opacityController = AnimationController(
      duration: const Duration(milliseconds: 1300),
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
    )..forward();

    transitionControllerLeft.addListener(() {
      if (isFirstTime) {
        animationValue.value = transitionControllerLeft.value;
      }
    });
    widget.pageController.addListener(() {
      if (widget.pageController.page! <= 1) {
        if (!isFirstTime) {
          animationValue.value = widget.pageController.page! * -500;
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    transitionControllerLeft.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
            valueListenable: animationValue,
            builder: (context, value, child) {
              double opacityValue = 1 - ((animationValue.value / -300));
              return Stack(
                children: [
                  Positioned.fill(
                    child: Center(
                      child: AnimatedBuilder(
                        animation: transitionControllerLeft,
                        builder: (context, child) {
                          return AnimatedBuilder(
                            animation: opacityController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: isFirstTime
                                    ? opacityController.value
                                    : 1 - (animationValue.value / -500),
                                child: child,
                              );
                            },
                            child: Transform(
                              transform: Matrix4.identity()
                                ..translate(
                                    (-(animationValue.value +
                                        (MediaQuery.of(context).orientation ==
                                                Orientation.landscape
                                            ? 45.5.sp
                                            : 0))),
                                    MediaQuery.of(context).orientation ==
                                            Orientation.landscape
                                        ? 55.sp
                                        : 0),
                              child: child,
                            ),
                          );
                        },
                        child: AnimatedBuilder(
                          animation: opacityController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: isFirstTime
                                  ? opacityController.value
                                  : opacityValue < 0
                                      ? 0
                                      : opacityValue,
                              child: child,
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(27.sp),
                            child: Container(
                              height: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? 685.sp
                                  : 666.5.h,
                              width: MediaQuery.of(context).orientation ==
                                      Orientation.landscape
                                  ? 314.sp
                                  : 306.2.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(27.sp),
                              ),
                              child: Navigator(
                                key: keyTwo,
                                onGenerateRoute: (routeSettings) {
                                  return MaterialPageRoute(
                                    settings: routeSettings,
                                    builder: (context) => const HomeScreen(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IgnorePointer(
                    child: Transform(
                      transform: Matrix4.identity()
                        ..translate(
                            -animationValue.value,
                            MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? 100.sp
                                : 0),
                      child: AnimatedBuilder(
                        animation: opacityController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: isFirstTime
                                ? opacityController.value
                                : opacityValue < 0
                                    ? 0
                                    : opacityValue,
                            child: child,
                          );
                        },
                        child: Image.asset(
                            MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? CommonImageAssets.mobile
                                : CommonImageAssets.mobileSmallerScreen,
                            height: MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? 800.sp
                                : 700.h),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ],
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late PageController _pageController;
  final ValueNotifier<DateTime> dateTimeNotifier = ValueNotifier(
    DateTime.now(),
  );
  Timer? _timer;

  @override
  void initState() {
    BlocProvider.of<WeatherBloc>(context).add(WeatherEventFetch());
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      dateTimeNotifier.value = DateTime.now();
    });
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1,
    );
    animationController = AnimationController(
      duration: const Duration(seconds: 1, milliseconds: 200),
      lowerBound: 0,
      upperBound: 7,
      vsync: this,
    )
      ..forward()
      ..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    dateTimeNotifier.dispose();
    animationController.dispose();
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                state is DarkTheme
                    ? CommonImageAssets.wallpaperDark
                    : CommonImageAssets.wallpaperLight,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: PageView(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            scrollBehavior: AppScrollBehavior(),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.sp,
                  vertical: 15.sp,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TopBar(
                      dateNotifier: dateTimeNotifier,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DigitalCLock(
                      dateNotifier: dateTimeNotifier,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const WeatherWidget(),
                    const Spacer(),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DeferPointer(
                              child: GestureDetector(
                                onTap: () {
                                  launchUrl(Uri.parse(
                                      "https://www.youtube.com/watch?v=dmrB9UYQp_s"));
                                },
                                child: Container(
                                  height: 50.h,
                                  width: 50.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      CommonImageAssets.youtube,
                                      height: 36.h,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrl(
                                  Uri.parse(
                                    "https://github.com/vsc9729?tab=repositories",
                                  ),
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    CommonImageAssets.github,
                                    height: 28.8.h,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrl(
                                  Uri.parse(
                                    "https://www.linkedin.com/in/vikrant-singh-2146ba1a1/",
                                  ),
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    CommonImageAssets.linkedin,
                                    height: 33.6.h,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrl(
                                  Uri.parse(
                                    "https://www.hackerrank.com/profile/vsc_uiet",
                                  ),
                                );
                              },
                              child: Container(
                                height: 50.h,
                                width: 50.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    CommonImageAssets.hackerrank,
                                    height: 33.6.h,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        AnimatedBuilder(
                          animation: animationController,
                          builder: (context, child) {
                            return Transform(
                              transform: Matrix4.identity()
                                ..translate(0, -animationController.value),
                              child: Opacity(
                                opacity: animationController.value / 7,
                                child: child,
                              ),
                            );
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, state) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.h,
                      vertical: 5.h,
                    ),
                    color: state is DarkTheme
                        ? const Color.fromARGB(255, 40, 40, 40)
                        : const Color.fromARGB(255, 187, 187, 187),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                DeferPointer(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          opaque: false,
                                          pageBuilder: (context, animation, _) {
                                            return const CameraApp();
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 50.h,
                                      width: 50.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(9999),
                                      ),
                                      child: Center(
                                          child: Icon(
                                        Icons.camera_alt,
                                        size: 32.4.h,
                                      )),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.sp,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                    fontSize: 12.h,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (context, animation, _) {
                                          return const GalleryApp();
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 50.h,
                                    width: 50.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: Center(
                                        child: Icon(
                                      Icons.photo_sharp,
                                      color: Colors.blue,
                                      size: 26.h,
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.sp,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(
                                    fontSize: 12.h,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    launchUrl(
                                      Uri.parse(
                                        "https://github.com/vsc9729/flutter-web-portfolio",
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 50.h,
                                    width: 50.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.web,
                                        size: 26.h,
                                        color: const Color(0xffc97dbd),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.sp,
                                ),
                                Text(
                                  "Portfolio",
                                  style: TextStyle(
                                    fontSize: 12.h,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    launchUrl(
                                      Uri.parse(
                                        "https://github.com/vsc9729/tawk-poc",
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 50.h,
                                    width: 50.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(9999),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        "assets/images/tawk-sitelogo.png",
                                        height: 27.6.h,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.sp,
                                ),
                                Text(
                                  "Tawk",
                                  style: TextStyle(
                                    fontSize: 12.h,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                DeferPointer(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      keyTwo.currentState!.push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const HighLowGame(),
                                        ),
                                      );
                                      // BlocProvider.of<SeriesGameBloc>(context)
                                      //     .add(SeriesGameGetDataEvent());
                                    },
                                    child: Container(
                                      height: 50.h,
                                      width: 50.h,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          "assets/images/game_icon.png",
                                          height: 27.6.h,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.sp,
                                ),
                                Text(
                                  "HighLow",
                                  style: TextStyle(
                                    fontSize: 12.h,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> imageList = localStorage.getImageList();
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 60,
            child: Column(children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      color: const Color(0xffc97dbd),
                      child: const Center(
                        child: Text(
                          "Gallery",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 23,
                      left: 15,
                      child: DeferPointer(
                        child: GestureDetector(
                          child: IconButton(
                              onPressed: () {
                                keyTwo.currentState!.pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 17,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: 1,
                ),
                itemCount: imageList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(base64Decode(imageList[index])),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class DigitalCLock extends StatelessWidget {
  const DigitalCLock({super.key, required this.dateNotifier});

  final ValueNotifier<DateTime> dateNotifier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ValueListenableBuilder(
        valueListenable: dateNotifier,
        builder: (context, value, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  DateFormat("EEE, d MMM").format(value),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Text(
                  DateFormat("hh:mm").format(
                    value,
                  ),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.dateNotifier,
  });

  final ValueNotifier<DateTime> dateNotifier;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ValueListenableBuilder(
          valueListenable: dateNotifier,
          builder: (context, value, child) {
            return Text(
              DateFormat('h:mm').format(value),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            );
          },
        ),
        const Spacer(),
        SizedBox(
          width: 10.w,
        ),
        SizedBox(
          width: 10.w,
        ),
        const Icon(
          Icons.signal_cellular_alt,
          size: 15,
          color: Colors.white,
        ),
        const Icon(
          Icons.battery_full,
          size: 15,
          color: Colors.white,
        ),
      ],
    );
  }
}

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

class WeatherApp extends StatelessWidget {
  const WeatherApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
    );
  }
}

class HighLowGame extends StatefulWidget {
  const HighLowGame({super.key});

  @override
  State<HighLowGame> createState() => _HighLowGameState();
}

class _HighLowGameState extends State<HighLowGame>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late VideoPlayerController videoPlayerController;

  @override
  initState() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      lowerBound: -100.h,
      upperBound: 0.h,
      vsync: this,
    )..forward();
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(
          "https://videos.pexels.com/video-files/7689160/7689160-uhd_1440_2732_24fps.mp4",
        ),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
        ))
      ..initialize().then((_) async {
        await videoPlayerController.setVolume(0);
        await videoPlayerController.setLooping(true);
        await videoPlayerController.play();

        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: videoPlayerController.value.isInitialized
                ? ClipRRect(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          height: videoPlayerController.value.size.height,
                          width: videoPlayerController.value.size.width,
                          child: VideoPlayer(
                            videoPlayerController,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 60.h,
              ),
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..translate(0, -animationController.value),
                    child: Opacity(
                        opacity: 1 - (-(animationController.value / 100)),
                        child: child),
                  );
                },
                child: Image.asset(
                  "assets/images/game_start.png",
                  height: 280.h,
                ),
              ),
              Center(
                child: Image.asset(
                  "assets/images/rating_title.png",
                  height: 75.h,
                ),
              ),
              SizedBox(
                height: 70.h,
              ),
              AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 1 - (-(animationController.value / 100)),
                      child: BlocConsumer<SeriesGameBloc, SeriesGameState>(
                        listener: (context, gameDataState) {
                          if (gameDataState is SeriesGameDataReceivedState) {
                            keyTwo.currentState!.pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const HighLowGameMainScreen(),
                              ),
                            );
                          }
                        },
                        builder: (context, gameDataState) {
                          if (gameDataState is SeriesGameInitial) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 50.h,
                              ),
                              child: NeoPopTiltedButton(
                                isFloating: true,
                                onTapUp: () {
                                  BlocProvider.of<SeriesGameBloc>(context)
                                      .add(SeriesGameGetDataEvent());
                                },
                                onTapDown: () => HapticFeedback.vibrate(),
                                decoration: NeoPopTiltedButtonDecoration(
                                  color: const Color(0xff7843e6),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  plunkColor:
                                      const Color.fromARGB(255, 53, 53, 53)
                                          .withOpacity(0.5),
                                  shadowColor: Colors.black.withOpacity(0.5),
                                  showShimmer: true,
                                  shimmerColor:
                                      const Color.fromARGB(255, 36, 19, 71),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30.0.h,
                                    vertical: 12.h,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Play",
                                      style: TextStyle(
                                        fontSize: 17.h,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                            // GestureDetector(
                            //   onTap: () {

                            //   },
                            //   child: Image.asset(
                            //     "assets/images/play.png",
                            //     height: 60.sp,
                            //   ),
                            // );
                          } else {
                            return Transform(
                              transform: Matrix4.identity()
                                ..translate(0, -70.h),
                              child: LottieBuilder.asset(
                                "assets/lottie/game_loading.json",
                                height: 200.h,
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }),
            ],
          ),
          Positioned(
            top: 15.h,
            left: 15.h,
            child: DeferPointer(
              child: IconButton(
                onPressed: () {
                  keyTwo.currentState!.pop();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HighLowGameMainScreen extends StatefulWidget {
  const HighLowGameMainScreen({super.key});

  @override
  State<HighLowGameMainScreen> createState() => _HighLowGameMainScreenState();
}

class _HighLowGameMainScreenState extends State<HighLowGameMainScreen>
    with SingleTickerProviderStateMixin {
  late final PageController highLowGamePageController;
  late SeriesGameBloc seriesGameBloc;
  late AnimationController animationController;

  ValueNotifier<double> vsOpacity = ValueNotifier(1);
  // ValueNotifier<int> currentPage = ValueNotifier(0);

  @override
  initState() {
    highLowGamePageController = PageController(
      initialPage: 0,
      viewportFraction: 1 / 2,
    );
    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
    );
    animationController.addListener(() {
      if (vsOpacity.value < animationController.value) {
        vsOpacity.value = animationController.value;
      }
    });
    seriesGameBloc = BlocProvider.of<SeriesGameBloc>(context);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   highLowGamePageController.addListener(() {
    //     currentPage.value = highLowGamePageController.page!.round();
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SeriesGameBloc, SeriesGameState>(
          builder: (context, state) {
        if (state is SeriesGameDataReceivedState) {
          print("Working till here");
          return Stack(
            children: [
              PageView.builder(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                padEnds: false,
                scrollBehavior: AppScrollBehavior(),
                controller: highLowGamePageController,
                itemCount: seriesGameBloc.seriesList.length,
                itemBuilder: (context, index) {
                  print("Working 2");
                  if (index == seriesGameBloc.seriesList.length / 2) {
                    seriesGameBloc.add(SeriesGameGetDataEvent());
                  }
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          seriesGameBloc.seriesList[index].primaryImage!.url!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ValueListenableBuilder(
                        valueListenable: seriesGameBloc.isAnswered[index],
                        builder: (context, isAnswered, child) {
                          print("Working 3");
                          ShowData show = seriesGameBloc.seriesList[index];
                          return Container(
                            padding: EdgeInsets.all(15.h),
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                                child: !(isAnswered ==
                                        AnswerResponse.unanswered)
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '"${show.originalTitleText?.text ?? "Anonymous"}"',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 25.h,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            'has',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            '${show.ratingsSummary?.aggregateRating ?? 5}',
                                            style: TextStyle(
                                              fontSize: 25.h,
                                              color: const Color(0xfffff989),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            'IMDb rating',
                                            style: TextStyle(
                                              fontSize: 18.h,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '"${show.originalTitleText?.text ?? "Anonymous"}"',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 25.h,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            'has',
                                            style: TextStyle(
                                              fontSize: 18.h,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  AnswerResponse response = seriesGameBloc
                                                              .seriesList[
                                                                  index - 1]
                                                              .ratingsSummary!
                                                              .aggregateRating! <=
                                                          show.ratingsSummary!
                                                              .aggregateRating!
                                                      ? AnswerResponse.correct
                                                      : AnswerResponse.wrong;
                                                  seriesGameBloc.add(
                                                    SeriesGameAnswerEvent(
                                                      index: index,
                                                      response: response,
                                                    ),
                                                  );
                                                  if (response ==
                                                      AnswerResponse.correct) {
                                                    highLowGamePageController
                                                        .nextPage(
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.linear,
                                                    );
                                                    vsOpacity.value = 0;
                                                    await Future.delayed(
                                                        const Duration(
                                                            milliseconds: 500));
                                                    await animationController
                                                        .forward();
                                                    animationController.reset();
                                                  } else {
                                                    await Future.delayed(
                                                      const Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                    keyTwo.currentState!
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HighLowGameEndScreen(),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal: 50.h,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 5.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2.h,
                                                    ),
                                                    // shape: BoxShape.circle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      9999,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Higher",
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xfffff989),
                                                            fontSize: 18.h,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10.h,
                                                        ),
                                                        Icon(
                                                          Icons.arrow_drop_up,
                                                          size: 16.h,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  AnswerResponse response = seriesGameBloc
                                                              .seriesList[
                                                                  index - 1]
                                                              .ratingsSummary!
                                                              .aggregateRating! >=
                                                          show.ratingsSummary!
                                                              .aggregateRating!
                                                      ? AnswerResponse.correct
                                                      : AnswerResponse.wrong;
                                                  seriesGameBloc.add(
                                                    SeriesGameAnswerEvent(
                                                      index: index,
                                                      response: response,
                                                    ),
                                                  );
                                                  if (response ==
                                                      AnswerResponse.correct) {
                                                    highLowGamePageController
                                                        .nextPage(
                                                      duration: const Duration(
                                                          milliseconds: 1000),
                                                      curve: Curves.linear,
                                                    );
                                                    vsOpacity.value = 0;
                                                    await Future.delayed(
                                                        const Duration(
                                                            milliseconds: 500));
                                                    await animationController
                                                        .forward();
                                                    animationController.reset();
                                                  } else {
                                                    await Future.delayed(
                                                      const Duration(
                                                        milliseconds: 500,
                                                      ),
                                                    );
                                                    keyTwo.currentState!
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HighLowGameEndScreen(),
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                    horizontal: 50.h,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 5.h,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2.h,
                                                    ),
                                                    // shape: BoxShape.circle,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      9999,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Lower",
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xfffff989),
                                                            fontSize: 18.h,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10.h,
                                                        ),
                                                        Icon(
                                                          Icons.arrow_drop_down,
                                                          size: 16.h,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.sp,
                                          ),
                                          Text(
                                            'IMDb rating',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )),
                          );
                        }),
                  );
                },
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: vsOpacity,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: vsOpacity.value,
                            child: Container(
                              height: 50.h,
                              width: 50.h,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  "VS",
                                  style: TextStyle(
                                      fontSize: 18.h,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
              Positioned.fill(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 20.h,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Highscore: ${seriesGameBloc.highScore}",
                            style: TextStyle(
                              fontSize: 15.h,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Score: ${seriesGameBloc.score}",
                            style: TextStyle(
                              fontSize: 15.h,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              )
            ],
          );
        } else {
          return const Center(
            child: Text("Something went wrong"),
          );
        }
      }),
    );
  }
}

class HighLowGameEndScreen extends StatefulWidget {
  const HighLowGameEndScreen({super.key});

  @override
  State<HighLowGameEndScreen> createState() => _HighLowGameEndScreenState();
}

class _HighLowGameEndScreenState extends State<HighLowGameEndScreen>
    with TickerProviderStateMixin {
  late AnimationController gameOverAnimationController;
  late AnimationController scoreAnimationController;
  late AnimationController highScoreAnimationController;
  late VideoPlayerController videoPlayerController;
  late SeriesGameBloc _seriesGameBloc;
  @override
  void dispose() {
    gameOverAnimationController.dispose();
    scoreAnimationController.dispose();
    highScoreAnimationController.dispose();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    gameOverAnimationController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
    )..forward();
    scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 5500),
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
    )..forward();
    highScoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 6500),
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
    )..forward();
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(
          "https://videos.pexels.com/video-files/6976215/6976215-uhd_1440_1920_25fps.mp4",
        ),
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
        ))
      ..initialize().then((_) async {
        await videoPlayerController.setVolume(0);
        await videoPlayerController.setLooping(true);
        await videoPlayerController.play();

        setState(() {});
      });
    _seriesGameBloc = BlocProvider.of<SeriesGameBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: videoPlayerController.value.isInitialized
                ? ClipRRect(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          height: videoPlayerController.value.size.height,
                          width: videoPlayerController.value.size.width,
                          child: VideoPlayer(
                            videoPlayerController,
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              AnimatedBuilder(
                animation: gameOverAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: gameOverAnimationController.value,
                    child: child,
                  );
                },
                child: Image.asset(
                  "assets/images/game_over.png",
                  height: 200.h,
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              AnimatedBuilder(
                animation: scoreAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: gameOverAnimationController.value,
                    child: child,
                  );
                },
                child: Center(
                  child: Text(
                    "Score: ${_seriesGameBloc.score}",
                    style: TextStyle(
                      fontSize: 25.h,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              AnimatedBuilder(
                animation: highScoreAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: gameOverAnimationController.value,
                    child: child,
                  );
                },
                child: Center(
                  child: Text(
                    "High Score: ${_seriesGameBloc.highScore}",
                    style: TextStyle(
                      fontSize: 20.h,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 50.h,
                ),
                child: NeoPopTiltedButton(
                  isFloating: true,
                  onTapUp: () {
                    _seriesGameBloc.add(SeriesGameRestartGameEvent());
                    keyTwo.currentState!.pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HighLowGame(),
                      ),
                    );
                  },
                  onTapDown: () => HapticFeedback.vibrate(),
                  decoration: NeoPopTiltedButtonDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      plunkColor: const Color.fromARGB(255, 61, 61, 61),
                      shadowColor: Colors.black.withOpacity(0.5),
                      showShimmer: true),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0.h,
                      vertical: 15.h,
                    ),
                    child: Center(
                      child: Text(
                        "Restart",
                        style: TextStyle(
                          fontSize: 17.h,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  final _localRenderer = RTCVideoRenderer();

  initRenderers() async {
    await _localRenderer.initialize();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      },
    };
    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    _localRenderer.srcObject = stream;
  }

  @override
  void initState() {
    initRenderers();
    _getUserMedia();
    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RTCVideoView(
          _localRenderer,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
        ),
        Positioned(
          top: 30,
          left: 15,
          child: DeferPointer(
            child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  keyTwo.currentState!.pop();
                }),
          ),
        ),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.black.withOpacity(0.5),
                height: 70,
                child: Center(
                  child: Material(
                    borderRadius: BorderRadius.circular(9999),
                    color: Colors.red,
                    elevation: 10,
                    child: GestureDetector(
                      onTap: () async {
                        //Do something
                        var videoTrack =
                            _localRenderer.srcObject!.getVideoTracks().first;
                        ByteBuffer frame = await videoTrack.captureFrame();

                        Uint8List image = frame.asUint8List();
                        final player = AudioPlayer(); // Create a player
                        await player.setAsset("assets/audio/camera.mp3");
                        player.play();
                        String imageEncoded = base64Encode(image);
                        localStorage.addToImageList(imageEncoded);
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          color: Colors.red,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.camera,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
