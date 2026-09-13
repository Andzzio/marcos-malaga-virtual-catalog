import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AppVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final BoxFit fit;
  final bool autoPlay;

  const AppVideoPlayer({
    super.key,
    required this.videoUrl,
    this.fit = BoxFit.cover,
    this.autoPlay = true,
  });

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  @override
  void didUpdateWidget(covariant AppVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller?.dispose();
      _isInitialized = false;
      _hasError = false;
      _initializeVideo();
    } else if (oldWidget.autoPlay != widget.autoPlay &&
        _controller != null &&
        _isInitialized) {
      if (widget.autoPlay) {
        _controller!.play();
      } else {
        _controller!.pause();
      }
    }
  }

  void _initializeVideo() {
    if (widget.videoUrl.isEmpty) {
      setState(() => _hasError = true);
      return;
    }

    try {
      final uri = Uri.parse(widget.videoUrl);
      final controller = VideoPlayerController.networkUrl(uri);
      _controller = controller;

      controller
        ..setLooping(true)
        ..setVolume(0.0) // Silenciado obligatorio para autoplay en Web y Móvil
        ..initialize().then((_) {
          if (mounted && _controller == controller) {
            setState(() => _isInitialized = true);
            if (widget.autoPlay) {
              controller.play();
            } else {
              controller.pause();
            }
          }
        }).catchError((_) {
          if (mounted && _controller == controller) {
            setState(() => _hasError = true);
          }
        });
    } catch (_) {
      setState(() => _hasError = true);
    }
  }


  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: const Icon(Icons.videocam_off, color: Colors.grey, size: 36),
      );
    }

    final controller = _controller;
    if (!_isInitialized || controller == null) {
      return Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return FittedBox(
      fit: widget.fit,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: controller.value.size.width,
        height: controller.value.size.height,
        child: VideoPlayer(controller),
      ),
    );
  }
}
