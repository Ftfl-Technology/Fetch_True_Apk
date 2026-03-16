import 'package:dotted_border/dotted_border.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:fetchtrue/feature/team_build/screen/team_leads_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../lead/bloc/team_lead/team_lead_bloc.dart';
import '../../lead/bloc/team_lead/team_lead_event.dart';
import '../../lead/bloc/team_lead/team_lead_state.dart';
import '../../lead/repository/lead_repository.dart';
import '../../lead/screen/leads_details_screen.dart';
import '../bloc/upcoming_lead_commission/upcoming_lead_commission_bloc.dart';
import '../bloc/upcoming_lead_commission/upcoming_lead_commission_event.dart';
import '../bloc/upcoming_lead_commission/upcoming_lead_commission_state.dart';
import '../model/my_team_model.dart';
import '../repository/upcoming_lead_commission_repository.dart';
import '../widget/team_card_widget.dart';

class TeamMemberScreen extends StatelessWidget {
  final MyTeamModel members;
  const TeamMemberScreen({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    final member = members.user;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Team Member', showBackButton: true,),

      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                TeamCardWidget(
                  radius: 25,
                  backgroundImage: member!.profilePhoto != null && member.profilePhoto!.isNotEmpty
                      ? NetworkImage(member.profilePhoto!)
                      :  AssetImage(CustomImage.nullImage) as ImageProvider,
                  id: member!.id,
                  memberId: member.userId,
                  name: member.fullName,
                  // level: member.packageStatus,
                  level: member.packageStatus== 'nonGP'?'Non-GP':member.packageStatus,
                  status: member.isDeleted,
                  address: _getMemberAddress(member),
                  phone: member.mobileNumber,
                  earning: members.totalEarningsFromShare2?.toStringAsFixed(2),
                  // earning: 'My Earning\n₹ ${members.totalEarningsFromShare2?.toStringAsFixed(2)}',
                ),

                TabBar(
                  indicatorColor: CustomColor.appColor,
                  labelColor: CustomColor.appColor,
                  unselectedLabelColor: Colors.grey,
                  dividerColor: WidgetStateColor.transparent,
                  tabs: [
                    Tab(text: 'Leads (${members.leads.length})'),
                    Tab(text: 'Teams (${members.team.length})'),
                  ],
                ),

                Expanded(
                  child: BlocProvider(
                    create: (context) => TeamLeadBloc(LeadRepository())..add(GetTeamLeadsByUser(member.id)),
                    child: TabBarView(
                     children: [
                       members.leads.isNotEmpty ? _MemberLeads(leadsData: members.leads,):
                       Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(Icons.leaderboard, color: CustomColor.iconColor,size: 50,),
                           Text("No Leads"),
                         ],
                       ),

                       members.team.isNotEmpty ? _TeamMembers(members: members.team,):
                       Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Icon(CupertinoIcons.person_2_fill, color: CustomColor.iconColor,size: 50,),
                           Text("No Member"),
                         ],
                       )
                     ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMemberAddress(User member) {
    Address? address;

    if (member.homeAddress != null &&
        _isAddressValid(member.homeAddress!)) {
      address = member.homeAddress;
    } else if (member.workAddress != null &&
        _isAddressValid(member.workAddress!)) {
      address = member.workAddress;
    } else if (member.otherAddress != null &&
        _isAddressValid(member.otherAddress!)) {
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


/// _MemberLeads
class _MemberLeads extends StatelessWidget {
  final List<Lead> leadsData;
  const _MemberLeads({super.key, required this.leadsData});

  @override
  Widget build(BuildContext context) {


    return BlocBuilder<TeamLeadBloc, TeamLeadState>(
      builder: (context, state) {
        if (state is TeamLeadLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is TeamLeadLoaded) {
          final allLeads = state.leadModel ?? [];

          return ListView.builder(
            itemCount: allLeads.length,
            itemBuilder: (context, index) {
              final leads = allLeads[index];
              final leadId = leads.id;
              final leadCommission = leadsData.cast<Lead?>().firstWhere(
                    (e) => e?.checkoutId == leadId,
                orElse: () => null,
              );


            return CustomContainer(
              border: true,
              color: CustomColor.whiteColor,
              margin: EdgeInsetsGeometry.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Expanded(
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               spacing: 5,
                               children: [
                                 Text('Booking ID:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),),
                                 Text('${leads.bookingId}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),),
                               ],
                             ),
                             Text(leads.service!.serviceName.toString(), style: TextStyle(color: CustomColor.appColor,fontSize: 14, fontWeight: FontWeight.w600),),
                         
                             10.height,
                             CustomContainer(
                                 color: getStatusColor(leads),
                                 margin: EdgeInsets.zero,
                                 padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                                 child: Text('${getLeadStatus(leads)}', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: getLeadStatus(leads) == 'Pending'? Colors.black: Colors.white),)),
                           ],
                         ),
                       ),

                       Column(
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: [
                           if (leadCommission != null && leadId != null)
                             BlocProvider(
                               create: (context) => UpcomingCommissionBloc(UpcomingLeadCommissionRepository())
                                 ..add(FetchUpcomingCommission(leadId)),
                               child: BlocBuilder<UpcomingCommissionBloc, UpcomingCommissionState>(
                                 builder: (context, state) {
                                   if (state is UpcomingCommissionLoading) {
                                     return SizedBox(
                                       height: 20,
                                       width: 20,
                                       child: Center(
                                         child: CircularProgressIndicator(
                                           strokeWidth: 3,
                                           color: CustomColor.appColor,
                                         ),
                                       ),
                                     );
                                   }
                                   else if (state is UpcomingCommissionLoaded) {
                                     final data = state.commission.data;
                                     return CustomContainer(
                                       color: Colors.blue.shade50.withOpacity(0.2),
                                       margin: EdgeInsets.zero,
                                       child: Column(
                                         children: [
                                           if (!(leads.isAccepted ?? false))
                                             Text(
                                               '+ 00',
                                               style: textStyle12(
                                                 context,
                                                 fontWeight: FontWeight.w400,
                                                 color: CustomColor.appColor,
                                               ),
                                               textAlign: TextAlign.end,
                                             ),
                                           if ((leads.isAccepted ?? false) && !(leads.isCompleted ?? false))
                                             Text(
                                               '+ ${data?.share2?.toStringAsFixed(2) ?? "+ 00"}',
                                               style: textStyle12(
                                                 context,
                                                 fontWeight: FontWeight.w400,
                                                 color: CustomColor.appColor,
                                               ),
                                               textAlign: TextAlign.end,
                                             ),
                                           if (leads.isCompleted ?? false)
                                             Text(
                                               '+ ${leadCommission.commissionEarned?.toStringAsFixed(2) ?? "+ 00"}',
                                               style: textStyle12(
                                                 context,
                                                 fontWeight: FontWeight.w400,
                                                 color: CustomColor.appColor,
                                               ),
                                               textAlign: TextAlign.end,
                                             ),
                                         ],
                                       ),
                                     );
                                   }
                                   else if (state is UpcomingCommissionError) {
                                     return Text(
                                       '+ 00',
                                       style: textStyle12(
                                         context,
                                         fontWeight: FontWeight.w400,
                                         color: CustomColor.appColor,
                                       ),
                                       textAlign: TextAlign.end,
                                     );
                                   }
                                   return SizedBox.shrink();
                                 },
                               ),
                             ),

                           Row(
                             spacing: 10,
                             children: [
                               CustomAmountText(amount: formatPrice(leads.priceAfterDiscount!),isLineThrough: false,fontSize: 14,fontWeight: FontWeight.w500),
                               CustomAmountText(amount: leads.listingPrice.toString(),isLineThrough: true,color: Colors.grey.shade700),
                               Text('${leads.serviceDiscount}% Off', style: TextStyle(fontSize: 10, color: CustomColor.greenColor,fontWeight: FontWeight.w500),),
                             ],
                           ),
                         ],
                       )
                     ],
                   ),

                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('${formatDateTime(leads.createdAt)}', style: textStyle12(context, fontWeight: FontWeight.w500),),
                            Row(
                              spacing: 5,
                              children: [
                                Icon(Icons.calendar_month, size: 14,color: Colors.grey,),
                                Text('Booking Date', style: textStyle12(context, color:Colors.grey),),
                              ],
                            ),

                          ],
                        ),
                        Column(
                          children: [
                            Text('${formatDateTime(leads.acceptedDate)}',style: textStyle12(context, fontWeight: FontWeight.w500),),
                            Row(
                              spacing: 5,
                              children: [
                                Icon(Icons.calendar_month, size: 14,color: Colors.grey,),
                                Text('Schedule Date', style: textStyle12(context, color: Colors.grey),),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },);

        } else if (state is TeamLeadError) {
          return Center(child: Text("❌ ${state.message}"));
        }
        return const Center(child: Text("No data"));
      },
    );
  }


}

/// _TeamMembers
class _TeamMembers extends StatelessWidget {
  final List<SubTeam> members;
  const _TeamMembers({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: members.length,
      // padding: EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (context, index) {

        final member = members[index].user;
        final teamCommission = members[index].totalEarningsFromShare3;
        final leadsData = members[index].leads;

        return TeamCardWidget(
          radius: 25,
          backgroundImage: member!.profilePhoto != null && member.profilePhoto!.isNotEmpty
              ? NetworkImage(member.profilePhoto!)
              :  AssetImage(CustomImage.nullImage) as ImageProvider,
          id: member!.id,
          memberId: member.userId,
          name: member.fullName,
          level: member.packageStatus== 'nonGP'?'Non-GP':member.packageStatus,
          status: member.isDeleted,
          address: _getMemberAddress(member),
          phone: member.mobileNumber,
          earning: teamCommission?.toStringAsFixed(2),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TeamLeadsScreen(
                  member: member,
                  earning: teamCommission.toString(),
                  leadsData: leadsData,
                ),
              ),
            );
          },
        );
      },);
  }

  String _getMemberAddress(User member) {
    Address? address;

    if (member.homeAddress != null &&
        _isAddressValid(member.homeAddress!)) {
      address = member.homeAddress;
    } else if (member.workAddress != null &&
        _isAddressValid(member.workAddress!)) {
      address = member.workAddress;
    } else if (member.otherAddress != null &&
        _isAddressValid(member.otherAddress!)) {
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




