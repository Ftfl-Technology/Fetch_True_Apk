

import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/shimmer_box.dart';
import 'package:fetchtrue/helper/Contact_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../lead/bloc/lead/lead_bloc.dart';
import '../../lead/bloc/lead/lead_event.dart';
import '../../lead/bloc/lead/lead_state.dart';
import '../../lead/bloc/team_lead/team_lead_bloc.dart';
import '../../lead/bloc/team_lead/team_lead_event.dart';
import '../../lead/bloc/team_lead/team_lead_state.dart';
import '../../lead/repository/lead_repository.dart';

class TeamCardWidget extends StatefulWidget {
 final ImageProvider<Object>? backgroundImage;
 final double? radius;
 final String? name;
 final String? phone;
 final String? id;
 final String? memberId;
 final String? level;
 final bool? status;
 final String? address;
 final String? earning;
 final VoidCallback? onTap;
  const TeamCardWidget({super.key, this.backgroundImage, this.name, this.phone, this.id, this.level, this.radius, this.address, this.earning, this.memberId, this.onTap, this.status,
  });

  @override
  State<TeamCardWidget> createState() => _TeamCardWidgetState();
}

class _TeamCardWidgetState extends State<TeamCardWidget> {


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.only(top: dimensions.screenHeight*0.01),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: Colors.grey,width: 0.1),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.05),
          //     blurRadius: 8,
          //     spreadRadius: 1,
          //     offset: Offset(0, 3), // neeche halka shadow
          //   ),
          // ],
        ),

        child: Column(
          spacing: 16,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    CircleAvatar(
                      radius:30,
                      backgroundColor: CustomColor.whiteColor,
                      backgroundImage: widget.backgroundImage,
                    ),
                    Column(
                      spacing: 3,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(widget.name?? 'Guest', style: TextStyle(fontWeight: FontWeight.w500),),
                        Text('ID ${widget.memberId ?? 'XXXXX'}',style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.w500),),
                        Text('Level: ${widget.level!}', style: textStyle12(context, color: CustomColor.appColor,fontWeight: FontWeight.w400),),
                      ],
                    ),
                  ],
                ),

                Container(height: 60,width: 1,color: Colors.grey,),

                BlocProvider(
                  create: (context) => TeamLeadBloc(LeadRepository())..add(GetTeamLeadsByUser(widget.id!)),
                  child: BlocBuilder<TeamLeadBloc, TeamLeadState>(
                    builder: (context, state) {
                      if (state is TeamLeadLoading) {
                        return _leadShimmer();
                      } else if (state is TeamLeadLoaded) {
                        final allLeads = state.leadModel ?? [];

                        final acceptedLeads = allLeads.where((e) => e.isAccepted == true && e.isCompleted == false && e.isCanceled == false).toList();
                        final completedLeads = allLeads.where((e) => e.isCompleted == true).toList();


                        return Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: CustomColor.appColor)
                                    ),
                                    child: Text('${allLeads.length}', textAlign: TextAlign.center,style: textStyle14(context, color: CustomColor.appColor),)),
                                Text('Leads', textAlign: TextAlign.center,style: TextStyle(fontSize: 12, color: CustomColor.blackColor),),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Color(0xffFF9A55))
                                    ),
                                    child: Text('${acceptedLeads.length}', textAlign: TextAlign.center,style: textStyle14(context, color: Color(0xffFF9A55)),)),
                                Text('Accepted', textAlign: TextAlign.center,style: TextStyle(fontSize: 12, color: CustomColor.blackColor),),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.green)
                                    ),
                                    child: Text('${completedLeads.length}', textAlign: TextAlign.center,style: textStyle14(context, color: CustomColor.greenColor,),)),
                                Text('Completed', textAlign: TextAlign.center,style: TextStyle(fontSize: 12, color: CustomColor.blackColor),),
                              ],
                            ),
                          ],
                        );

                      } else if (state is TeamLeadError) {
                        print('"❌ ${state.message}"');
                        return SizedBox.shrink();
                        // return Center(child: Text("❌ ${state.message}"));
                      }
                      return SizedBox.shrink();
                    },
                  ),
                )

              ],
            ),

            Container(

                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  // border: Border.all(color: CustomColor.greenColor,width: 0.3)
                ),
                padding: EdgeInsets.symmetric(horizontal: dimensions.screenHeight*0.02,vertical: dimensions.screenHeight*0.01),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Earning:', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.blackColor),textAlign: TextAlign.end,),
                        Text(' ${widget.level == 'Non-GP' ? '\u20B9 ${widget.earning}' : '\u20B9 ${widget.earning}'}', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),textAlign: TextAlign.end,),

                      ],
                    ),
                   Row(
                      spacing: 25,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () => ContactHelper.call('+91${widget.phone}'),
                            child: Image.asset(CustomIcon.phoneIcon, height: 25,color: CustomColor.appColor,)),


                        InkWell(
                            onTap: () => ContactHelper.whatsapp('+91${widget.phone}', 'Hello ${widget.name}!'),
                            child: Image.asset(CustomIcon.whatsappIcon, height: 25,color: CustomColor.greenColor,)),
                      ],
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}


Widget _leadShimmer(){
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
       Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           ShimmerBox(height: 10, width: 15),
           8.height,
           ShimmerBox(height: 10, width: 50),
         ],
       ) ,
       Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           ShimmerBox(height: 10, width: 15),
           8.height,
           ShimmerBox(height: 10, width: 50),
         ],
       ) ,
       Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           ShimmerBox(height: 10, width: 15),
           8.height,
           ShimmerBox(height: 10, width: 50),
         ],
       ) ,
      ],
    ),
  );
}