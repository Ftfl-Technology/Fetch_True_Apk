import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../feature/auth/user_notifier/user_notifier.dart';
import '../../feature/favorite/screen/favorite_screen.dart';
import '../../feature/notification/screen/notification_screen.dart';
import '../../feature/search/screen/search_screen.dart';
import 'custom_search_icon.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;
  final bool showNotificationIcon;
  final bool showFavoriteIcon;
  final bool showSearchIcon;
  final Widget? leading;
  final double? leadingWidth;
  final Color? bColor;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showBackButton = false,
    this.showNotificationIcon = false,
    this.showFavoriteIcon = false,
    this.showSearchIcon = false,
    this.leading,
    this.leadingWidth, this.bColor,
  });

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    return AppBar(
      backgroundColor: bColor,
      elevation: 1,
      automaticallyImplyLeading: false,
      leading: showBackButton ?
      IconButton(
        icon:  Icon(CupertinoIcons.back),
        onPressed: () => Navigator.of(context).pop(),
      ) : leading,
      leadingWidth:  showBackButton == false ? null:50,
      titleSpacing: showBackButton == false ? 20:0,
      title:  title != null ?Text(title!):titleWidget,
      actions:  [
        if(showNotificationIcon)
        IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(),)),
          icon: Icon(Icons.notifications_active_outlined,),
        ),

        if(showFavoriteIcon)
        IconButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen(userId: userSession.userId, status: 'service',),)),
          icon: const Icon(Icons.favorite,color: Colors.red,),
        ),

        if(showSearchIcon)
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CustomSearchIcon(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(moduleId: '',),)),
            ),
          ),

        // IconButton(
        //   onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(),)),
        //   icon: Icon(CupertinoIcons.search),
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
