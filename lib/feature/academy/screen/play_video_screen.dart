import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../model/training_tutorial_model.dart';

class PlayVideoScreen extends StatefulWidget {
  final String name;
  final List<TutorialVideo> videoList;

  const PlayVideoScreen({
    super.key,
    required this.name,
    required this.videoList,
  });

  @override
  State<PlayVideoScreen> createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayVideoScreen> {
  int selectedIndex = 0;
  YoutubePlayerController? _youtubeController;
  bool _isFullScreen = false;

  double _currentScale = 1.0;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    loadVideo();
  }

  void loadVideo() {
    final currentVideo = widget.videoList[selectedIndex];
    final videoId = YoutubePlayer.convertUrlToId(currentVideo.videoUrl) ?? '';
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
      ),
    )..addListener(_youtubeListener);
  }

  void _youtubeListener() {
    if (_youtubeController!.value.isFullScreen != _isFullScreen) {
      setState(() {
        _isFullScreen = _youtubeController!.value.isFullScreen;
      });
      if (_isFullScreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    }
  }

  void changeVideo(int index) {
    setState(() {
      selectedIndex = index;
      _currentScale = 1.0;
      _isZoomed = false;
    });
    final newVideoId =
        YoutubePlayer.convertUrlToId(widget.videoList[index].videoUrl) ?? '';
    _youtubeController?.load(newVideoId);
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedVideo = widget.videoList[selectedIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isFullScreen ? null : CustomAppBar(title: widget.name, showBackButton: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_youtubeController != null)
            Expanded(
              child: GestureDetector(
                onScaleStart: (details) {
                  setState(() {
                    _isZoomed = true;
                  });
                },
                onScaleUpdate: (details) {
                  if (details.scale > 1.0) {
                    setState(() {
                      _currentScale = details.scale.clamp(1.0, 5.0);
                    });
                  } else {
                    setState(() {
                      _isZoomed = false;
                      _currentScale = 1.0;
                    });
                  }
                },
                onScaleEnd: (details) {
                  if (_currentScale <= 1.0) {
                    setState(() {
                      _isZoomed = false;
                      _currentScale = 1.0;
                    });
                  }
                },
                child: FractionallySizedBox(
                  widthFactor: 1 / _currentScale,
                  child: Transform.scale(
                    scale: _currentScale,
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (!_isFullScreen && !_isZoomed) ...[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedVideo.videoName,
                    style: textStyle14(context),
                  ),
                  Text(
                    selectedVideo.videoDescription,
                    style: textStyle14(context, fontWeight: FontWeight.w400),
                  ),
                  const Divider(),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: ListView.builder(
                itemCount: widget.videoList.length,
                itemBuilder: (context, index) {
                  final video = widget.videoList[index];
                  final isSelected = selectedIndex == index;

                  return CustomContainer(
                    border: true,
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                    padding: EdgeInsets.zero,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomContainer(
                                border: true,
                                height: 90,
                                width: 150,
                                networkImg: video.videoImageUrl,
                                margin: EdgeInsets.zero,
                              ),
                              10.width,
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    5.height,
                                    Text(video.videoName, style: textStyle14(context)),
                                    Text(
                                      video.videoDescription,
                                      style: textStyle14(
                                        context,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.only(right: 20),
                          child: Icon(
                            isSelected ? Icons.pause_circle : Icons.play_circle,
                            size: 30,
                            color: isSelected ? CustomColor.descriptionColor.withOpacity(0.5) : CustomColor.appColor,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => changeVideo(index),
                  );
                },
              ),
            ),
          ]
        ],
      ),
    );
  }
}
