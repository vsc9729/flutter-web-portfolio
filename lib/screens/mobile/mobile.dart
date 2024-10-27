import 'package:portfolio/imports.dart';

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
                                            : 0.0))),
                                    MediaQuery.of(context).orientation ==
                                            Orientation.landscape
                                        ? 55.sp
                                        : 0.0),
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
                                : 0.0),
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
                        child: Image.network(
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

















