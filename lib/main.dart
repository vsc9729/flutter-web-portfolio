import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:portfolio/bloc/navigation/navigation_bloc.dart';
import 'package:portfolio/bloc/theme/theme_bloc.dart';
import 'package:portfolio/bloc/weather/weather_bloc.dart';
import 'package:portfolio/constants/common_assets.dart';
import 'package:portfolio/serializers/weather.dart';
import 'package:portfolio/services/local_storage/local_storage.dart';
import 'package:portfolio/theme/index.dart';
import 'package:portfolio/utils/particles_fly.dart';
import 'package:url_launcher/url_launcher.dart';

var keyOne = GlobalKey<NavigatorState>();
var keyTwo = GlobalKey<NavigatorState>();
void main() async {
  await dotenv.load(fileName: "dotenv");
  await MyLocalStorage.init();
  runApp(const MyApp());
}

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
          BlocProvider<NavigationBloc>(
            create: (context) => NavigationBloc(),
          ),
          BlocProvider<WeatherBloc>(
            create: (context) => WeatherBloc(),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Portfolio Application',
              navigatorKey: keyOne,
              debugShowCheckedModeBanner: false,
              theme: state is DarkTheme
                  ? AppThemes.darkTheme
                  : AppThemes.lightTheme,
              home: const MyHomePage(),
            );
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
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
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, navigationState) {
            return navigationState is HomePage
                ? BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) {
                      return ParticlesFlyCustom(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        connectDots: true,
                        bgColor: Theme.of(context).scaffoldBackgroundColor,
                        numberOfParticles:
                            MediaQuery.of(context).size.width < 680 ? 50 : 100,
                        particleColor: Colors.amber
                            .withOpacity(state is DarkTheme ? 0.2 : 0.2),
                        lineColor: Colors.amber
                            .withOpacity(state is DarkTheme ? 0.2 : 0.2),
                      );
                    },
                  )
                : const SizedBox.shrink();
          },
        ),
        Positioned.fill(
          child: PageView(
            scrollDirection: Axis.vertical,
            scrollBehavior: AppScrollBehavior(),
            controller: PageController(
              initialPage: 0,
              viewportFraction: 1,
            ),
            children: [
              Stack(
                children: [
                  BlocBuilder<NavigationBloc, NavigationState>(
                    builder: (context, navigationState) {
                      return Scaffold(
                        backgroundColor: navigationState is HomePage
                            ? Colors.transparent
                            : null,
                        body: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black12,
                                ]),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 25.h,
                                  ),
                                  child: BlocBuilder<ThemeBloc, ThemeState>(
                                    builder: (context, state) {
                                      return (state is LightTheme ||
                                              state is ThemeInitial)
                                          ? IconButton(
                                              onPressed: () {
                                                BlocProvider.of<ThemeBloc>(
                                                        context)
                                                    .add(ChangeThemeEvent());
                                              },
                                              icon: const Icon(
                                                Icons.dark_mode,
                                                color: Colors.black,
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                BlocProvider.of<ThemeBloc>(
                                                        context)
                                                    .add(ChangeThemeEvent());
                                              },
                                              icon: const Icon(
                                                Icons.light_mode,
                                                color: Colors.white,
                                              ),
                                            );
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: BlocBuilder<NavigationBloc,
                                      NavigationState>(
                                    builder: (context, navigationState) {
                                      switch (navigationState) {
                                        case HomePage():
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      1080
                                                  ? const Spacer()
                                                  : const SizedBox(
                                                      width: 20,
                                                    ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 100.w,
                                                  ),
                                                  Stack(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 120.h,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        backgroundImage:
                                                            const AssetImage(
                                                          CommonImageAssets
                                                              .profileImage,
                                                        ),
                                                      ),
                                                      Positioned.fill(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9999),
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      DefaultTextStyle(
                                                        style: TextStyle(
                                                          fontSize: scaleText(
                                                              120.sp, context),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge!
                                                                  .color,
                                                        ),
                                                        child: AnimatedTextKit(
                                                          repeatForever: false,
                                                          isRepeatingAnimation:
                                                              false,
                                                          animatedTexts: [
                                                            TypewriterAnimatedText(
                                                              'Hi, I am Vikrant',
                                                              speed:
                                                                  const Duration(
                                                                milliseconds:
                                                                    100,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text(
                                                        'Software Developer',
                                                        style: TextStyle(
                                                          fontSize: scaleText(
                                                              70.sp, context),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Read more',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  scaleText(
                                                                      50.sp,
                                                                      context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' ',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  scaleText(
                                                                      50.sp,
                                                                      context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Text(
                                                            'about me',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  scaleText(
                                                                      50.sp,
                                                                      context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' ',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  scaleText(
                                                                      50.sp,
                                                                      context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          Text(
                                                            'or',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  scaleText(
                                                                      50.sp,
                                                                      context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                            ),
                                                          ),
                                                          Text(
                                                            ' ',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  scaleText(
                                                                      50.sp,
                                                                      context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                          Text(
                                                            'contact me',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    scaleText(
                                                                        50.sp,
                                                                        context),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .amber),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  if (MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      1080)
                                                    const Expanded(
                                                      child: Center(
                                                        child: MobileWidget(),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      1080
                                                  ? const SizedBox(
                                                      height: 40,
                                                    )
                                                  : const SizedBox.shrink(),
                                              if (MediaQuery.of(context)
                                                      .size
                                                      .width <
                                                  1080)
                                                const Expanded(
                                                  child: Center(
                                                    child: MobileWidget(),
                                                  ),
                                                ),
                                              MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      1080
                                                  ? const Spacer()
                                                  : const SizedBox.shrink(),
                                            ],
                                          );
                                        case ProjectsPage():
                                          return Container(
                                            color: Colors.purple,
                                          );
                                        case AboutPage():
                                          return Container(
                                            color: Colors.blue,
                                          );
                                        case ContactPage():
                                          return Container(
                                            color: Colors.green,
                                          );

                                        default:
                                          return Container(
                                            color: Colors.red,
                                          );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {},
                      child: AnimatedBuilder(
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
                        child: const Icon(
                          Icons.keyboard_arrow_up,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //projects
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black12,
                      Colors.black26,
                    ],
                  ),
                ),
              ),
              //about me
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black26,
                      Colors.black38,
                    ],
                  ),
                ),
              ),
              //contact me
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black38,
                      Colors.black54,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MobileWidget extends StatefulWidget {
  const MobileWidget({
    super.key,
  });

  @override
  State<MobileWidget> createState() => _MobileWidgetState();
}

class _MobileWidgetState extends State<MobileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      lowerBound: -500,
      upperBound: 0,
      vsync: this,
    )..forward();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..translate(animationController.value),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      CommonImageAssets.mobile,
                      height: 700.h,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.2),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Container(
                          height: 662.h,
                          width: 312.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
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
                ],
              ),
            );
          },
        ),
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
    )..addListener(() {
        print(_pageController.page);
      });
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
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
                            GestureDetector(
                              onTap: () {
                                launchUrl(Uri.parse(
                                    "https://www.youtube.com/watch?v=dmrB9UYQp_s"));
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    CommonImageAssets.youtube,
                                    height: 40,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                launchUrl(
                                  Uri.parse(
                                    "https://github.com/vsc9729",
                                  ),
                                );
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    CommonImageAssets.github,
                                    height: 30,
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
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    CommonImageAssets.linkedin,
                                    height: 35,
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
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    CommonImageAssets.hackerrank,
                                    height: 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    color: state is DarkTheme
                        ? const Color.fromARGB(255, 40, 40, 40)
                        : const Color.fromARGB(255, 187, 187, 187),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
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
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: const Center(
                                    child: Icon(
                                  Icons.camera_alt,
                                  size: 27,
                                )),
                              ),
                            ),
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
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: const Center(
                                    child: Icon(
                                  Icons.photo_sharp,
                                  color: Colors.blue,
                                  size: 27,
                                )),
                              ),
                            )
                          ],
                        )
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
                      color: Colors.amber,
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
                      child: GestureDetector(
                        onTap: () {
                          keyTwo.currentState!.pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 17,
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
            color: Colors.amber,
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
          child: GestureDetector(
            onTap: () {
              keyTwo.currentState!.pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
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

double scaleText(double fontSize, BuildContext context) {
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

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.menuItemText,
    required this.onTap,
  });
  final String menuItemText;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        menuItemText,
        style: TextStyle(
          fontSize: scaleText(45.sp, context),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
