import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/feature/package/screen/package_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';

class InviteFranchiseSection extends StatefulWidget {
  const InviteFranchiseSection({super.key});

  @override
  State<InviteFranchiseSection> createState() => _InviteFranchiseSectionState();
}

class _InviteFranchiseSectionState extends State<InviteFranchiseSection> {


  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {

        if (state is UserInitial) {
          return CircularProgressIndicator();
        }
        else if(state is UserLoading){
          return CircularProgressIndicator();
        }
        else if (state is UserLoaded) {
          final user = state.user;
          return  SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Container(
                  margin: EdgeInsets.all(dimensions.screenHeight*0.01),

                  child: Column(
                    children: [
                     SizedBox(height: dimensions.screenHeight*0.02,),
                      Text('Turn Your Network into Income!', style: textStyle20(context),),
                      Text('Know someone who wants to start a business or explore extra earning opportunities?', style: textStyle12(context, fontWeight: FontWeight.w400, color: Colors.grey.shade600),textAlign: TextAlign.center,),
                      SizedBox(height: dimensions.screenHeight*0.02,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                            children: [
                              TextSpan(
                                text: 'Refer them to ',

                              ),
                              TextSpan(
                                text: 'Fetch True Franchisee',
                                style: TextStyle(color: Colors.blue,),
                              ),
                              TextSpan(
                                text: ' and earn ',
                              ),
                              TextSpan(
                                text: '₹5,000',
                                style: TextStyle(color: Colors.green,),
                              ),
                              TextSpan(
                                text: ' for every successful onboarding💰',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: dimensions.screenHeight*0.02,),

                      CustomContainer(
                        height: dimensions.screenHeight*0.4,
                        assetsImg: 'assets/package/refer_earn_bannar.jpg',
                      ),

                      10.height,
                      /// Referral Code Box
                      Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My Referral Code', style: TextStyle(fontSize: 14, color: Colors.black),),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF6F6F6),
                              border: Border.all(color: Colors.grey,width: 0.1),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
                            child: Row(
                              children: [
                                SizedBox(width: dimensions.screenHeight*0.03,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user.packageActive != true ?'XXXXXXX':user.referralCode, style: textStyle18(context, color: Colors.grey.shade700),),
                                  ],
                                ),
                                Spacer(),

                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if(user.packageActive == true){
                                          Clipboard.setData( ClipboardData(text: '${user.referralCode}'));
                                        }
                                        else{
                                          showCustomToast('Please first active package');
                                        }

                                      },
                                      child:  Icon(Icons.copy, color: Colors.grey.shade700,),
                                    ),
                                    SizedBox(width: dimensions.screenHeight*0.05,),
                                    InkWell(
                                      onTap: () {
                                        if(user.packageActive == true){
                                          Share.share("Hey! Use my referral code 👉 ${user.referralCode} to signup and enjoy benefits.");
                                        }
                                        else{
                                          showCustomToast('Please first active package');
                                        }
                                      },
                                      child:  Icon(Icons.share, color: Colors.grey.shade700, ),
                                    ),
                                    10.width
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      if(user.packageActive != true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            15.height,
                            Text('your package is not activated. Activate Now', style: TextStyle(color: Colors.red),),
                            10.height,
                            CustomContainer(color: CustomColor.appColor,
                              margin: EdgeInsets.zero,
                              padding: EdgeInsets.symmetric(horizontal: dimensions.screenHeight*0.05,vertical: dimensions.screenHeight*0.01),
                              child: Center(child: Text('Active Now', style: textStyle14(context, color: CustomColor.whiteColor),)),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageScreen(),)),
                            ),
                          ],
                        ),
                      SizedBox(height: dimensions.screenHeight*0.02,),

                      CustomContainer(
                        color: CustomColor.whiteColor,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Benefits', style: textStyle12(context),),
                            10.height,

                            Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Self Revenue Income', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey),),
                                Text('\u25CF Earn up to 15% revenue share on all successful leads generate.', style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey),),

                              ],
                            ),
                            10.height,
                            Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Team Building Income', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey),),
                                Text('\u25CF Earn ₹5,000 for every GP on you onboard', style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey),),
                                Text('\u25CF Get ₹3,000When you onboarded GP brings another', style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey),),

                              ],
                            ),
                            10.height,
                            Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Team Revenue Income', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey),),
                                Text('\u25CF Extra earn 5% to 8% for direct team revenue.', style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey),),
                                Text('\u25CF Extra earn 3% to 7% for indirect team revenue.', style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey),),

                              ],
                            ),

                              ],
                        ),
                      ),
                      10.height,

                      Row(
                        spacing: 20,
                        children: [
                          Expanded(
                            child: Column(
                              spacing: 10,
                              children: [
                                Icon(Icons.check_circle_outline_outlined, color: Colors.green,),
                                Text('Support Within 3-6 hrs', style: TextStyle(color: CustomColor.appColor,fontSize: 12,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              spacing: 10,
                              children: [
                                Icon(Icons.check_circle_outline_outlined, color: Colors.green,),
                                Text('Full Support System', style: TextStyle(color: CustomColor.appColor,fontSize: 12,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              spacing: 10,
                              children: [
                                Icon(Icons.check_circle_outline_outlined, color: Colors.green,),
                                Text('Exert help, anytime you need', style: TextStyle(color: CustomColor.appColor,fontSize: 12,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                        ],
                      ),

                      CustomContainer(
                        color: Colors.blue.shade50,
                        child: Column(
                          children: [
                            Text("Don't just dream of financial freedom create it", style: textStyle14(context,color: CustomColor.appColor),),
                            10.height,

                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                                children: [
                                  TextSpan(text: 'One referral today can unlock the potential to earn'),
                                  TextSpan(
                                    text: ' \u20B9 1,00,000 +',
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                                  ),
                                  TextSpan(text: ' every month!'),

                                ]
                              ),
                            )
                          ],
                        ),
                      ),


                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(top: 10.0,left: 10),
                           child: Text('Why Choose Growth Partnership?',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                         ),
                         Row(
                           children: [
                             Expanded(
                               child: CustomContainer(
                                 border: true,
                                 borderColor: CustomColor.appColor,
                                 color: Colors.white,
                                 child:  Column(
                                   spacing: 5,
                                   children: [
                                     Icon(Icons.check_circle_outline_outlined, color: CustomColor.appColor,),
                                     Text('High Referral Income', style: TextStyle(color: CustomColor.blackColor,fontSize: 12,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                                     Text('Earn up to direct ₹5,000 and indirect ₹3,000', style: TextStyle(color: CustomColor.greyColor,fontSize: 12,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
                                   ],
                                 ),
                               ),
                             ),
                             Expanded(
                               child: CustomContainer(
                                 border: true,
                                 borderColor: CustomColor.appColor,
                                 color: Colors.white,
                                 child:  Column(
                                   spacing: 5,
                                   children: [
                                     Icon(Icons.check_circle_outline_outlined, color:CustomColor.appColor,),
                                     Text('Monthly Revenue', style: TextStyle(color: CustomColor.blackColor,fontSize: 12,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                                     Text('Grow your monthly earnings Up to 1,00,000/-', style: TextStyle(color: CustomColor.greyColor,fontSize: 12,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
                                   ],
                                 ),
                               ),
                             ),
                           ],
                         ),
                         Row(
                           children: [
                             Expanded(
                               child: CustomContainer(
                                 border: true,
                                 borderColor: CustomColor.appColor,
                                 color: Colors.white,
                                 child:  Column(
                                   spacing: 5,
                                   children: [
                                     Icon(Icons.check_circle_outline_outlined, color:CustomColor.appColor,),
                                     Text('Monthly Fix Earning', style: TextStyle(color: CustomColor.blackColor,fontSize: 12,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                                     Text('Monthly fix earning ₹3,000', style: TextStyle(color: CustomColor.greyColor,fontSize: 12,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
                                   ],
                                 ),
                               ),
                             ),
                             Expanded(
                               child: CustomContainer(
                                 border: true,
                                 borderColor: CustomColor.appColor,
                                 color: Colors.white,
                                 child:  Column(
                                   spacing: 5,
                                   children: [
                                     Icon(Icons.check_circle_outline_outlined, color:CustomColor.appColor,),
                                     Text('Weekly Payout ', style: TextStyle(color: CustomColor.blackColor,fontSize: 12,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                                     Text('Fast and reliable weekly payouts', style: TextStyle(color: CustomColor.greyColor,fontSize: 12,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
                                   ],
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ],
                     )
                    ],
                  ),
                ),
                SizedBox(height: dimensions.screenHeight*0.02,),


              ],
            ),
          );
        }
        else if (state is UserError) {
          print('Error: ${state.massage}');
          return Center(child: Text('Try to sum time'));
          
        }
        return const SizedBox();
      },
    );
  }
}