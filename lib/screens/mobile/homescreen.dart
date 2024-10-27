import 'package:portfolio/imports.dart';

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
                  horizontal: 15.h,
                  vertical: 15.h,
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
                                      AppStrings.youtube));
                                },
                                child: Container(
                                  height: 50.h,
                                  width: 50.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Center(
                                    child: SvgPicture.network(
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
                                  child: SvgPicture.network(
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
                                  child: SvgPicture.network(
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
                                  child: SvgPicture.network(
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
                                ..translate(0.0, -animationController.value),
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
                                  AppStrings.cameraText,
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
                                  AppStrings.gallery,
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
                                  AppStrings.portfolio,
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
                                      child: Image.network(
                                        CommonImageAssets.tawkSiteLogo,
                                        height: 27.6.h,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 2.sp,
                                ),
                                Text(
                                  AppStrings.twak,
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
                                    },
                                    child: Container(
                                      height: 50.h,
                                      width: 50.h,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.network(
                                          CommonImageAssets.highLowGameMenuIcon,
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
                                  AppStrings.highLow,
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