import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dart:html' as html;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/bloc/navigation/navigation_bloc.dart';
import 'package:portfolio/constants/common_assets.dart';
import 'package:portfolio/main.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  final ValueNotifier<bool> isTranslated = ValueNotifier<bool>(false);
  final ValueNotifier<double> page = ValueNotifier<double>(0.0);
  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      if (widget.pageController.page! <= 1) {
        page.value = widget.pageController.page!;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PopScope(
        canPop: false,
        onPopInvoked: (_) {
          BlocProvider.of<NavigationBloc>(context).add(HomePageEvent());
        },
        child: Row(
          children: [
            const Spacer(),
            Expanded(
              flex: MediaQuery.of(context).orientation == Orientation.landscape
                  ? 3
                  : 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Expanded(
                    flex: 8,
                    child: ValueListenableBuilder(
                      valueListenable: page,
                      builder: (context, value, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Transform(
                              transform: Matrix4.identity()
                                ..translate(
                                  (page.value - 1) * 500,
                                ),
                              child: Opacity(
                                opacity: page.value <= 1 ? (page.value) : 1,
                                child: Text(
                                  'About',
                                  style: TextStyle(
                                    fontSize: scaleText(120.sp, context),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Transform(
                              transform: Matrix4.identity()
                                ..translate(
                                  (page.value - 1) * 500,
                                ),
                              child: Opacity(
                                opacity: page.value <= 1 ? (page.value) : 1,
                                child: Divider(
                                  color: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .color!
                                      .withOpacity(0.4),
                                  thickness: 2,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Transform(
                                      transform: Matrix4.identity()
                                        ..translate(
                                          (page.value - 1) * 500,
                                        ),
                                      child: Opacity(
                                        opacity:
                                            page.value <= 1 ? (page.value) : 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: MediaQuery.of(context)
                                                          .orientation ==
                                                      Orientation.landscape
                                                  ? 95.h
                                                  : 50.h,
                                              backgroundColor:
                                                  Colors.transparent,
                                              backgroundImage: const AssetImage(
                                                CommonImageAssets.profileImage,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12.h,
                                            ),
                                            Text(
                                              'Vikrant Singh',
                                              style: TextStyle(
                                                fontSize:
                                                    scaleText(45.sp, context),
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12.h,
                                            ),
                                            Text(
                                              'Software Engineer 2',
                                              style: TextStyle(
                                                fontSize:
                                                    scaleText(30.sp, context),
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 7.5.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'GeekyAnts',
                                                  style: TextStyle(
                                                    fontSize: scaleText(
                                                        30.sp, context),
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.sp,
                                                ),
                                                Image.network(
                                                  "https://cdn-images-1.medium.com/max/1200/1*rSGF7OBUjv3Ac2kP_cSjtA.png",
                                                  height: scaleText(
                                                      MediaQuery.of(context)
                                                                  .orientation ==
                                                              Orientation
                                                                  .landscape
                                                          ? 34.sp
                                                          : 40.sp,
                                                      context),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: SizedBox(
                                      height: double.maxFinite,
                                      child: ValueListenableBuilder(
                                        valueListenable: page,
                                        builder: (context, value, child) {
                                          return Transform(
                                            transform: Matrix4.identity()
                                              ..translate(
                                                -((page.value - 1) * 500),
                                              ),
                                            child: Opacity(
                                              opacity: page.value <= 1
                                                  ? (page.value)
                                                  : 1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    textAlign: TextAlign.left,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'A software engineer who aims to evolve, innovate, and inspire through technology.\n',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .displaySmall!
                                                                  .copyWith(
                                                                    fontSize: scaleText(
                                                                        MediaQuery.of(context).orientation ==
                                                                                Orientation.landscape
                                                                            ? 34.sp
                                                                            : 40.sp,
                                                                        context),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .displaySmall!
                                                                        .color!
                                                                        .withOpacity(
                                                                            0.7),
                                                                  ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '\nCurrently, I am working as a ',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .displaySmall!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize: scaleText(
                                                                        MediaQuery.of(context).orientation ==
                                                                                Orientation.landscape
                                                                            ? 34.sp
                                                                            : 40.sp,
                                                                        context),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .displaySmall!
                                                                        .color!
                                                                        .withOpacity(
                                                                            0.7),
                                                                  ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              'Software Engineer',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .displaySmall!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: scaleText(
                                                                        MediaQuery.of(context).orientation ==
                                                                                Orientation.landscape
                                                                            ? 34.sp
                                                                            : 40.sp,
                                                                        context),
                                                                  ),
                                                        ),
                                                        TextSpan(
                                                          text: ' at ',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .displaySmall!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize: scaleText(
                                                                        MediaQuery.of(context).orientation ==
                                                                                Orientation.landscape
                                                                            ? 34.sp
                                                                            : 40.sp,
                                                                        context),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .displaySmall!
                                                                        .color!
                                                                        .withOpacity(
                                                                            0.7),
                                                                  ),
                                                        ),
                                                        TextSpan(children: [
                                                          WidgetSpan(
                                                            child: MouseRegion(
                                                              cursor:
                                                                  SystemMouseCursors
                                                                      .click,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  launchUrl(
                                                                    Uri.parse(
                                                                      'https://geekyants.com/',
                                                                    ),
                                                                  );
                                                                },
                                                                child: SizedBox(
                                                                  width: 180.h,
                                                                  height: scaleText(
                                                                      MediaQuery.of(context).orientation ==
                                                                              Orientation.landscape
                                                                          ? 40.sp
                                                                          : 50.sp,
                                                                      context),
                                                                  child: Center(
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.centerLeft,
                                                                          child:
                                                                              Text(
                                                                            'GeekyAnts Pvt. Ltd.',
                                                                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  fontSize: scaleText(MediaQuery.of(context).orientation == Orientation.landscape ? 34.sp : 40.sp, context),
                                                                                ),
                                                                          ),
                                                                        ),
                                                                        Transform
                                                                            .translate(
                                                                          offset: Offset(
                                                                              0.0,
                                                                              6.0.h),
                                                                          child:
                                                                              LottieBuilder.asset(
                                                                            "assets/lottie/red_underline.json",
                                                                            repeat:
                                                                                false,
                                                                            frameRate:
                                                                                FrameRate.max,
                                                                            height:
                                                                                100.h,
                                                                            // width: 180.h,
                                                                            // width: (MediaQuery.of(context)
                                                                            //             .orientation ==
                                                                            //         Orientation.landscape
                                                                            //     ? 190.sp
                                                                            //     : 800.sp),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            child: SizedBox(
                                                              height: 10.h,
                                                              width: double
                                                                  .maxFinite,
                                                            ),
                                                          )
                                                        ]),
                                                        TextSpan(
                                                          text:
                                                              "\nDuring my tenure, I've had the opportunity to contribute to a diverse range of projects, each presenting unique challenges and opportunities for growth.\n",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .displaySmall!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize: scaleText(
                                                                        MediaQuery.of(context).orientation ==
                                                                                Orientation.landscape
                                                                            ? 34.sp
                                                                            : 40.sp,
                                                                        context),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .displaySmall!
                                                                        .color!
                                                                        .withOpacity(
                                                                            0.7),
                                                                  ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              "\nOne notable project I've worked on is a cutting-edge dating app tailored for ",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .displaySmall!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize: scaleText(
                                                                        MediaQuery.of(context).orientation ==
                                                                                Orientation.landscape
                                                                            ? 34.sp
                                                                            : 40.sp,
                                                                        context),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .displaySmall!
                                                                        .color!
                                                                        .withOpacity(
                                                                            0.7),
                                                                  ),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              "users in Germany. Collaborating closely with the team, I played a key role in architecting and developing features that enhance user experience and engagement.\n",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .displaySmall!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontSize: scaleText(
                                                                        MediaQuery.of(context).orientation ==
                                                                                Orientation.landscape
                                                                            ? 34.sp
                                                                            : 40.sp,
                                                                        context),
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .displaySmall!
                                                                        .color!
                                                                        .withOpacity(
                                                                            0.7),
                                                                  ),
                                                        ),
                                                        TextSpan(
                                                            text:
                                                                "\nAdditionally, I've had the privilege to contribute to a healthcare app developed for the Tata Group. This experience allowed me to delve into the complexities of healthcare technology, where I applied my technical prowess to create solutions that prioritize user privacy, security, and seamless functionality.\n",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displaySmall!
                                                                .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontSize: scaleText(
                                                                      MediaQuery.of(context).orientation ==
                                                                              Orientation.landscape
                                                                          ? 34.sp
                                                                          : 40.sp,
                                                                      context),
                                                                  color: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .displaySmall!
                                                                      .color!
                                                                      .withOpacity(
                                                                          0.7),
                                                                ),
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    launchUrl(
                                                                      Uri.parse(
                                                                        'https://www.linkedin.com/in/vikrant-singh-7b1b3b1a4/',
                                                                      ),
                                                                    );
                                                                  })
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30.h,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      html.window.open(
                                                        "assets/resume/vikrant_singh.pdf",
                                                        "vikrant_singh.pdf",
                                                      );
                                                    },
                                                    child: Container(
                                                      height: MediaQuery.of(
                                                                      context)
                                                                  .orientation ==
                                                              Orientation
                                                                  .landscape
                                                          ? 50.h
                                                          : 35.h,
                                                      width: MediaQuery.of(
                                                                      context)
                                                                  .orientation ==
                                                              Orientation
                                                                  .landscape
                                                          ? 150.h
                                                          : 105.h,
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Stack(
                                                        fit: StackFit
                                                            .passthrough,
                                                        children: [
                                                          Container(
                                                            height: MediaQuery.of(
                                                                            context)
                                                                        .orientation ==
                                                                    Orientation
                                                                        .landscape
                                                                ? 50.h
                                                                : 35.h,
                                                            width: MediaQuery.of(
                                                                            context)
                                                                        .orientation ==
                                                                    Orientation
                                                                        .landscape
                                                                ? 150.h
                                                                : 105.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.amber,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'Resume',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      scaleText(
                                                                          32.sp,
                                                                          context),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          MouseRegion(
                                                            // onHover: (event) {
                                                            //   isTranslated.value = true;
                                                            // },
                                                            onEnter: (event) {
                                                              isTranslated
                                                                  .value = true;
                                                            },
                                                            onExit: (event) {
                                                              isTranslated
                                                                      .value =
                                                                  false;
                                                            },
                                                            child:
                                                                ValueListenableBuilder(
                                                              valueListenable:
                                                                  isTranslated,
                                                              builder: (context,
                                                                  value,
                                                                  child) {
                                                                return AnimatedContainer(
                                                                  // clipBehavior: Clip.hardEdge,
                                                                  duration:
                                                                      const Duration(
                                                                    milliseconds:
                                                                        400,
                                                                  ),
                                                                  transform: Matrix4
                                                                      .translationValues(
                                                                    0.0,
                                                                    isTranslated
                                                                            .value
                                                                        ? 50.0
                                                                        : 0.0, // Translate vertically by 150 pixels
                                                                    0.0,
                                                                  ),
                                                                  curve: Curves
                                                                      .ease,
                                                                  height: MediaQuery.of(context)
                                                                              .orientation ==
                                                                          Orientation
                                                                              .landscape
                                                                      ? 50.h
                                                                      : 35.h,
                                                                  width: MediaQuery.of(context)
                                                                              .orientation ==
                                                                          Orientation
                                                                              .landscape
                                                                      ? 150.h
                                                                      : 105.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .displaySmall!
                                                                        .color!,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            4.r),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Resume',
                                                                      style: TextStyle(
                                                                          fontSize: scaleText(
                                                                              32
                                                                                  .sp,
                                                                              context),
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.amber),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 40.h,
                                                  ),
                                                  Wrap(
                                                    spacing: 15.r,
                                                    runSpacing: 10.r,
                                                    children: const [
                                                      SkillTile(
                                                        tileColor:
                                                            Color(0xff00ADD8),
                                                        tileText: "Flutter",
                                                      ),
                                                      SkillTile(
                                                        tileColor:
                                                            Color(0xff234A84),
                                                        tileText: "BLoC",
                                                      ),
                                                      SkillTile(
                                                        tileColor:
                                                            Color(0xff61DAF6),
                                                        tileText: "Dart",
                                                      ),
                                                      SkillTile(
                                                        tileColor:
                                                            Color(0xffFF9900),
                                                        tileText: "GraphQL",
                                                      ),
                                                      SkillTile(
                                                        tileColor:
                                                            Color(0xff4285F4),
                                                        tileText: "Android",
                                                      ),
                                                      SkillTile(
                                                        tileColor:
                                                            Color(0xff326CE5),
                                                        tileText: "iOS",
                                                      ),
                                                      SkillTile(
                                                        tileColor:
                                                            Color(0xff0DB7ED),
                                                        tileText:
                                                            "API Integration",
                                                      ),
                                                      SkillTile(
                                                        tileColor:
                                                            Color(0xff7B42BC),
                                                        tileText: "CI/CD",
                                                      ),
                                                      SkillTile(
                                                        tileColor:
                                                            Color(0xff199BFC),
                                                        tileText: "Provider",
                                                      ),
                                                      SkillTile(
                                                        tileColor:
                                                            Color(0xffD82C20),
                                                        tileText: "Firebase",
                                                      ),
                                                      SkillTile(
                                                        tileColor:
                                                            Color(0xffE535AB),
                                                        tileText: "Git",
                                                      ),
                                                      SkillTile(
                                                        tileColor:
                                                            Color(0xff68A063),
                                                        tileText: "MVVM",
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class SkillTile extends StatelessWidget {
  final Color tileColor;
  final String tileText;
  const SkillTile({
    super.key,
    required this.tileColor,
    required this.tileText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tileColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal:
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? 16.sp
                  : 32.sp,
          vertical: MediaQuery.of(context).orientation == Orientation.landscape
              ? 6.sp
              : 12.sp,
        ),
        child: Text(
          tileText,
          style: TextStyle(
            fontSize:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 15.sp
                    : 45.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
