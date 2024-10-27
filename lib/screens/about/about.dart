import 'package:portfolio/imports.dart';

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
                      AppStrings.aboutME,
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
              SizedBox(
                height: 12.h,
              ),
              Text(
                AppStrings.position,
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
                    AppStrings.companyName,
                    style: TextStyle(
                      fontSize: 20.h,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(
                    width: 5.sp,
                  ),
                  Image.network(
                    AppStrings.companyLogo,
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
              text: AppStrings.desc,
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
              text: AppStrings.desc2,
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
              text: AppStrings.desc3,
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
              text: AppStrings.desc4,
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
                          AppStrings.companyLink,
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
                                AppStrings.companyLinkText,
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
              text: AppStrings.desc5,
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
              text: AppStrings.desc6,
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
              text: AppStrings.desc7,
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
                text: AppStrings.desc8,
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
                        AppStrings.linkedIn,
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
                launchUrl(Uri.parse(AppStrings.resume));
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
                      AppStrings.resumeText,
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


