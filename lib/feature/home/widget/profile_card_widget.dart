import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/banner/widget/home_banner_widget.dart';
import 'package:fetchtrue/feature/team_build/screen/team_build_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../address/address_notifier.dart';
import '../../address/screen/address_picker_screen.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../my_wallet/bloc/wallet/wallet_bloc.dart';
import '../../my_wallet/bloc/wallet/wallet_event.dart';
import '../../my_wallet/bloc/wallet/wallet_state.dart';
import '../../my_wallet/repository/wallet_repository.dart';
import '../../my_wallet/screen/wallet_screen.dart';
import '../../notification/screen/notification_screen.dart';
import '../../package/screen/package_screen.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../team_build/bloc/my_team/my_team_bloc.dart';
import '../../team_build/bloc/my_team/my_team_event.dart';
import '../../team_build/bloc/my_team/my_team_state.dart';
import '../../team_build/repository/my_team_repository.dart';


class CustomHomeSliverAppbarWidget extends StatefulWidget {
  final double searchBarHeight;
  final bool isCollapsed;

  const CustomHomeSliverAppbarWidget({
    super.key,
    required this.searchBarHeight,
    required this.isCollapsed,
  });

  @override
  State<CustomHomeSliverAppbarWidget> createState() =>
      _CustomHomeSliverAppbarWidgetState();
}

class _CustomHomeSliverAppbarWidgetState extends State<CustomHomeSliverAppbarWidget> {
  bool _bannerAvailable = true; // default false

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);
    final addressNotifier = Provider.of<AddressNotifier>(context);
    final currentAddress = addressNotifier.confirmedAddress;

    if (!userSession.isLoggedIn) {
      return _buildSliverAppBar(
        context,
        widget.isCollapsed,
        name: "Guest",
        photo: null,
        currentAddress: currentAddress,
        userId: userSession.userId.toString(),
        showWalletAndTeam: false, // Guest user - no wallet/team
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WalletBloc(WalletRepository())
            ..add(FetchWalletByUserId(userSession.userId.toString())),
        ),
        BlocProvider(
          create: (_) => MyTeamBloc(MyTeamRepository())
            ..add(FetchMyTeam(userSession.userId.toString())),
        ),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        buildWhen: (previous, current) {
          return !(previous is UserLoaded && current is UserLoading);
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return SliverToBoxAdapter(child: _profileShimmer(dimensions));
          }

          if (state is UserLoaded) {
            final user = state.user;
            // FIXED: Pass the context from Builder which has access to BlocProviders
            return _buildSliverAppBar(
              context, // This context now has access to WalletBloc and MyTeamBloc
              widget.isCollapsed,
              name: user.fullName ?? "Guest",
              photo: user.profilePhoto,
              packageActive: user.packageActive,
              packageStatus: user.packageStatus,
              currentAddress: currentAddress,
              userId: userSession.userId.toString(),
              showWalletAndTeam: true,
            );
          } else if (state is UserError) {
            debugPrint("Error: ${state.massage}");
            return _buildSliverAppBar(
              context,
              widget.isCollapsed,
              name: "Guest",
              photo: null,
              currentAddress: currentAddress,
              userId: userSession.userId.toString(),
              showWalletAndTeam: false,
            );
          }
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        },
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(
      BuildContext context,
      bool isCollapsed, {
        required String name,
        String? photo,
        bool? packageActive,
        String? packageStatus,
        required String currentAddress,
        required String userId,
        required bool showWalletAndTeam, // New parameter
      }) {
    Dimensions dimensions = Dimensions(context);
    return SliverAppBar(
      expandedHeight: (_bannerAvailable ? dimensions.screenHeight * 0.25 : 0) + widget.searchBarHeight,
      pinned: true,
      stretch: true,
      elevation: 0,
      shadowColor: Colors.black26,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Material(
          color: Colors.transparent,
          child: CircleAvatar(
            radius: 20.5,
            backgroundColor: CustomColor.appColor,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: CustomColor.whiteColor,
              backgroundImage: (photo != null && photo.isNotEmpty)
                  ? NetworkImage(photo)
                  : AssetImage(CustomImage.nullImage) as ImageProvider,
            ),
          ),
        ),
      ),
      title: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: textStyle14(
                context,
                color: (!_bannerAvailable || isCollapsed) ? CustomColor.appColor : Colors.white,
              ),
              child: Text(name, overflow: TextOverflow.ellipsis,),
            ),
            AnimatedDefaultTextStyle(
              duration: Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: 14,
                color: (!_bannerAvailable || isCollapsed) ? CustomColor.descriptionColor : Colors.white,
              ),
              child: Text('$currentAddress'),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddressPickerScreen()),
          );
        },
      ),
      titleSpacing: 15,
      leadingWidth: 50,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.grey.shade100,
                  ],
                ),
              ),
            ),
            HomeBannerWidget(
              onStatus: (status) {
                if (_bannerAvailable != status) {
                  setState(() {
                    _bannerAvailable = status;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PackageScreen()),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: dimensions.screenHeight * 0.005,
              horizontal: dimensions.screenHeight * 0.015,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: CustomColor.appColor, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 14,
                  color: (!_bannerAvailable || isCollapsed) ? CustomColor.appColor : Colors.white,
                ),
                10.width,
                Text(
                  packageActive == true ? '${packageStatus}' : 'Package',
                  style: textStyle12(
                    context,
                    color: (!_bannerAvailable || isCollapsed) ? CustomColor.appColor : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        10.width,

        // FIXED: Only show if user is logged in and blocs are available
        if (showWalletAndTeam) ...[
          BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              String label = '';
              if (state is WalletLoaded) {
                label = "₹${state.wallet.balance}";
              }
              return ActionCircleButton(
                iconPath: 'assets/icon/wallet_icon.png',
                label: label.isEmpty ? '₹0' : label,
                activeColor: CustomColor.appColor,
                inactiveColor: Colors.white,
                isActive: !_bannerAvailable || isCollapsed,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WalletScreen(userId: userId)),
                ),
              );
            },
          ),
          BlocBuilder<MyTeamBloc, MyTeamState>(
            builder: (context, state) {
              String teamCount = '';
              if (state is MyTeamLoaded) {
                teamCount = "${state.response.length}";
              }
              return ActionCircleButton(
                iconPath: 'assets/icon/team_build_icon.png',
                label: teamCount.isEmpty ? '0' : teamCount,
                activeColor: CustomColor.appColor,
                inactiveColor: Colors.white,
                isActive: !_bannerAvailable || isCollapsed,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TeamBuildScreen()),
                ),
              );
            },
          ),
        ],
        10.width,
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(widget.searchBarHeight),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: dimensions.screenHeight * 0.012,
            vertical: dimensions.screenHeight * 0.006,
          ),
          child: CustomSearchBar(moduleId: ''),
        ),
      ),
    );
  }
}

class ActionCircleButton extends StatelessWidget {
  final String iconPath;
  final String? label;
  final Color activeColor;
  final Color inactiveColor;
  final bool isActive;
  final VoidCallback onTap;

  const ActionCircleButton({
    Key? key,
    required this.iconPath,
    this.label,
    required this.activeColor,
    required this.inactiveColor,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final iconColor = isActive ? activeColor : inactiveColor;

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: SizedBox(
        height: 50,
        width: 50,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.black12,
              child: Image.asset(
                iconPath,
                color: iconColor,
                height: 18,
              ),
            ),
            if (label != null && label!.isNotEmpty)
              Positioned(
                right: -4,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: activeColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withOpacity(0.4),
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    label!,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget _profileShimmer(Dimensions dimensions) {
  return Container(
    height: dimensions.screenHeight * 0.35,
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(backgroundColor: CustomColor.whiteColor),
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        5.height,
                        ShimmerBox(height: 10, width: 80),
                        5.height,
                        ShimmerBox(height: 10, width: 150),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    ShimmerBox(height: 30, width: 60),
                    10.width,
                    ShimmerBox(height: 25, width: 20),
                    10.width,
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomSearchBar(moduleId: ''),
          ),
        ],
      ),
    ),
  );
}