import 'package:flutter/material.dart';
import '../costants/custom_color.dart';
import '../costants/custom_image.dart';
import '../costants/dimension.dart';
import '../costants/text_style.dart';
import 'custom_search_bar.dart';

class CustomSliverAppbar extends StatelessWidget {
  final String moduleId;
  final String title;
  final String? subtitle;
  final String imageUrl;
  final double searchBarHeight;
  final bool isCollapsed;
  final bool bannerAvailable;
  final Widget background;

  const CustomSliverAppbar({
    super.key,
    required this.moduleId,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    required this.searchBarHeight,
    required this.isCollapsed,
    required this.background, required this.bannerAvailable,
  });

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return SliverAppBar(
      expandedHeight: (bannerAvailable ? dimensions.screenHeight * 0.25 : 0) + searchBarHeight,
      // expandedHeight: dimensions.screenHeight*0.25 + searchBarHeight,
      pinned: true,
      stretch: true,
      elevation: isCollapsed ? 0.2 : 0,
      shadowColor: Colors.black26,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Hero(
          tag: imageUrl,
          child: Material(
            color: Colors.transparent,
            child: CircleAvatar(
              radius: 20.5,
              backgroundColor: CustomColor.appColor,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: CustomColor.whiteColor,
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: textStyle16(
              context,
              color: isCollapsed ? CustomColor.appColor : Colors.white,
            ),
            child:  Text(title),
          ),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: textStyle12(
              context,
              color: isCollapsed
                  ? CustomColor.descriptionColor
                  : Colors.white,
            ),
            child: const Text(''),
          ),
        ],
      ),
      titleSpacing: 15,
      leadingWidth: 50,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
            decoration: BoxDecoration(
                image: DecorationImage(image:
                AssetImage(CustomImage.nullBackImage), fit: BoxFit.fill)
            ),
            child: background),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(searchBarHeight),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: CustomSearchBar(moduleId: moduleId,),
        ),
      ),
    );
  }
}
