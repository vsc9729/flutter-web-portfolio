import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:portfolio/bloc/theme/theme_bloc.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/screens/about/about.dart';
import 'package:portfolio/screens/contact/contact.dart';
import 'package:portfolio/screens/mobile/mobile.dart';
import 'package:portfolio/screens/projects/projects.dart';
import 'package:portfolio/utils/app_scroll_behaviour.dart';
import 'package:portfolio/utils/common_util.dart';
import 'package:portfolio/utils/page_scroll_physics.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController animationController;
  late PageController websitePageController;
  late ValueNotifier pageNotifier = ValueNotifier(0);

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    websitePageController = PageController(
      initialPage: 0,
      viewportFraction: 1,
      keepPage: true,
    )..addListener(() {
        if (websitePageController.page! >= 0) {
          isFirstTime = false;
          pageNotifier.value = websitePageController.page!;
        }
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

  double _calculateOpacity(double index, double currentPage) {
    double distance = (currentPage - index).abs();
    return (1 - distance).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, appThemeState) {
        return Stack(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            Positioned.fill(
              child: ValueListenableBuilder(
                  valueListenable: pageNotifier,
                  builder: (context, value, child) {
                    return PageView(
                      controller: websitePageController,
                      scrollDirection: Axis.vertical,
                      physics: pageNotifier.value.toInt() == 2 ||
                              pageNotifier.value.toInt() == 3
                          ? const NeverScrollableScrollPhysics()
                          : const CustomPageViewScrollPhysics(),
                      scrollBehavior: AppScrollBehavior(),
                      children: [
                        Stack(
                          children: [
                            Scaffold(
                              backgroundColor: Colors.transparent,
                              body: BlocBuilder<ThemeBloc, ThemeState>(
                                builder: (context, themeState) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent,
                                          themeState is DarkTheme
                                              ? const Color(0xff7762de)
                                                  .withOpacity(0.2)
                                              : const Color(0xffd96821)
                                                  .withOpacity(0.2),
                                        ],
                                        stops: const [0, 0.6, 1],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Opacity(
                                      opacity: _calculateOpacity(
                                          0, pageNotifier.value),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 25.h,
                                              ),
                                              child: BlocBuilder<ThemeBloc,
                                                  ThemeState>(
                                                builder: (context, state) {
                                                  return (state is LightTheme ||
                                                          state is ThemeInitial)
                                                      ? IconButton(
                                                          onPressed: () {
                                                            BlocProvider.of<
                                                                        ThemeBloc>(
                                                                    context)
                                                                .add(
                                                                    ChangeThemeEvent());
                                                          },
                                                          icon: const Icon(
                                                            Icons.dark_mode,
                                                            color: Colors.black,
                                                          ),
                                                        )
                                                      : IconButton(
                                                          onPressed: () {
                                                            BlocProvider.of<
                                                                        ThemeBloc>(
                                                                    context)
                                                                .add(
                                                                    ChangeThemeEvent());
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
                                              child: DeferredPointerHandler(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment: MediaQuery
                                                                  .of(context)
                                                              .orientation ==
                                                          Orientation.landscape
                                                      ? CrossAxisAlignment
                                                          .center
                                                      : CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    MediaQuery.of(context)
                                                                .size
                                                                .width >
                                                            1080
                                                        ? SizedBox(
                                                            height: 20.h,
                                                          )
                                                        : SizedBox(
                                                            height: 20.h,
                                                          ),
                                                    Stack(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                              context)
                                                                          .orientation ==
                                                                      Orientation
                                                                          .landscape
                                                                  ? 100.w
                                                                  : 0.w,
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
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: CommonUtil
                                                                        .scaleText(
                                                                            120.sp,
                                                                            context),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyLarge!
                                                                        .color,
                                                                  ),
                                                                  child:
                                                                      AnimatedTextKit(
                                                                    repeatForever:
                                                                        false,
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
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: CommonUtil
                                                                        .scaleText(
                                                                            70.sp,
                                                                            context),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                                Wrap(
                                                                  children: [
                                                                    Text(
                                                                      'Discover more',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize: CommonUtil.scaleText(
                                                                            50.sp,
                                                                            context),
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ' ',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize: CommonUtil.scaleText(
                                                                            50.sp,
                                                                            context),
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        websitePageController.nextPage(
                                                                            duration:
                                                                                const Duration(seconds: 1),
                                                                            curve: Curves.ease);
                                                                      },
                                                                      child: BlocBuilder<
                                                                          ThemeBloc,
                                                                          ThemeState>(
                                                                        builder:
                                                                            (context,
                                                                                state) {
                                                                          return Text(
                                                                            'about me,',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: CommonUtil.scaleText(50.sp, context),
                                                                              fontWeight: FontWeight.w500,
                                                                              color: state is DarkTheme ? const Color(0xff4c47d3) : const Color(0xffd96821),
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ' ',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize: CommonUtil.scaleText(
                                                                            50.sp,
                                                                            context),
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        await websitePageController.animateToPage(
                                                                            2,
                                                                            duration:
                                                                                const Duration(seconds: 1),
                                                                            curve: Curves.ease);
                                                                      },
                                                                      child: BlocBuilder<
                                                                          ThemeBloc,
                                                                          ThemeState>(
                                                                        builder:
                                                                            (context,
                                                                                state) {
                                                                          return Text(
                                                                            'my projects',
                                                                            style: TextStyle(
                                                                                fontSize: CommonUtil.scaleText(
                                                                                  50.sp,
                                                                                  context,
                                                                                ),
                                                                                fontWeight: FontWeight.w500,
                                                                                color: state is DarkTheme ? const Color(0xff7762de) : const Color(0xff6c7d3d)),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      ' or ',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize: CommonUtil.scaleText(
                                                                            50.sp,
                                                                            context),
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        await websitePageController.animateToPage(
                                                                            3,
                                                                            duration:
                                                                                const Duration(seconds: 1),
                                                                            curve: Curves.ease);
                                                                      },
                                                                      child: BlocBuilder<
                                                                          ThemeBloc,
                                                                          ThemeState>(
                                                                        builder:
                                                                            (context,
                                                                                state) {
                                                                          return Text(
                                                                            'get in touch.',
                                                                            style: TextStyle(
                                                                                fontSize: CommonUtil.scaleText(50.sp, context),
                                                                                fontWeight: FontWeight.w500,
                                                                                color: state is DarkTheme ? const Color(0xff843855) : const Color(0xffaa9f8b)),
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            if (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                1080)
                                                              Expanded(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    const Spacer(),
                                                                    MobileWidget(
                                                                      pageController:
                                                                          websitePageController,
                                                                    ),
                                                                    const Spacer(),
                                                                  ],
                                                                ),
                                                              ),
                                                          ],
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
                                                        : const SizedBox
                                                            .shrink(),
                                                    if (MediaQuery.of(context)
                                                            .size
                                                            .width <
                                                        1080)
                                                      Expanded(
                                                        child: Center(
                                                          child: MobileWidget(
                                                            pageController:
                                                                websitePageController,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
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
                                        ..translate(
                                            0, -animationController.value),
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
                        BlocBuilder<ThemeBloc, ThemeState>(
                          builder: (context, themeState) {
                            return Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [
                                  themeState is DarkTheme
                                      ? const Color(0xff7762de).withOpacity(0.2)
                                      : const Color(0xffd96821)
                                          .withOpacity(0.2),
                                  Colors.transparent,
                                  Colors.transparent,
                                ],
                                stops: const [0, 0.4, 1],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )),
                              child: Opacity(
                                opacity:
                                    _calculateOpacity(1, pageNotifier.value),
                                child: AboutMe(
                                  pageController: websitePageController,
                                ),
                              ),
                            );
                          },
                        ),
                        Opacity(
                          opacity: _calculateOpacity(2, pageNotifier.value),
                          child: Projects(
                            websitePageController: websitePageController,
                          ),
                        ),
                        Opacity(
                          opacity: _calculateOpacity(3, pageNotifier.value),
                          child: Listener(
                            onPointerSignal: (event) {
                              if (event is PointerScrollEvent) {
                                if (event.scrollDelta.dy < 0) {
                                  websitePageController.previousPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                }
                              }
                            },
                            onPointerMove: (moveEvent) {
                              if (moveEvent.delta.dy > 0) {
                                websitePageController.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              }
                            },
                            child: const ContactMe(),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        );
      },
    );
  }
}
