import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/team_build/screen/team_build_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../address/address_notifier.dart';
import '../../address/screen/address_picker_screen.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../my_wallet/bloc/wallet/wallet_bloc.dart';
import '../../my_wallet/bloc/wallet/wallet_event.dart';
import '../../my_wallet/bloc/wallet/wallet_state.dart';
import '../../my_wallet/repository/wallet_repository.dart';
import '../../my_wallet/screen/wallet_screen.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../team_build/bloc/my_team/my_team_bloc.dart';
import '../../team_build/bloc/my_team/my_team_event.dart';
import '../../team_build/bloc/my_team/my_team_state.dart';
import '../../team_build/repository/my_team_repository.dart';


class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);
    final addressNotifier = Provider.of<AddressNotifier>(context);
    final currentAddress = addressNotifier.confirmedAddress;

    if (!userSession.isLoggedIn) {
      return Container(
        color: Color(0xFFF0F5FE),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(CustomImage.nullImage),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddressPickerScreen()),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Guest', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                            Row(
                              children: [
                                Icon(Icons.location_on,size: 16,color: Colors.red,),
                                Text('${currentAddress.isNotEmpty ?currentAddress:'Select Address'}', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  Row(
                    children: [
                      ActionCircleButton(
                        iconPath: 'assets/icon/team_build_icon.png',
                        label: '0',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TeamBuildScreen()),
                        ),
                      ),
                      ActionCircleButton(
                        iconPath: 'assets/icon/wallet_icon.png',
                        label:'0',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => WalletScreen(userId: userSession.userId.toString())),
                        ),
                      ),
                      // CircleAvatar(
                      //     radius: 16,
                      //     backgroundColor: Colors.white,
                      //     child: Icon(Icons.notifications_active_outlined,size: 20,))
                    ],
                  ),
                ],
              ),
            ),
            5.height,
          ],
        ),
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
            return _profileShimmer(dimensions);
          }


          if (state is UserLoaded) {
            final user = state.user;
            return Container(
              color: Color(0xFFF0F5FE),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor:Colors.white,
                              child: (user.profilePhoto != null &&
                                  user.profilePhoto!.isNotEmpty &&
                                  Uri.tryParse(user.profilePhoto!)?.hasAbsolutePath == true)
                                  ? ClipOval(
                                child: Image.network(
                                  user.profilePhoto!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return Image.asset(CustomImage.nullImage);
                                  },
                                ),
                              )
                                  :  ClipOval(child: Image.asset(CustomImage.nullImage)),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddressPickerScreen()),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName != null && user.fullName!.isNotEmpty
                                        ? user.fullName![0].toUpperCase() + user.fullName!.substring(1)
                                        : '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      Icon(Icons.location_on,size: 16,color: Colors.red,),
                                      Text('${currentAddress.isNotEmpty ?currentAddress:'Select Address'}', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),

                        Row(
                          children: [
                            BlocBuilder<MyTeamBloc, MyTeamState>(
                              builder: (context, state) {
                                String teamCount = '';
                                if (state is MyTeamLoaded) {
                                  teamCount = "${state.response.length}";
                                }
                                return ActionCircleButton(
                                  iconPath: 'assets/icon/team_build_icon.png',
                                  label: teamCount.isEmpty ? '0' : teamCount,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const TeamBuildScreen()),
                                  ),
                                );
                              },
                            ),
                            BlocBuilder<WalletBloc, WalletState>(
                              builder: (context, state) {
                                String label = '';
                                if (state is WalletLoaded) {
                                  label = "₹${state.wallet.balance}";
                                }
                                return ActionCircleButton(
                                  iconPath: 'assets/icon/wallet_icon.png',
                                  label: label.isEmpty ? '₹0' : label,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => WalletScreen(userId: user.id)),
                                  ),
                                );
                              },
                            ),
                            // CircleAvatar(
                            //     radius: 16,
                            //     backgroundColor: Colors.white,
                            //     child: Icon(Icons.notifications_active_outlined,size: 20,))
                          ],
                        ),
                      ],
                    ),
                  ),
                  5.height,
                ],
              ),
            );
          } else if (state is UserError) {
            debugPrint("Error: ${state.massage}");
            return Container(
              color: Color(0xFFF0F5FE),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(CustomImage.nullImage),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddressPickerScreen()),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Guest', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                  Row(
                                    children: [
                                      Icon(Icons.location_on,size: 16,color: Colors.red,),
                                      Text('${currentAddress.isNotEmpty ?currentAddress:'Select Address'}', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),

                        Row(
                          children: [
                            ActionCircleButton(
                              iconPath: 'assets/icon/team_build_icon.png',
                              label: '0',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const TeamBuildScreen()),
                              ),
                            ),
                            ActionCircleButton(
                              iconPath: 'assets/icon/wallet_icon.png',
                              label:'0',
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => WalletScreen(userId: userSession.userId.toString())),
                              ),
                            ),
                            // CircleAvatar(
                            //     radius: 16,
                            //     backgroundColor: Colors.white,
                            //     child: Icon(Icons.notifications_active_outlined,size: 20,))
                          ],
                        ),
                      ],
                    ),
                  ),
                  5.height,
                ],
              ),
            );
          }
          return Container(
            color: Color(0xFFF0F5FE),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(CustomImage.nullImage),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AddressPickerScreen()),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Guest', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),

                                Row(
                                  children: [
                                    Icon(Icons.location_on,size: 16,color: Colors.red,),
                                    Text('${currentAddress.isNotEmpty ?currentAddress:'Select Address'}', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      Row(
                        children: [
                          ActionCircleButton(
                            iconPath: 'assets/icon/team_build_icon.png',
                            label: '0',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TeamBuildScreen()),
                            ),
                          ),
                          ActionCircleButton(
                            iconPath: 'assets/icon/wallet_icon.png',
                            label:'0',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => WalletScreen(userId: userSession.userId.toString())),
                            ),
                          ),
                          // CircleAvatar(
                          //     radius: 16,
                          //     backgroundColor: Colors.white,
                          //     child: Icon(Icons.notifications_active_outlined,size: 20,))
                        ],
                      ),
                    ],
                  ),
                ),
                5.height,
              ],
            ),
          );
        },
      ),
    );
  }
}

class ActionCircleButton extends StatelessWidget {
  final String iconPath;
  final String? label;
  final VoidCallback onTap;

  const ActionCircleButton({
    Key? key,
    required this.iconPath,
    this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
              backgroundColor: Colors.white,
              child: Image.asset(
                iconPath,
                height: 20,
                color: Colors.black,
              ),
            ),
            // if (label != null && label!.isNotEmpty)
            //   Positioned(
            //     right: -4,
            //     bottom: 0,
            //     child: Container(
            //       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         boxShadow: [
            //           BoxShadow(
            //             blurRadius: 3,
            //             offset: const Offset(0, 1),
            //           ),
            //         ],
            //       ),
            //       child: Text(
            //         label!,
            //         style: const TextStyle(
            //           fontSize: 9,
            //           color: Colors.white,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

Widget _profileShimmer(Dimensions dimensions) {
  return Container(
    color: const Color(0xFFF0F5FE),
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.6),
      highlightColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                    ),

                    10.width,

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(height: 14, width: 120),
                        6.height,
                        ShimmerBox(height: 12, width: 160),
                      ],
                    ),
                  ],
                ),

                Row(
                  children: const [
                    CircleAvatar(radius: 16, backgroundColor: Colors.white),
                    SizedBox(width: 10),
                    CircleAvatar(radius: 16, backgroundColor: Colors.white),
                    SizedBox(width: 10),
                    CircleAvatar(radius: 16, backgroundColor: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

