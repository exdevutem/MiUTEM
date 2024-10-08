import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BackgroundVideo extends StatefulWidget {
  final Widget child;

  const BackgroundVideo({super.key, required this.child});

  @override
  State<BackgroundVideo> createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo> {

  late final VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.asset('assets/videos/login_bg.mp4',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true)
    )..setVolume(0)
      ..play()
      ..setLooping(true)
      ..initialize().then((value) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const backgroundDecoration = BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/login_bg.png'),
        fit: BoxFit.cover,
      )
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        const DecoratedBox(decoration: backgroundDecoration),
        ClipRect(
          child: OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            alignment: Alignment.center,
            child: Container(
              decoration: backgroundDecoration,
              width: _videoPlayerController.value.size.width,
              height: _videoPlayerController.value.size.height,
              child: VideoPlayer(_videoPlayerController),
            ),
          ),
        ),
        Container(color: const Color(0x80000000)),
        SizedBox(
          height: double.infinity,
          child: widget.child,
        ),
      ],
    );
  }
}

