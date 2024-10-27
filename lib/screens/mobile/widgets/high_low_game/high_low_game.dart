import 'package:portfolio/imports.dart';
import 'package:video_player/video_player.dart';

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
                      ..translate(0.0, -animationController.value),
                    child: Opacity(
                        opacity: 1 - (-(animationController.value / 100)),
                        child: child),
                  );
                },
                child: Image.network(
                  CommonImageAssets.gameStart,
                  height: 280.h,
                ),
              ),
              Center(
                child: Image.network(
                  CommonImageAssets.gameRatingTitle,
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
                                      AppStrings.play,
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
                        
                          } else {
                            return Transform(
                              transform: Matrix4.identity()
                                ..translate(0.0, -70.h),
                              child: LottieBuilder.network(
                                CommonLottieAssets.highLowGameLoading,
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