import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/feature/team_build/screen/team_build_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../../my_wallet/bloc/wallet/wallet_bloc.dart';
import '../../my_wallet/bloc/wallet/wallet_event.dart';
import '../../my_wallet/bloc/wallet/wallet_state.dart';
import '../../my_wallet/repository/wallet_repository.dart';
import '../../team_build/bloc/my_team/my_team_bloc.dart';
import '../../team_build/bloc/my_team/my_team_event.dart';
import '../../team_build/bloc/my_team/my_team_state.dart';
import '../../team_build/repository/my_team_repository.dart';


class FeatureWidget extends StatefulWidget {
  final String userId;
  const FeatureWidget({Key? key, required this.userId}) : super(key: key);

  @override
  State<FeatureWidget> createState() => _FeatureWidgetState();
}

class _FeatureWidgetState extends State<FeatureWidget> {
  //
  // @override
  // void initState() {
  //   super.initState();
  //   context.read<WalletBloc>().add(FetchWalletByUserId(widget.userId));
  //   context.read<MyTeamBloc>().add(FetchMyTeam(widget.userId));
  //
  // }

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => WalletBloc(WalletRepository())..add(FetchWalletByUserId(widget.userId)),
        ),
        BlocProvider(
          create: (_) => MyTeamBloc(MyTeamRepository())..add(FetchMyTeam(widget.userId)),
        ),
      ],
      child: Container(
        height: dimensions.screenHeight * 0.08,
        padding:  EdgeInsets.symmetric(horizontal:  dimensions.screenHeight*0.01),
        child: Row(
          children: [
            /// Wallet Balance
            BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                if (state is WalletLoading) {
                  return Expanded(child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: CustomContainer(
                        color: CustomColor.whiteColor,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.zero,
                      )));
                } else if (state is WalletLoaded) {
                  final wallet = state.wallet;
      
                  return Expanded(
                    child: InkWell(
                      onTap: () => context.push('/wallet/${widget.userId}',),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/image/my_earning_icon.png',fit: BoxFit.cover,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("My Wallet",
                                    style: textStyle12(context)),
                                Text("₹ ${wallet.balance}",
                                    style: textStyle16(context, color: Colors.blueAccent)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  
                } else if (state is WalletError) {
                  return  SizedBox.shrink();
                }
                return const SizedBox();
              },
            ),
      
            10.width,
      
            BlocBuilder<MyTeamBloc, MyTeamState>(
              builder: (context, state) {
                if (state is MyTeamLoading) {
                  return Expanded(child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: CustomContainer(color: CustomColor.whiteColor,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.zero,)));
                } else if (state is MyTeamLoaded) {
                  // final teamList = state.response.team;
                  final userCount = state.response.length;
      
                  return   Expanded(
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TeamBuildScreen()),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/image/my_team_icon.png',fit: BoxFit.cover,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("My Team",
                                    style: textStyle12(context)),
                                Text("${userCount == 0 ? '___':userCount}",
                                    style: textStyle16(context, color: Colors.blueAccent)),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
      
                } else if (state is MyTeamError) {
                  print('"Error: ${state.message}"');
                  return SizedBox.shrink();
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}