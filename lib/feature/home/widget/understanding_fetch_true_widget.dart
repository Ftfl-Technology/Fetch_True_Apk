import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../bloc/understanding_ft/understanding_fetch_true_bloc.dart';
import '../bloc/understanding_ft/understanding_fetch_true_event.dart';
import '../bloc/understanding_ft/understanding_fetch_true_state.dart';
import '../repository/understanding_fetch_true_repository.dart';

class UnderstandingFetchTrueWidget extends StatelessWidget {
  const UnderstandingFetchTrueWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocProvider(
      create: (_) => UnderstandingFetchTrueBloc(UnderstandingFetchTrueRepository())..add(LoadUnderstandingFetchTrue()),
      child: BlocBuilder<UnderstandingFetchTrueBloc, UnderstandingFetchTrueState>(
        builder: (context, state) {
          if (state is UnderstandingFetchTrueLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UnderstandingFetchTrueLoaded) {
            if (state.data.isEmpty) {
              return const Center(child: Text("No videos"));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.height,
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Understanding Fetch True', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color: Colors.black),),
                ),
                5.height,
                SizedBox(
                  height: dimensions.screenHeight * 0.25,
                  child: ListView.builder(
                    itemCount: state.data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = state.data[index];
                      return UnderstandingVideoCard(
                        videoUrl: item.videoUrl,
                        title: item.fullName,
                        coverImg: item.imageUrl,
                        des: item.description,
                      );
                    },
                  ),
                ),
                50.height,
              ],
            );
          } else if (state is UnderstandingFetchTrueError) {
            debugPrint('Understanding Fetch True Error ${state.message}');
            return SizedBox.shrink();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class UnderstandingVideoCard extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String des;
  final String coverImg;

  const UnderstandingVideoCard({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.des,
    required this.coverImg,
  });

  @override
  State<UnderstandingVideoCard> createState() => _UnderstandingVideoCardState();
}

class _UnderstandingVideoCardState extends State<UnderstandingVideoCard> {
  late String videoId;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? "";
  }

  void _openFullscreenPlayer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullscreenVideoPage(videoId: videoId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return SizedBox(
      width: dimensions.screenHeight * 0.4,
      child: CustomContainer(
        border: true,
        color: Colors.white,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _openFullscreenPlayer,
                child: ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network('${widget.coverImg}',
                        // YoutubePlayer.getThumbnail(videoId: videoId),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: textStyle12(context), overflow: TextOverflow.ellipsis, maxLines: 2,),
                  Text(widget.des, style: textStyle12(context, color: Colors.grey.shade600), overflow: TextOverflow.ellipsis, maxLines: 2,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ New Fullscreen Page
class FullscreenVideoPage extends StatefulWidget {
  final String videoId;
  const FullscreenVideoPage({super.key, required this.videoId});

  @override
  State<FullscreenVideoPage> createState() => _FullscreenVideoPageState();
}

class _FullscreenVideoPageState extends State<FullscreenVideoPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        forceHD: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }
}
