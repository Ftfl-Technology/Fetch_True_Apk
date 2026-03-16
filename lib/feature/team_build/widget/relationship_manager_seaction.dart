import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/team_build/widget/relationship_manager_card_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../profile/bloc/user_by_id/user_by_id_bloc.dart';
import '../../profile/bloc/user_by_id/user_by_id_event.dart';
import '../../profile/bloc/user_by_id/user_by_id_state.dart';
import '../../profile/model/user_model.dart';
import '../../profile/repository/user_by_id_repojetory.dart';
import '../bloc/my_team/my_team_bloc.dart';
import '../bloc/user_confirm_referral/user_confirm_referral_bloc.dart';
import '../bloc/user_confirm_referral/user_confirm_referral_event.dart';
import '../bloc/user_confirm_referral/user_confirm_referral_state.dart';
import '../bloc/user_referral/user_referral_bloc.dart';
import '../bloc/user_referral/user_referral_event.dart';
import '../bloc/user_referral/user_referral_state.dart';
import '../repository/my_team_repository.dart';
import '../repository/user_referral_repository.dart';

class RelationshipManagerSection extends StatelessWidget {
  const RelationshipManagerSection({super.key});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    final TextEditingController _referralController = TextEditingController();

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserReferralBloc>(
          create: (context) => UserReferralBloc(UserReferralRepository()),
        ),
        BlocProvider<UserConfirmReferralBloc>(
          create: (context) => UserConfirmReferralBloc(UserReferralRepository()),
        ),
        BlocProvider<UserByIdBloc>(
          create: (context) => UserByIdBloc(UserByIdRepository()),
        ),
        BlocProvider<MyTeamBloc>(
          create: (context) => MyTeamBloc(MyTeamRepository()),
        ),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return RelationshipManagerCardShimmer();
          }
      
          if (state is UserLoaded) {
            final user = state.user;

            if(user.referredBy != null){
              context.read<UserByIdBloc>().add(FetchUserById(state.user.referredBy!));
            }
      
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
      
      
                if(user.referredBy == null)
                Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.all(dimensions.screenHeight*0.02),
                      child: Text('Enter Referral Code and add your Relationship Manager Instantly'),
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal:dimensions.screenHeight*0.02),
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          dashPattern: [6, 3],
                          strokeWidth: 1,
                          radius: Radius.circular(8),
                          color: CustomColor.appColor,
                        ),
                        child: CustomContainer(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          color: CustomColor.whiteColor,
                          child: Row(
                            children: [
                              20.width,
                              Expanded(
                                child: TextField(
                                  controller: _referralController,
                                  decoration: const InputDecoration(
                                    hintText: 'Referral Code...',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
      
                              /// Referral Bloc Section
                              CustomContainer(
                                color: CustomColor.whiteColor,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                height: dimensions.screenHeight*0.04,width: dimensions.screenHeight*0.1,
                                child: Center(
                                  child: BlocConsumer<UserReferralBloc, UserReferralState>(
                                    listener: (context, state) {
                                      if (state is UserReferralError) {
                                        showCustomToast('Wrong referral code  #${_referralController.text}');
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is UserReferralInitial) {
                                        return TextButton(
                                          onPressed: () {
                                            final code = _referralController.text.trim();
                                            if (code.isNotEmpty) {
                                              context.read<UserReferralBloc>().add(
                                                FetchUserByReferralCode(code),
                                              );
                                            }
                                          },
                                          child: Text(
                                            "Verify",
                                            style: TextStyle(color: CustomColor.appColor),
                                          ),
                                        );
                                      } else if (state is UserReferralLoading) {
                                        return  SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Center(
                                            child: CircularProgressIndicator(strokeWidth: 4,color:CustomColor.whiteColor,),
                                          ),
                                        );
                                      } else if (state is UserReferralLoaded) {
                                        return const Text(
                                          'Verified',
                                          style: TextStyle(color: Colors.green),
                                        );
                                      } else if (state is UserReferralError) {
                                        return const Text(
                                          'Wrong',
                                          style: TextStyle(color: Colors.red),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              5.width
                            ],
                          ),
                        ),
                      ),
                    ),
                    10.height,
      
                    /// Verified User Details + Actions
                    BlocBuilder<UserReferralBloc, UserReferralState>(
                      builder: (context, state) {
                        if (state is UserReferralLoaded) {
                          final referralUser = state.user;

                          final address = [
                            if (referralUser.homeAddress?.city?.isNotEmpty == true) referralUser.homeAddress!.city,
                            if (referralUser.homeAddress?.state?.isNotEmpty == true) referralUser.homeAddress!.state,
                          ].join(", ");
      
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RelationshipManagerCardWidget(
                                backgroundImage: (referralUser.profilePhoto == null ||
                                    referralUser.profilePhoto!.trim().isEmpty)
                                    ?  AssetImage(CustomImage.nullImage)
                                    : NetworkImage(referralUser.profilePhoto!.trim()),

                                name: referralUser.fullName,
                                phone: referralUser.mobileNumber,
                                id: referralUser.userId,
                                level: referralUser.packageStatus == 'nonGP' ? 'Non-GP':referralUser.packageStatus,
                                address: address.isNotEmpty ? address : null,
                                status: referralUser.isDeleted,
                              ),
      
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(child: Text('')),
                                
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              context.read<UserReferralBloc>().emit(UserReferralInitial());
                                              _referralController.clear();
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                    
                                        Expanded(
                                          child: BlocConsumer<UserConfirmReferralBloc, UserConfirmReferralState>(
                                            listener: (context, confirmState) {
                                              if (confirmState is UserConfirmReferralError) {
                                                showCustomToast('Please change referral code!');
                                              }
                                              if (confirmState is UserConfirmReferralLoaded) {
                                                showCustomToast('Referral confirmed ✅');
                                                                            
                                                /// Re-fetch fresh user details
                                                context.read<UserBloc>().add(GetUserById(user.id));
                                                                            
                                                /// ReferralCode textfield clear
                                                _referralController.clear();
                                                                            
                                                /// Reset referral verification state (taaki UI dobara build ho)
                                                context.read<UserReferralBloc>().emit(UserReferralInitial());
                                              }
                                            },
                                            builder: (context, confirmState) {
                                              if (confirmState is UserConfirmReferralLoading) {
                                                return Center(
                                                  child:  SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child: CircularProgressIndicator(strokeWidth: 4, color: CustomColor.appColor,),
                                                  ),
                                                );
                                              }
                                              else if (confirmState is UserConfirmReferralLoaded) {
                                                return const Text("Confirmed", style: TextStyle(color: Colors.green));
                                              }
                                              return TextButton(
                                                onPressed: () {
                                                  final referralCode = _referralController.text.trim();
                                                  if (user.id.isNotEmpty && referralCode.isNotEmpty) {
                                                    context.read<UserConfirmReferralBloc>().add(
                                                      ConfirmReferralCodeEvent(
                                                        userId: user.id,
                                                        referralCode: referralCode,
                                                      ),
                                                    );
                                                  }
                                                },
                                                child: const Text('Confirm', style: TextStyle(color: Colors.green),),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          );
                        } else if (state is UserReferralError) {
                          return CustomContainer(
                            color: Colors.white,
                            border: true,
                            child: ListTile(
                              title: Text(
                                'Alert!',
                                style: textStyle18(context, color: Colors.red),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    'Wrong Referral Code',
                                    style: textStyle14(context),
                                  ),
                                  10.width,
                                  Text(
                                    '#${_referralController.text}',
                                    style: textStyle14(context, color: Colors.red),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  context.read<UserReferralBloc>().emit(UserReferralInitial());
                                  _referralController.clear();
                                },
                                icon: const Icon(CupertinoIcons.refresh),
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
      
      
                if(user.referredBy != null)
                  BlocBuilder<UserByIdBloc, UserByIdState>(
                    builder: (context, state) {
                      if (state is UserByIdLoading) {
                        return RelationshipManagerCardShimmer();
                      } else if (state is UserByIdLoaded) {
                        final manager = state.user;
      
                        return    RelationshipManagerCardWidget(
                          backgroundImage: (manager.profilePhoto == null || manager.profilePhoto!.isEmpty)
                              ?  AssetImage(CustomImage.nullImage)
                              : NetworkImage(manager.profilePhoto!) as ImageProvider,
                          name: manager.fullName,
                          phone: manager.mobileNumber,
                          id: manager.userId,
                          level: manager.packageActive == true ? '${manager.packageStatus}' : 'Non-GP',
                          address: _getMemberAddress(manager),
                          status: manager.isDeleted,
                        );
                      } else if (state is UserByIdError) {
                        return Center(child: Text("Error: ${state.message}"));
                      }
                      return const SizedBox();
                    },
                  ),
              ],
            );

          }
      
          if (state is UserError) {
            debugPrint('Error : ${state.massage}');
            return const SizedBox.shrink();
          }
      
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _getMemberAddress(UserModel member) {
    Address? address;

    if (member.homeAddress != null && _isAddressValid(member.homeAddress!)) {
      address = member.homeAddress;
    } else if (member.workAddress != null && _isAddressValid(member.workAddress!)) {
      address = member.workAddress;
    } else if (member.otherAddress != null && _isAddressValid(member.otherAddress!)) {
      address = member.otherAddress;
    }

    if (address != null) {
      List<String> parts = [
        address.houseNumber,
        address.landmark,
        address.city,
        address.state,
        address.pinCode,
        address.country
      ];
      return parts.where((part) => part.isNotEmpty).join(", ");
    }

    return "";
  }

  bool _isAddressValid(Address address) {
    return address.houseNumber.isNotEmpty ||
        address.landmark.isNotEmpty ||
        address.city.isNotEmpty ||
        address.state.isNotEmpty ||
        address.pinCode.isNotEmpty ||
        address.country.isNotEmpty;
  }

}


