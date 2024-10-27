import 'package:portfolio/imports.dart';
import 'package:video_player/video_player.dart';

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
                child: Image.network(
                  CommonImageAssets.gameOver,
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
                    "${AppStrings.score}${_seriesGameBloc.score}",
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
                    "${AppStrings.highScore}${_seriesGameBloc.highScore}",
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
                        AppStrings.restart,
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
