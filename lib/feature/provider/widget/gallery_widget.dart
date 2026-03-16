import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_image.dart';
import '../bloc/gallery/gallery_bloc.dart';
import '../bloc/gallery/gallery_event.dart';
import '../bloc/gallery/gallery_state.dart';
import '../repository/gallery_repository.dart';


class GalleryWidget extends StatelessWidget {
  final String providerId;
  const GalleryWidget({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocProvider(
      create: (_) =>
      GalleryBloc(GalleryRepository())..add(LoadGallery(providerId)),
      child: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, state) {
          if (state is GalleryLoading) {
            return  Center(child: CircularProgressIndicator(color: CustomColor.appColor,));
          } else if (state is GalleryLoaded) {

            if (state.gallery.galleryImages.isEmpty) {
              return Padding(
                  padding: EdgeInsetsGeometry.only(top: dimensions.screenHeight*0.25),
                  child:  Center(child: Column(
                    children: [
                      Image.asset(CustomImage.emptyCart, height: dimensions.screenHeight*0.1,),
                      Text('No Image.'),
                    ],
                  )));
            }


            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: state.gallery.galleryImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GalleryFullscreen(
                          images: state.gallery.galleryImages,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    state.gallery.galleryImages[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            );

          } else if (state is GalleryError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}


class GalleryFullscreen extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const GalleryFullscreen({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<GalleryFullscreen> createState() => _GalleryFullscreenState();
}

class _GalleryFullscreenState extends State<GalleryFullscreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                panEnabled: true,
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: Image.network(
                    widget.images[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),

          // Index Counter
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${_currentIndex + 1} / ${widget.images.length}",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),

          // Close Button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
