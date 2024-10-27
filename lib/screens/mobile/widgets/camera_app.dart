import 'package:portfolio/imports.dart';

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
          child: DeferPointer(
            child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  keyTwo.currentState!.pop();
                }),
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