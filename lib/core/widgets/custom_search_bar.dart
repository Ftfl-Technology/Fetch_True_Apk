import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/feature/search/screen/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../feature/auth/user_notifier/user_notifier.dart';
import '../../feature/favorite/screen/favorite_screen.dart';
import '../costants/dimension.dart';
import 'custom_container.dart';
import 'custom_search_icon.dart';

class CustomSearchBar extends StatelessWidget {
  final String moduleId;
  const CustomSearchBar({super.key, required this.moduleId,});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    final userSession = Provider.of<UserSession>(context);

    return Row(
      children: [
        Expanded(
          child: Hero(
            tag: "searchBarHero",
            child: Material(
              color: Colors.transparent,
              child: CustomContainer(
                color: Colors.white,
                border: true,
                borderColor: CustomColor.appColor,
                padding: EdgeInsets.symmetric(
                  horizontal: dimensions.screenWidth * 0.030,
                  vertical: dimensions.screenHeight * 0.01,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Search here...",
                      style: textStyle14(context, fontWeight: FontWeight.w400),
                    ),
                    CustomSearchIcon(),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen(moduleId: moduleId,)),
                ),
              ),
            ),
          ),
        ),

        CustomContainer(
          border: true,
          borderColor: CustomColor.appColor,
          color: CustomColor.whiteColor,
          padding: EdgeInsets.all(dimensions.screenHeight*0.008),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(userId: userSession.userId, status: 'service',),)),
          child: Hero(
            tag: 'favoriteBarHero',
            child: Material(
              color: Colors.transparent,
              child: Icon(
                Icons.bookmark_border,
                color: Colors.red,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
