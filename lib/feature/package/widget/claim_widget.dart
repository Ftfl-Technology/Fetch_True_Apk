import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_button.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../bloc/package/package_bloc.dart';
import '../bloc/package/package_event.dart';
import '../bloc/reward/reward_bloc.dart';
import '../bloc/reward/reward_state.dart';
import '../bloc/reward_claim/reward_claim_bloc.dart';
import '../bloc/reward_claim/reward_claim_event.dart';
import '../bloc/reward_claim/reward_claim_state.dart';
import '../bloc/reward_claim_data/reward_claim_data_bloc.dart';
import '../bloc/reward_claim_data/reward_claim_data_event.dart';
import '../bloc/reward_claim_data/reward_claim_data_state.dart';
import '../model/reward_claim_model.dart';

class ClaimWidget extends StatefulWidget {
  final String selectedPlan;
  final String packageLevel;
  const ClaimWidget({Key? key, required this.selectedPlan, required this.packageLevel,}) : super(key: key);

  @override
  State<ClaimWidget> createState() => _ClaimWidgetState();
}

class _ClaimWidgetState extends State<ClaimWidget> {
  int? selectedOption;

  bool? isClaimSettled;

  @override
  void initState() {
    super.initState();
    context.read<ClaimNowDataBloc>().add(FetchClaimNowDataEvent());
  }

  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);
    final userSession = Provider.of<UserSession>(context);


    return BlocBuilder<RewardBloc, RewardState>(
      builder: (context, state) {
        if (state is RewardLoading) {
          return const Center(child: CircularProgressIndicator());
        }


        if (state is RewardLoaded) {

          final filteredRewards = state.rewards.where((reward) {
            return reward.packageType.toLowerCase() == widget.selectedPlan.toLowerCase();
          }).toList();

          if (filteredRewards.isEmpty) {
            return const Center(
              child: Text("No rewards found for this plan"),
            );
          }

          final reward = filteredRewards.first;


          return  Padding(
            padding: EdgeInsets.all(10),
            child: BlocListener<RewardClaimBloc, RewardClaimState>(
            listener: (context, state) {
              if (state is RewardClaimSuccess) {
               showCustomToast(state.message);
               context.read<UserBloc>().add(GetUserById(userSession.userId!));
               context.read<PackageBloc>().add(FetchPackages());
               context.read<ClaimNowDataBloc>().add(FetchClaimNowDataEvent());
              }
              if (state is RewardClaimError) {
                print(state.error);
              }
            },
              child: BlocBuilder<ClaimNowDataBloc, ClaimNowDataState>(
                builder: (context, claimState) {
                  bool isClaimRequested = false;
                  if (claimState is ClaimNowDataLoaded) {
                    final matchingList = claimState.items.where((u) => u.user.id == userSession.userId).toList();


                    if (matchingList.isNotEmpty) {
                      final data = matchingList.first;
                      isClaimRequested = (data.isClaimRequest == true) || (data.isExtraMonthlyEarnRequest == true);
                    }
                  }

                  return Column(
                  children: [

                  /// select reward section
                  if (!isClaimRequested &&  widget.selectedPlan == 'sgp')
                  Stack(
                  children: [
                    DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        dashPattern: [15, 3],
                        strokeWidth: 1.5,
                        radius: Radius.circular(8),
                        color: CustomColor.appColor,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: CustomColor.whiteColor,
                            borderRadius: BorderRadius.circular(8)
                        ),
                        padding: EdgeInsets.all(dimensions.screenWidth*0.05),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Header Icon
                            Icon(
                              Icons.verified_outlined,
                              color: CustomColor.greenColor,
                              size: 28,
                            ),
                  
                  
                            // Title
                            Text('Select Your Reward Option', style: textStyle16(context, color: Colors.black54)),
                  
                            // Subtitle
                            Text(
                              'Choose any one option to claim or apply.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            20.height,
                  
                            // Option 1: iPhone Reward
                            _buildRewardOption(
                              index: 0,
                              imagePath: reward.photo,
                              title: reward.name ?? 'Claim Your Reward',
                              subtitle: reward.description,
                              icon: Icons.phone_iphone,
                              accentColor: Colors.orange,
                            ),
                            const SizedBox(height: 20),
                  
                            // OR Divider
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey.shade400)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'OR',
                                    style: textStyle14(context),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.grey.shade400)),
                              ],
                            ),
                            const SizedBox(height: 20),
                  
                            // Option 2: Increase Earnings
                            _buildRewardOption(
                              index: 1,
                              imagePath: 'assets/earnings.png',
                              title: 'Increase Your Monthly Earning. \u20B9 ${reward.extraMonthlyEarn}',
                              subtitle: reward.extraMonthlyEarnDescription,
                              icon: Icons.trending_up,
                              accentColor: Colors.red,
                            ),
                            25.height,

                            (widget.packageLevel == 'SGP' && widget.selectedPlan == 'sgp') ?
                            SizedBox.shrink():
                            CustomContainer(
                              color: CustomColor.appColor,
                              child: state is RewardClaimLoading ?
                                Center(child: CircularProgressIndicator(backgroundColor: Colors.white,))
                                :Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Claim Reward', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white),),
                                  Icon(Icons.lock,size: 18,color: Colors.white,)
                                ],
                              ),
                              onTap: () {
                                if (selectedOption == null) {
                                  showCustomToast('Please select any option');
                                  return;
                                }

                                final isReward = selectedOption == 0;
                                final isExtraMonth = selectedOption == 1;

                                context.read<RewardClaimBloc>().add(
                                  SubmitClaimEvent(
                                    userId: userSession.userId!,
                                    rewardId: reward.id!,
                                    selectedIndex: selectedOption!,
                                  ),
                                );

                              },
                            ),
                  
                  
                          ],
                        ),
                      ),
                    ),

                    (widget.packageLevel == 'SGP' && widget.selectedPlan == 'sgp') ? SizedBox.shrink():
                    Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          // child: Center(
                          //   child: Column(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: [
                          //        20.height,
                          //       Icon(
                          //         Icons.lock,
                          //         size: 60,
                          //         color: Colors.white,
                          //       ),
                          //       10.height,
                          //       Text(
                          //         'Locked',
                          //         style: textStyle16(context, color: Colors.white),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ),
                      ),

                  ],),

                   if (widget.selectedPlan == 'pgp')
                   Stack(
                        children: [
                          DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              dashPattern: [15, 3],
                              strokeWidth: 1.5,
                              radius: Radius.circular(8),
                              color: CustomColor.appColor,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: CustomColor.whiteColor,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              padding: EdgeInsets.all(dimensions.screenWidth*0.05),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Header Icon
                                  Icon(
                                    Icons.verified_outlined,
                                    color: CustomColor.greenColor,
                                    size: 28,
                                  ),


                                  // Title
                                  Text('Select Your Reward Option', style: textStyle16(context, color: Colors.black54)),

                                  // Subtitle
                                  Text(
                                    'Choose any one option to claim or apply.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  20.height,

                                  // Option 1: iPhone Reward
                                  _buildRewardOption(
                                    index: 0,
                                    imagePath: reward.photo,
                                    title: reward.name ?? 'Claim Your Reward',
                                    subtitle: reward.description,
                                    icon: Icons.phone_iphone,
                                    accentColor: Colors.orange,
                                  ),
                                  const SizedBox(height: 20),

                                  // OR Divider
                                  Row(
                                    children: [
                                      Expanded(child: Divider(color: Colors.grey.shade400)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                        child: Text(
                                          'OR',
                                          style: textStyle14(context),
                                        ),
                                      ),
                                      Expanded(child: Divider(color: Colors.grey.shade400)),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Option 2: Increase Earnings
                                  _buildRewardOption(
                                    index: 1,
                                    imagePath: 'assets/earnings.png',
                                    title: 'Increase Your Monthly Earning. \u20B9 ${reward.extraMonthlyEarn}',
                                    subtitle: reward.extraMonthlyEarnDescription,
                                    icon: Icons.trending_up,
                                    accentColor: Colors.red,
                                  ),
                                  25.height,

                                  CustomContainer(
                                    color: CustomColor.appColor,
                                    child: state is RewardClaimLoading ?
                                    Center(child: CircularProgressIndicator(backgroundColor: Colors.white,))
                                        :Row(
                                      spacing: 10,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Claim Reward', style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.white),),
                                        Icon(Icons.lock,size: 18,color: Colors.white,)
                                      ],
                                    ),
                                    onTap: () {
                                      if (selectedOption == null) {
                                        showCustomToast('Please select any option');
                                        return;
                                      }

                                      final isReward = selectedOption == 0;
                                      final isExtraMonth = selectedOption == 1;

                                      context.read<RewardClaimBloc>().add(
                                        SubmitClaimEvent(
                                          userId: userSession.userId!,
                                          rewardId: reward.id!,
                                          selectedIndex: selectedOption!,  // 0 or 1
                                        ),
                                      );

                                    },
                                  ),


                                ],
                              ),
                            ),
                          ),

                          (widget.packageLevel == 'PGP' && widget.selectedPlan == 'sgp') ? SizedBox.shrink():
                          (isClaimSettled == true && widget.packageLevel == 'PGP') ? SizedBox.shrink():
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              // child: Center(
                              //   child: Column(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       20.height,
                              //       Icon(
                              //         Icons.lock,
                              //         size: 60,
                              //         color: Colors.white,
                              //       ),
                              //       10.height,
                              //       Text(
                              //         'Locked',
                              //         style: textStyle16(context, color: Colors.white),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ),
                          ),

                        ],),

                  /// reward view section
                    if(widget.selectedPlan == 'sgp')
                    Column(
                    children: [
                      if (claimState is ClaimNowDataLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (claimState is ClaimNowDataError)
                        Center(child: Text(claimState.message))
                      else if (claimState is ClaimNowDataLoaded) ...[
                          Builder(builder: (ctx) {
                            final items = claimState.items
                                .where((u) => u.user.id == userSession.userId)
                                .toList();
                            if (items.isEmpty) return const SizedBox.shrink();
                            final user = items.first;
                             isClaimSettled = user.isClaimSettled;
                            return   ClaimNowDataStatus(user: user);
                          })
                        ] else
                          const SizedBox.shrink(),
                    ],
                  ),

                    if(widget.selectedPlan == 'pgp' && widget.selectedPlan == 'sgp')
                     Column(
                        children: [
                          if (claimState is ClaimNowDataLoading)
                            const Center(child: CircularProgressIndicator())
                          else if (claimState is ClaimNowDataError)
                            Center(child: Text(claimState.message))
                          else if (claimState is ClaimNowDataLoaded) ...[
                              Builder(builder: (ctx) {
                                final items = claimState.items
                                    .where((u) => u.user.id == userSession.userId)
                                    .toList();
                                if (items.isEmpty) return const SizedBox.shrink();
                                final user = items.first;
                                isClaimSettled = user.isClaimSettled;
                                return   ClaimNowDataStatus(user: user);
                              })
                            ] else
                              const SizedBox.shrink(),
                        ],
                      ),

                  ],
              );
                },
              ),
            ),
          );
        }

        if (state is RewardError) {
          print(state.message);
          return SizedBox.shrink();
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildRewardOption({
    required int index,
    required String imagePath,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
  }) {
    final isSelected = selectedOption == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = index;
        });
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: isSelected ? Colors.green.shade400 : Colors.grey.shade300, width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                CustomContainer(
                  height: 150,
                  margin: EdgeInsets.zero,
                  networkImg: imagePath,
                ),
               10.height,

                // Text Content
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(title.isNotEmpty)
                    Text('${title} ${index == 0 ?CustomLogEmoji.box:CustomLogEmoji.money}',
                      style: textStyle12(context, color: CustomColor.appColor),
                    ),
                    if(subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? Colors.green.shade400 : Colors.white,
                border: Border.all(
                  color: isSelected ? Colors.green.shade400 : Colors.grey.shade400,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(
                Icons.check,
                size: 18,
                color: Colors.white,
              )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}



/// ClaimNowDataStatus
class ClaimNowDataStatus extends StatelessWidget {
  final ClaimNowDataModel user;
  const ClaimNowDataStatus({
    Key? key, required this.user,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        dashPattern: [15, 3],
        strokeWidth: 1.5,
        radius: Radius.circular(8),
        color: CustomColor.appColor,
      ),
      child: Container(
        decoration: BoxDecoration(
            color: CustomColor.whiteColor,
            borderRadius: BorderRadius.circular(8)
        ),
        padding: EdgeInsets.all(dimensions.screenWidth*0.05),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

        /// Progress Indicator
        Row(
        children: [
        // First item
        CircleAvatar(radius: 12,
          backgroundColor: Colors.green,
          child: Text('1', style: TextStyle(color: CustomColor.whiteColor),),),
        Expanded(
          child: LinearProgressIndicator(
            value: 1.0,
            valueColor: AlwaysStoppedAnimation(Colors.grey.shade300,),
          ),
        ),

        // Second item
          CircleAvatar(radius: 12, backgroundColor: user.isAdminApproved  ? CustomColor.greenColor:Colors.black12, child: Text('2', style: TextStyle(color: CustomColor.whiteColor),),),
        Expanded(
          child: LinearProgressIndicator(
            value: 1.0,
            valueColor: AlwaysStoppedAnimation(Colors.grey.shade300,),
          ),
        ),
          CircleAvatar(radius: 12, backgroundColor: user.isClaimSettled  ? CustomColor.greenColor:Colors.black12, child: Text('3', style: TextStyle(color: CustomColor.whiteColor),),),
        ],
      ),
         20.height,

            // Status Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                 if(user.isExtraMonthlyEarnRequest != true)
                 Text(user.isAdminApproved == false ?'Reward Request Pending':user.isClaimSettled == false ?'Reward Approved':'Congratulation', style: textStyle14(context,color: user.isAdminApproved == false? Colors.red: Colors.green),),

                if(user.isExtraMonthlyEarnRequest == true)
                 Text(user.isAdminApproved == false ?'Increment Request Pending':user.isClaimSettled == false ?'Reward Approved':'Congratulation', style: textStyle14(context,color: user.isAdminApproved == false? Colors.red: Colors.green),),
                 10.width,
                 Icon(
                   user.isAdminApproved == false? Icons.hourglass_empty: Icons.verified_outlined,
                  color: CustomColor.appColor,
                  size: 20,
                ),
              ],
            ),
            10.height,
            // Status Message


            if(user.isClaimSettled == false)
            Center(
              child: Column(

                children: [
                  Text(
                   user.isAdminApproved == false? 'Your reward request is submitted.': 'Your reward is approved.',
                    style: textStyle12(context, color: Colors.grey.shade500),
                  ),
                  Text(
                    user.isAdminApproved == false?  'Admin will verify it soon.':'please collect it on',
                    style: textStyle12(context, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            if(user.isClaimSettled == true)
            Center(child: Text('Great job! Here is your reward moment', style: textStyle12(context, color: Colors.grey.shade500),)),

            30.height,

            if(user.isClaimSettled == false)

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(image: NetworkImage(user.reward!.photo), fit: BoxFit.fill),
                    ),
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(16),
                  ),
                ),
                30.height,
                Center(
                  child: Column(
                    children: [
                      Text(user.reward!.name, style: textStyle14(context, color: Colors.black54),),
                      Text(user.reward!.description, style: textStyle12(context, fontWeight: FontWeight.w400, color: Colors.grey.shade600),),

                    ],
                  ),
                ) ,
                if(user.isAdminApproved == true)
                Padding(
                    padding:  EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.rewardTitle, style: textStyle14(context),),
                        Text(user.disclaimer, style: textStyle14(context,color: Colors.grey.shade600,fontWeight: FontWeight.w400),),
                      ],
                    ),
                  ),
              ],
            ),

            if(user.isClaimSettled == true)

             Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(image: NetworkImage(user.rewardPhoto), fit: BoxFit.fill),
                      ),
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  20.height,
                  Text(user.rewardDescription, style: textStyle14(context, color: Colors.black54),) ,
                ],
              ),
          ],
        ),
      ),
    );
  }
}
