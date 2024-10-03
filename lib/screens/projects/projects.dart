import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:portfolio/bloc/theme/theme_bloc.dart';
import 'package:portfolio/constants/common_assets.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/theme/index.dart';
import 'package:portfolio/utils/page_scroll_physics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Projects extends StatefulWidget {
  const Projects({super.key, required this.websitePageController});
  final PageController websitePageController;

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late PageController pageController;
  ValueNotifier<int> scrollValue = ValueNotifier(0);
  AnimationController? firstAnimationController;
  AnimationController? secondAnimationController;
  AnimationController? thirdAnimationController;
  ValueNotifier<double> visibilityValueOne = ValueNotifier(1);
  ValueNotifier<double> visibilityValueTwo = ValueNotifier(0);
  ValueNotifier<double> visibilityValueThree = ValueNotifier(0);

  ValueNotifier<double> animationValue = ValueNotifier(-500);
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    pageController = PageController(
      initialPage: 0,
      viewportFraction: 1,
      keepPage: true,
      // keepPage: true,
    );
    firstAnimationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
    )..forward();
    secondAnimationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
    );
    thirdAnimationController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
    );
    widget.websitePageController.addListener(() {
      print("anv: ${animationValue.value}");
      animationValue.value = (widget.websitePageController.page! - 2) * -500;
    });
    widget.websitePageController.addListener(() {
      // print("Website Page: ${widget.websitePageController.page}");
      if (widget.websitePageController.page!.floor() == 2) {
        scrollValue.value = 1;
      } else {
        scrollValue.value = 0;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: scrollValue,
          builder: (context, value, child) {
            return Listener(
              onPointerMove: (event) {
                if (event.kind == PointerDeviceKind.touch) {
                  if (event.delta.dy < 0 &&
                      pageController.page! >= 2 &&
                      widget.websitePageController.page!.floor() == 2) {
                    widget.websitePageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.linear,
                    );
                  } else if (event.delta.dy > 0 &&
                      pageController.page == 0 &&
                      widget.websitePageController.page!.floor() == 2) {
                    widget.websitePageController.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.linear,
                    );
                  }
                }
              },
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  if (event.scrollDelta.dy > 0 &&
                      pageController.page! >= 2 &&
                      widget.websitePageController.page!.floor() == 2) {
                    widget.websitePageController.nextPage(
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.linear,
                    );
                  } else if (event.scrollDelta.dy < 0 &&
                      pageController.page == 0 &&
                      widget.websitePageController.page!.floor() == 2) {
                    widget.websitePageController.previousPage(
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.linear,
                    );
                  }

                  if (event.scrollDelta.dy > 0) {
                    if (pageController.page! >= 0.45 &&
                        pageController.page! <= 1) {
                      firstAnimationController!.reverse();
                      secondAnimationController!.forward();
                    } else if (pageController.page! >= 1.5 &&
                        pageController.page! <= 2 / 1.2) {
                      secondAnimationController!.reverse();
                      thirdAnimationController!.forward();
                    }
                  } else if (event.scrollDelta.dy < 0) {
                    if (pageController.page! >= 1 &&
                        pageController.page! <= 1.5) {
                      thirdAnimationController!.reverse();
                      secondAnimationController!.forward();
                    } else if (pageController.page! >= 0 &&
                        pageController.page! <= 0.5) {
                      secondAnimationController!.reverse();
                      firstAnimationController!.forward();
                    }
                  }
                }
              },
              child: ValueListenableBuilder(
                  valueListenable: animationValue,
                  builder: (context, value, child) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..translate(animationValue.value),
                      child: BlocBuilder<ThemeBloc, ThemeState>(
                        builder: (context, themeState) {
                          return LayoutBuilder(builder: (context, constraints) {
                            if (constraints.maxWidth > 480) {
                              return Stack(
                                children: [
                                  PageView.builder(
                                    scrollDirection: Axis.vertical,
                                    padEnds: false,
                                    pageSnapping: false,
                                    physics: scrollValue.value == 1
                                        ? const CustomPageViewScrollPhysics()
                                        : const NeverScrollableScrollPhysics(),
                                    itemCount: 3,
                                    controller: pageController,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Spacer(),
                                          Expanded(
                                            flex: 2,
                                            child: (index == 0)
                                                ? VisibilityDetector(
                                                    key: const Key("portfolio"),
                                                    onVisibilityChanged:
                                                        (info) {
                                                      visibilityValueOne.value =
                                                          info.visibleFraction;
                                                    },
                                                    child: Column(
                                                      children: [
                                                        const Spacer(),
                                                        Expanded(
                                                          child:
                                                              ValueListenableBuilder(
                                                            valueListenable:
                                                                visibilityValueOne,
                                                            builder: (context,
                                                                value, child) {
                                                              return Opacity(
                                                                opacity:
                                                                    visibilityValueOne
                                                                        .value,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        FittedBox(
                                                                          child:
                                                                              Text(
                                                                            "Portfolio",
                                                                            style:
                                                                                TextStyle(
                                                                              height: 0.8,
                                                                              fontSize: 50.sp,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2.sp,
                                                                        ),
                                                                        OutlinedButton(
                                                                          style:
                                                                              ButtonStyle(
                                                                            shape:
                                                                                WidgetStateProperty.all(
                                                                              const CircleBorder(),
                                                                            ),
                                                                            overlayColor:
                                                                                WidgetStateProperty.all(
                                                                              Colors.transparent,
                                                                            ),
                                                                            padding:
                                                                                WidgetStateProperty.all(
                                                                              EdgeInsets.zero,
                                                                            ),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            launchUrl(Uri.parse(
                                                                              "https://github.com/vsc9729/flutter-web-portfolio",
                                                                            ));
                                                                          },
                                                                          child:
                                                                              Image.network(
                                                                            themeState is DarkTheme
                                                                                ? "https://firebasestorage.googleapis.com/v0/b/vikrant-portfolio-68806.appspot.com/o/ext_l.png?alt=media&token=4ae3da8e-2e01-4aad-a2d0-a09b4e363834"
                                                                                : "https://img.icons8.com/material-outlined/48/external-link.png",
                                                                            height:
                                                                                20.sp,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10.sp,
                                                                    ),
                                                                    Text(
                                                                      "The portfolio website that you are currently on is made using Flutter and Dart. It is a responsive website that works on all devices. The website is hosted on Firebase Hosting. The website is made using the BLoC pattern.",
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            25.sp,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            AppFonts.poppins,
                                                                        color: Theme.of(context)
                                                                            .textTheme
                                                                            .bodyMedium!
                                                                            .color!
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                      ],
                                                    ),
                                                  )
                                                : index == 1
                                                    ? VisibilityDetector(
                                                        key: const Key(
                                                            "HighLow"),
                                                        onVisibilityChanged:
                                                            (info) {
                                                          visibilityValueTwo
                                                                  .value =
                                                              info.visibleFraction;
                                                        },
                                                        child: Column(
                                                          children: [
                                                            const Spacer(),
                                                            Expanded(
                                                              child:
                                                                  ValueListenableBuilder(
                                                                valueListenable:
                                                                    visibilityValueTwo,
                                                                builder:
                                                                    (context,
                                                                        value,
                                                                        child) {
                                                                  return Opacity(
                                                                    opacity:
                                                                        visibilityValueTwo
                                                                            .value,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            FittedBox(
                                                                              child: Text(
                                                                                "High Low Game",
                                                                                style: TextStyle(
                                                                                  height: 0.8,
                                                                                  fontSize: 50.sp,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                                textAlign: TextAlign.left,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 2.sp,
                                                                            ),
                                                                            OutlinedButton(
                                                                              style: ButtonStyle(
                                                                                shape: WidgetStateProperty.all(
                                                                                  const CircleBorder(),
                                                                                ),
                                                                                overlayColor: WidgetStateProperty.all(
                                                                                  Colors.transparent,
                                                                                ),
                                                                                padding: WidgetStateProperty.all(
                                                                                  EdgeInsets.zero,
                                                                                ),
                                                                              ),
                                                                              onPressed: () {
                                                                                launchUrl(Uri.parse(""));
                                                                              },
                                                                              child: Image.network(
                                                                                themeState is DarkTheme ? "https://firebasestorage.googleapis.com/v0/b/vikrant-portfolio-68806.appspot.com/o/ext_l.png?alt=media&token=4ae3da8e-2e01-4aad-a2d0-a09b4e363834" : "https://img.icons8.com/material-outlined/48/external-link.png",
                                                                                height: 20.sp,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10.sp,
                                                                        ),
                                                                        Text(
                                                                          "I developed a Higher-Lower game in Flutter where players guess which of two TV shows has a higher IMDb rating. The game pulls data from an API that features the top 500 most famous TV shows, ensuring a dynamic and engaging experience. With an intuitive user interface and real-time feedback, players enjoy seamless gameplay while tracking their scores.",
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                25.sp,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontFamily:
                                                                                AppFonts.poppins,
                                                                            color:
                                                                                Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                          ],
                                                        ),
                                                      )
                                                    : VisibilityDetector(
                                                        key: const Key(
                                                            "tawkDemo"),
                                                        onVisibilityChanged:
                                                            (info) {
                                                          visibilityValueThree
                                                                  .value =
                                                              info.visibleFraction;
                                                        },
                                                        child: Column(
                                                          children: [
                                                            const Spacer(),
                                                            Expanded(
                                                              child:
                                                                  ValueListenableBuilder(
                                                                valueListenable:
                                                                    visibilityValueThree,
                                                                builder:
                                                                    (context,
                                                                        value,
                                                                        child) {
                                                                  return Opacity(
                                                                    opacity:
                                                                        visibilityValueThree
                                                                            .value,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            FittedBox(
                                                                              child: Text(
                                                                                "ChatBot using Tawk",
                                                                                style: TextStyle(
                                                                                  height: 0.8,
                                                                                  fontSize: 50.sp,
                                                                                  fontWeight: FontWeight.w600,
                                                                                ),
                                                                                textAlign: TextAlign.left,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 2.sp,
                                                                            ),
                                                                            OutlinedButton(
                                                                              style: ButtonStyle(
                                                                                shape: WidgetStateProperty.all(
                                                                                  const CircleBorder(),
                                                                                ),
                                                                                overlayColor: WidgetStateProperty.all(
                                                                                  Colors.transparent,
                                                                                ),
                                                                                padding: WidgetStateProperty.all(
                                                                                  EdgeInsets.zero,
                                                                                ),
                                                                              ),
                                                                              onPressed: () {
                                                                                launchUrl(Uri.parse("https://github.com/vsc9729/tawk-poc"));
                                                                              },
                                                                              child: Image.network(
                                                                                themeState is DarkTheme ? "https://firebasestorage.googleapis.com/v0/b/vikrant-portfolio-68806.appspot.com/o/ext_l.png?alt=media&token=4ae3da8e-2e01-4aad-a2d0-a09b4e363834" : "https://img.icons8.com/material-outlined/48/external-link.png",
                                                                                height: 20.sp,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10.sp,
                                                                        ),
                                                                        Text(
                                                                          "I developed a chatbot using Tawk.to, a popular chatbot service. The chatbot is integrated into the website/app and provides real-time customer support. The chatbot is highly customizable and can be tailored to suit the needs of the business. The chatbot is easy to use and provides a seamless experience for customers.",
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                25.sp,
                                                                            fontFamily:
                                                                                AppFonts.poppins,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color:
                                                                                Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                          ],
                                                        ),
                                                      ),
                                          ),
                                          const Spacer(
                                            flex: 2,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  Positioned.fill(
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        Expanded(
                                            child: Center(
                                          child: AnimatedBuilder(
                                              animation:
                                                  firstAnimationController!,
                                              builder: (context, child) {
                                                return Opacity(
                                                  opacity:
                                                      firstAnimationController!
                                                          .value,
                                                  child: Transform(
                                                    transform:
                                                        Matrix4.identity()
                                                          ..scale(1.15, 1.15)
                                                          ..translate(
                                                              0.0, 35.sp),
                                                    child: Image.network(
                                                      themeState is DarkTheme
                                                          ? CommonImageAssets
                                                              .portfolioDark
                                                          : CommonImageAssets
                                                              .portfolioLight,
                                                      height: 2300.sp,
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )),
                                      ],
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        Expanded(
                                            child: Center(
                                          child: AnimatedBuilder(
                                              animation:
                                                  secondAnimationController!,
                                              builder: (context, child) {
                                                return Transform(
                                                  transform: Matrix4.identity()
                                                    ..scale(1.15, 1.15)
                                                    ..translate(0.0, 35.sp),
                                                  child: Opacity(
                                                    opacity:
                                                        secondAnimationController!
                                                            .value,
                                                    child: Image.network(
                                                      themeState is DarkTheme
                                                          ? CommonImageAssets
                                                              .highLowGameDemoDark
                                                          : CommonImageAssets
                                                              .highLowGameDemoLight,
                                                      height: 2300.sp,
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )),
                                      ],
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        Expanded(
                                            child: Center(
                                          child: AnimatedBuilder(
                                              animation:
                                                  thirdAnimationController!,
                                              builder: (context, child) {
                                                return Opacity(
                                                  opacity:
                                                      thirdAnimationController!
                                                          .value,
                                                  child: Transform(
                                                    transform:
                                                        Matrix4.identity()
                                                          ..scale(1.15, 1.15)
                                                          ..translate(
                                                              0.0, 35.sp),
                                                    child: Image.network(
                                                      themeState is DarkTheme
                                                          ? CommonImageAssets
                                                              .tawkDemoDark
                                                          : CommonImageAssets
                                                              .tawkDemoLight,
                                                      height: 2300.sp,
                                                    ),
                                                  ),
                                                );
                                              }),
                                        )),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return GestureDetector(
                                onPanUpdate: (details) {
                                  print("delta: ${details.delta.dy}");
                                  if (details.delta.dy > 0 &&
                                      pageController.page! >= 2 &&
                                      widget.websitePageController.page!
                                              .floor() ==
                                          2) {
                                    widget.websitePageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 1200),
                                      curve: Curves.linear,
                                    );
                                  } else if (details.delta.dy < 0 &&
                                      pageController.page == 0 &&
                                      widget.websitePageController.page!
                                              .floor() ==
                                          2) {
                                    widget.websitePageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 1200),
                                      curve: Curves.linear,
                                    );
                                  }
                                },
                                child: PageView.builder(
                                  scrollDirection: Axis.vertical,
                                  padEnds: false,
                                  pageSnapping: false,
                                  physics: scrollValue.value == 1
                                      ? const CustomPageViewScrollPhysics()
                                      : const NeverScrollableScrollPhysics(),
                                  itemCount: 3,
                                  controller: pageController,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 50.w,
                                        vertical: 20.h,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: (index == 0)
                                                  ? VisibilityDetector(
                                                      key: const Key(
                                                          "portfolio"),
                                                      onVisibilityChanged:
                                                          (info) {
                                                        visibilityValueOne
                                                                .value =
                                                            info.visibleFraction;
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                ValueListenableBuilder(
                                                              valueListenable:
                                                                  visibilityValueOne,
                                                              builder: (context,
                                                                  value,
                                                                  child) {
                                                                return Opacity(
                                                                  opacity:
                                                                      visibilityValueOne
                                                                          .value,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          FittedBox(
                                                                            child:
                                                                                Text(
                                                                              "Portfolio",
                                                                              style: TextStyle(
                                                                                height: 0.8,
                                                                                fontSize: 30.h,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                              textAlign: TextAlign.left,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                5.h,
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              launchUrl(Uri.parse(
                                                                                "https://github.com/vsc9729/flutter-web-portfolio",
                                                                              ));
                                                                            },
                                                                            child:
                                                                                Image.network(
                                                                              themeState is DarkTheme ? "https://firebasestorage.googleapis.com/v0/b/vikrant-portfolio-68806.appspot.com/o/ext_l.png?alt=media&token=4ae3da8e-2e01-4aad-a2d0-a09b4e363834" : "https://img.icons8.com/material-outlined/48/external-link.png",
                                                                              height: 25.h,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            15.h,
                                                                      ),
                                                                      Text(
                                                                        "The portfolio website that you are currently on is made using Flutter and Dart. It is a responsive website that works on all devices. The website is hosted on Firebase Hosting. The website is made using the BLoC pattern.",
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15.h,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              AppFonts.poppins,
                                                                          color: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyMedium!
                                                                              .color!
                                                                              .withOpacity(0.5),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : index == 1
                                                      ? VisibilityDetector(
                                                          key: const Key(
                                                              "HighLow"),
                                                          onVisibilityChanged:
                                                              (info) {
                                                            visibilityValueTwo
                                                                    .value =
                                                                info.visibleFraction;
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    ValueListenableBuilder(
                                                                  valueListenable:
                                                                      visibilityValueTwo,
                                                                  builder:
                                                                      (context,
                                                                          value,
                                                                          child) {
                                                                    return Opacity(
                                                                      opacity:
                                                                          visibilityValueTwo
                                                                              .value,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              FittedBox(
                                                                                child: Text(
                                                                                  "High Low Game",
                                                                                  style: TextStyle(
                                                                                    height: 0.8,
                                                                                    fontSize: 30.h,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                  textAlign: TextAlign.left,
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5.h,
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  launchUrl(Uri.parse(""));
                                                                                },
                                                                                child: Image.network(
                                                                                  themeState is DarkTheme ? "https://firebasestorage.googleapis.com/v0/b/vikrant-portfolio-68806.appspot.com/o/ext_l.png?alt=media&token=4ae3da8e-2e01-4aad-a2d0-a09b4e363834" : "https://img.icons8.com/material-outlined/48/external-link.png",
                                                                                  height: 25.h,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15.h,
                                                                          ),
                                                                          Text(
                                                                            "I developed a Higher-Lower game in Flutter where players guess which of two TV shows has a higher IMDb rating. The game pulls data from an API that features the top 500 most famous TV shows, ensuring a dynamic and engaging experience. With an intuitive user interface and real-time feedback, players enjoy seamless gameplay while tracking their scores.",
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15.h,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: AppFonts.poppins,
                                                                              color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : VisibilityDetector(
                                                          key: const Key(
                                                              "tawkDemo"),
                                                          onVisibilityChanged:
                                                              (info) {
                                                            visibilityValueThree
                                                                    .value =
                                                                info.visibleFraction;
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    ValueListenableBuilder(
                                                                  valueListenable:
                                                                      visibilityValueThree,
                                                                  builder:
                                                                      (context,
                                                                          value,
                                                                          child) {
                                                                    return Opacity(
                                                                      opacity:
                                                                          visibilityValueThree
                                                                              .value,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              FittedBox(
                                                                                child: Text(
                                                                                  "ChatBot using Tawk",
                                                                                  style: TextStyle(
                                                                                    height: 0.8,
                                                                                    fontSize: 30.h,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                  textAlign: TextAlign.left,
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 5.h,
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  launchUrl(Uri.parse("https://github.com/vsc9729/tawk-poc"));
                                                                                },
                                                                                child: Image.network(
                                                                                  themeState is DarkTheme ? "https://firebasestorage.googleapis.com/v0/b/vikrant-portfolio-68806.appspot.com/o/ext_l.png?alt=media&token=4ae3da8e-2e01-4aad-a2d0-a09b4e363834" : "https://img.icons8.com/material-outlined/48/external-link.png",
                                                                                  height: 25.h,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15.h,
                                                                          ),
                                                                          Text(
                                                                            "I developed a chatbot using Tawk.to, a popular chatbot service. The chatbot is integrated into the website/app and provides real-time customer support. The chatbot is highly customizable and can be tailored to suit the needs of the business. The chatbot is easy to use and provides a seamless experience for customers.",
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 15.h,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: AppFonts.poppins,
                                                                              color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.5),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: index == 0
                                                ? Center(
                                                    child: VisibilityDetector(
                                                      key: const Key(
                                                          "projectImageOne"),
                                                      onVisibilityChanged:
                                                          (info) {
                                                        if (info.visibleFraction >
                                                            0.3) {
                                                          firstAnimationController!
                                                              .forward();
                                                        } else {
                                                          firstAnimationController!
                                                              .reverse();
                                                        }
                                                      },
                                                      child: AnimatedBuilder(
                                                        animation:
                                                            firstAnimationController!,
                                                        builder:
                                                            (context, child) {
                                                          return Opacity(
                                                            opacity:
                                                                firstAnimationController!
                                                                    .value,
                                                            child: child,
                                                          );
                                                        },
                                                        child: Transform(
                                                          alignment:
                                                              FractionalOffset
                                                                  .center,
                                                          transform:
                                                              Matrix4.identity()
                                                                ..scale(
                                                                    1.35, 1.35)
                                                                ..translate(
                                                                    0.0, 55.h),
                                                          child: Image.network(
                                                            themeState
                                                                    is DarkTheme
                                                                ? CommonImageAssets
                                                                    .portfolioDark
                                                                : CommonImageAssets
                                                                    .portfolioLight,
                                                            height: 1350.h,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : index == 1
                                                    ? Center(
                                                        child:
                                                            VisibilityDetector(
                                                          key: const Key(
                                                              "projectImageTwo"),
                                                          onVisibilityChanged:
                                                              (info) {
                                                            if (info.visibleFraction >
                                                                0.3) {
                                                              secondAnimationController!
                                                                  .forward();
                                                            } else {
                                                              secondAnimationController!
                                                                  .reverse();
                                                            }
                                                          },
                                                          child:
                                                              AnimatedBuilder(
                                                            animation:
                                                                secondAnimationController!,
                                                            builder: (context,
                                                                child) {
                                                              return Opacity(
                                                                opacity:
                                                                    secondAnimationController!
                                                                        .value,
                                                                child: child,
                                                              );
                                                            },
                                                            child: Transform(
                                                              alignment:
                                                                  FractionalOffset
                                                                      .center,
                                                              transform: Matrix4
                                                                  .identity()
                                                                ..scale(
                                                                    1.35, 1.35)
                                                                ..translate(
                                                                    0.0, 55.h),
                                                              child:
                                                                  Image.network(
                                                                themeState
                                                                        is DarkTheme
                                                                    ? CommonImageAssets
                                                                        .highLowGameDemoDark
                                                                    : CommonImageAssets
                                                                        .highLowGameDemoLight,
                                                                height: 1350.h,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Center(
                                                        child:
                                                            VisibilityDetector(
                                                          key: const Key(
                                                              "projectImageThree"),
                                                          onVisibilityChanged:
                                                              (info) {
                                                            if (info.visibleFraction >=
                                                                0.3) {
                                                              thirdAnimationController!
                                                                  .forward();
                                                            } else {
                                                              thirdAnimationController!
                                                                  .reverse();
                                                            }
                                                          },
                                                          child:
                                                              AnimatedBuilder(
                                                            animation:
                                                                thirdAnimationController!,
                                                            builder: (context,
                                                                child) {
                                                              return Opacity(
                                                                  opacity:
                                                                      thirdAnimationController!
                                                                          .value,
                                                                  child: child);
                                                            },
                                                            child: Transform(
                                                              alignment:
                                                                  FractionalOffset
                                                                      .center,
                                                              transform: Matrix4
                                                                  .identity()
                                                                ..scale(
                                                                    1.35, 1.35)
                                                                ..translate(
                                                                    0.0, 55.h),
                                                              child:
                                                                  Image.network(
                                                                themeState
                                                                        is DarkTheme
                                                                    ? CommonImageAssets
                                                                        .tawkDemoDark
                                                                    : CommonImageAssets
                                                                        .tawkDemoLight,
                                                                height: 1350.h,
                                                              ),
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
                              );
                            }
                          });
                        },
                      ),
                    );
                  }),
            );
          }),
    );
  }
}
