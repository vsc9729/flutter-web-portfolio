import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:neopop/widgets/buttons/neopop_button/neopop_button.dart';
import 'package:portfolio/bloc/theme/theme_bloc.dart';
import 'package:portfolio/constants/common_assets.dart';
import 'package:portfolio/main.dart';
import 'package:portfolio/screens/about/widgets/skill_tile.dart';
import 'package:portfolio/theme/index.dart';
import 'package:portfolio/utils/common_util.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({super.key, required this.pageController});
  final PageController pageController;

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  final ValueNotifier<bool> isTranslated = ValueNotifier<bool>(false);
  final ValueNotifier<double> page = ValueNotifier<double>(-500);
  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      print("page.value${page.value}");
      page.value = (widget.pageController.page! - 1) * -500;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getAboutHeaderWidgets(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 135.h,
                      backgroundColor:
                          Theme.of(context).textTheme.displayMedium!.color!,
                      child: Center(
                        child: CircleAvatar(
                          radius: 132.5.h,
                          backgroundImage: const NetworkImage(
                            CommonImageAssets.profileImageZoomed,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40.w,
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "About Me",
                      style: TextStyle(
                        fontSize: 70.h,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Column(
            children: [
              CircleAvatar(
                radius: 95.h,
                backgroundColor:
                    Theme.of(context).textTheme.displayMedium!.color!,
                child: Center(
                  child: CircleAvatar(
                    radius: 92.5.h,
                    backgroundImage: const NetworkImage(
                      CommonImageAssets.profileImageZoomed,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 22.h,
              // ),
              // Text(
              //   'About Me',
              //   style: TextStyle(
              //     fontSize: 40.h,
              //     fontWeight: FontWeight.w800,
              //   ),
              // ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                'Software Engineer 2',
                style: TextStyle(
                  fontSize: 20.h,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: 7.5.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'GeekyAnts',
                    style: TextStyle(
                      fontSize: 20.h,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  Image.network(
                    "https://cdn-images-1.medium.com/max/1200/1*rSGF7OBUjv3Ac2kP_cSjtA.png",
                    height: 23.h,
                  ),
                ],
              ),
              SizedBox(
                height: 7.5.h,
              ),
            ],
          );
  }

  Widget getSideWidgets(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              themeState is DarkTheme
                  ? CommonImageAssets.expDark
                  : CommonImageAssets.expLight,
              height: 350.h,
            ),
            SizedBox(
              height: 12.h,
            ),
            Image.network(
              themeState is DarkTheme
                  ? CommonImageAssets.eduDark
                  : CommonImageAssets.eduLight,
              height: 140.h,
            ),
          ],
        );
      },
    );
  }

  List<Widget> getAboutBodyWidget() {
    return [
      RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: [
            TextSpan(
              text:
                  'A software engineer who aims to evolve, innovate, and inspire through technology.\n',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: CommonUtil.scaleText(
                        MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 34.sp
                            : 42.sp,
                        context),
                    fontWeight: FontWeight.w400,
                    fontFamily: AppFonts.poppins,
                    color: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .color!
                        .withOpacity(0.7),
                  ),
            ),
            TextSpan(
              text: '\nCurrently, I am working as a ',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w400,
                    fontSize: CommonUtil.scaleText(
                        MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 34.sp
                            : 42.sp,
                        context),
                    color: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .color!
                        .withOpacity(0.7),
                  ),
            ),
            TextSpan(
              text: 'Software Engineer',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w600,
                    fontSize: CommonUtil.scaleText(
                        MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 34.sp
                            : 42.sp,
                        context),
                  ),
            ),
            TextSpan(
              text: ' at ',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w400,
                    fontSize: CommonUtil.scaleText(
                        MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 34.sp
                            : 42.sp,
                        context),
                    color: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .color!
                        .withOpacity(0.7),
                  ),
            ),
            TextSpan(children: [
              WidgetSpan(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      launchUrl(
                        Uri.parse(
                          'https://geekyants.com/',
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 280.h,
                      height: CommonUtil.scaleText(
                          MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 40.sp
                              : 55.sp,
                          context),
                      child: Center(
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'GeekyAnts Pvt. Ltd.',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppFonts.poppins,
                                      fontSize: CommonUtil.scaleText(
                                          MediaQuery.of(context).orientation ==
                                                  Orientation.landscape
                                              ? 34.sp
                                              : 42.sp,
                                          context),
                                    ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(0.0, 6.0.h),
                              child: LottieBuilder.network(
                                CommonLottieAssets.redUnderline,
                                repeat: false,
                                frameRate: FrameRate.max,
                                height: 100.h,
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
                  width: double.maxFinite,
                ),
              )
            ]),
            TextSpan(
              text:
                  "\nDuring my tenure, I've had the opportunity to contribute to a diverse range of projects, each presenting unique challenges and opportunities for growth.\n",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w400,
                    fontSize: CommonUtil.scaleText(
                        MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 34.sp
                            : 42.sp,
                        context),
                    color: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .color!
                        .withOpacity(0.7),
                  ),
            ),
            TextSpan(
              text:
                  "\nOne notable project I've worked on is a cutting-edge dating app tailored for ",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w400,
                    fontSize: CommonUtil.scaleText(
                        MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 34.sp
                            : 42.sp,
                        context),
                    color: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .color!
                        .withOpacity(0.7),
                  ),
            ),
            TextSpan(
              text:
                  "users in Germany. Collaborating closely with the team, I played a key role in architecting and developing features that enhance user experience and engagement.\n",
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w400,
                    fontSize: CommonUtil.scaleText(
                        MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 34.sp
                            : 42.sp,
                        context),
                    color: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .color!
                        .withOpacity(0.7),
                  ),
            ),
            TextSpan(
                text:
                    "\nAdditionally, I've had the privilege to contribute to a healthcare app developed for the Tata Group. This experience allowed me to delve into the complexities of healthcare technology, where I applied my technical prowess to create solutions that prioritize user privacy, security, and seamless functionality.\n",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.w400,
                      fontSize: CommonUtil.scaleText(
                          MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 34.sp
                              : 42.sp,
                          context),
                      color: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .color!
                          .withOpacity(0.7),
                    ),
                recognizer: TapGestureRecognizer()
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
        height: 10.h,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 40.h,
            width: 150.h,
            child: NeoPopButton(
              color: Theme.of(context).textTheme.displaySmall!.color!,
              onTapUp: () {
                launchUrl(Uri.parse(
                    "https://drive.google.com/file/d/1ppC4Mny_V5CIai3Pkce0KmPgzx4XdgO1/view?usp=drive_link"));
              },
              rightShadowColor: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .color!
                  .withOpacity(0.5),
              bottomShadowColor: Colors.black.withOpacity(0.5),
              animationDuration: const Duration(milliseconds: 200),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Resume",
                      style: TextStyle(
                        fontSize: 15.h,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Icon(
                      Icons.download,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      size: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(
        height: 40.h,
      ),
      const BottomSkillsRow(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Center(
            child: ValueListenableBuilder(
                valueListenable: page,
                builder: (context, value, child) {
                  return Transform(
                    transform: Matrix4.identity()..translate(-page.value),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? SizedBox(
                                width: 200.w,
                              )
                            : const Spacer(),
                        Expanded(
                          flex: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? 3
                              : 20,
                          child: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getAboutHeaderWidgets(context),
                                      SizedBox(
                                        height: 40.h,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  getSideWidgets(context)
                                                ]),
                                          ),
                                          SizedBox(
                                            width: 40.w,
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: getAboutBodyWidget(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    getAboutHeaderWidgets(context),
                                    ...getAboutBodyWidget(),
                                  ],
                                ),
                        ),
                        MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? SizedBox(
                                width: 200.w,
                              )
                            : const Spacer(),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class BottomSkillsRow extends StatelessWidget {
  const BottomSkillsRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 15.r,
        runSpacing: 10.r,
        children: const [
          SkillTile(
            tileColor: Color(0xff00ADD8),
            tileText: "Flutter",
          ),
          SkillTile(
            tileColor: Color(0xff234A84),
            tileText: "BLoC",
          ),
          SkillTile(
            tileColor: Color(0xff61DAF6),
            tileText: "Dart",
          ),
          SkillTile(
            tileColor: Color(0xffFF9900),
            tileText: "GraphQL",
          ),
          SkillTile(
            tileColor: Color(0xff4285F4),
            tileText: "Android",
          ),
          SkillTile(
            tileColor: Color(0xff326CE5),
            tileText: "iOS",
          ),
          SkillTile(
            tileColor: Color(0xff0DB7ED),
            tileText: "API Integration",
          ),
          SkillTile(
            tileColor: Color(0xff7B42BC),
            tileText: "CI/CD",
          ),
          SkillTile(
            tileColor: Color(0xff199BFC),
            tileText: "Provider",
          ),
          SkillTile(
            tileColor: Color(0xffD82C20),
            tileText: "Firebase",
          ),
          SkillTile(
            tileColor: Color(0xffE535AB),
            tileText: "Git",
          ),
          SkillTile(
            tileColor: Color(0xff68A063),
            tileText: "MVVM",
          ),
        ],
      ),
    );
  }
}
