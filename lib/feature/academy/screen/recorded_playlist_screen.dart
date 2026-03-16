import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../model/recorded_webinar_model.dart';

class RecordedPlaylistScreen extends StatefulWidget {
  final String name;
  final List<RecordedVideo> videoList;

  const RecordedPlaylistScreen({
    super.key,
    required this.name,
    required this.videoList,
  });

  @override
  _RecordedPlaylistScreenState createState() => _RecordedPlaylistScreenState();
}

class _RecordedPlaylistScreenState extends State<RecordedPlaylistScreen> {
  int selectedIndex = 0;

  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoController;

  bool _isYoutube = false;
  bool _isFullScreen = false;

  double _currentScale = 1.0;
  double _currentRotation = 0.0;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _loadVideo(selectedIndex);
  }

  @override
  void dispose() {
    _disposeControllers();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _disposeControllers() {
    _youtubeController?.removeListener(_youtubeListener);
    _youtubeController?.dispose();
    _youtubeController = null;

    _videoController?.pause();
    _videoController?.dispose();
    _videoController = null;
  }

  bool _isYoutubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  void _loadVideo(int index) async {
    _disposeControllers();

    final video = widget.videoList[index];
    final url = video.videoUrl.trim();
    _isYoutube = _isYoutubeUrl(url);

    if (_isYoutube) {
      final videoId = YoutubePlayer.convertUrlToId(url) ?? '';
      if (videoId.isEmpty) {
        debugPrint("Invalid YouTube URL: $url");
        return;
      }
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: false,
        ),
      )..addListener(_youtubeListener);
      setState(() {});
    } else {
      try {
        _videoController = VideoPlayerController.network(url);
        await _videoController!.initialize();
        _videoController!.play();
        setState(() {});
      } catch (e) {
        debugPrint("Video load failed: $e");
      }
    }

    setState(() {
      selectedIndex = index;
      _currentScale = 1.0;
      _currentRotation = 0.0;
      _isZoomed = false;
    });
  }

  void _youtubeListener() {
    if (_youtubeController == null) return;
    if (_youtubeController!.value.isFullScreen != _isFullScreen) {
      setState(() {
        _isFullScreen = _youtubeController!.value.isFullScreen;
      });

      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    }
  }

  Widget _buildVideoPlayer(RecordedVideo video) {
    if (_isYoutube && _youtubeController != null) {
      return _zoomablePlayer(
        AspectRatio(
          aspectRatio: 16 / 9,
          child: YoutubePlayer(
            controller: _youtubeController!,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.redAccent,
          ),
        ),
      );
    } else if (_videoController != null && _videoController!.value.isInitialized) {
      return _zoomablePlayer(
        AspectRatio(
          aspectRatio: _videoController!.value.aspectRatio,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: VideoPlayer(_videoController!),
          ),
        ),
      );
    } else {
      return _thumbnailPlaceholder(video);
    }
  }

  Widget _zoomablePlayer(Widget child) {
    return Center(
      child: GestureDetector(
        onScaleStart: (_) => setState(() => _isZoomed = true),
        onScaleUpdate: (details) {
          setState(() {
            _currentScale = details.scale.clamp(1.0, 5.0);
            _currentRotation = details.rotation;
          });
        },
        onScaleEnd: (_) {
          if (_currentScale <= 1.0) {
            setState(() {
              _isZoomed = false;
              _currentScale = 1.0;
              _currentRotation = 0.0;
            });
          }
        },
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..scale(_currentScale)
            ..rotateZ(_currentRotation),
          child: child,
        ),
      ),
    );
  }

  Widget _thumbnailPlaceholder(RecordedVideo video) {
    if (video.videoImageUrl != null && video.videoImageUrl!.isNotEmpty) {
      return GestureDetector(
        onTap: () => _loadVideo(widget.videoList.indexOf(video)),
        child: Container(
          height: 180,
          color: Colors.black12,
          child: Stack(
            children: [
              Image.network(
                video.videoImageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
              Center(
                child: Icon(Icons.play_circle_fill, size: 50, color: CustomColor.appColor),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: 180,
        color: Colors.black,
        child: Center(
          child: Icon(Icons.videocam_off, size: 50, color: Colors.grey),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.videoList.isEmpty) {
      return Scaffold(
        appBar: CustomAppBar(title: widget.name, showBackButton: true),
        body: Center(child: Text('Es Empty', style: textStyle16(context))),
      );
    }

    return Scaffold(
      appBar: _isFullScreen ? null : CustomAppBar(title: widget.name, showBackButton: true),
      body: ListView.builder(
        itemCount: widget.videoList.length,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemBuilder: (context, index) {
          final video = widget.videoList[index];
          final isSelected = index == selectedIndex;

          return CustomContainer(
            border: false,
            color: CustomColor.whiteColor,
            margin: const EdgeInsets.only(top: 10),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSelected)
                  _buildVideoPlayer(video)
                else
                  _thumbnailPlaceholder(video),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(video.videoName, style: textStyle12(context)),
                      Text(
                        video.videoDescription,
                        style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400,),overflow: TextOverflow.ellipsis,maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
