import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../internet/network_wrapper_screen.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';
import '../bloc/lead/lead_bloc.dart';
import '../bloc/lead/lead_event.dart';
import '../bloc/lead/lead_state.dart';
import '../bloc/share_one_commission/share_one_commission_bloc.dart';
import '../bloc/share_one_commission/share_one_commission_event.dart';
import '../bloc/share_one_commission/share_one_commission_state.dart';
import '../repository/share_one_commission_repository.dart';
import '../widget/leads_details_widget.dart';
import 'leads_details_screen.dart';

class LeadScreen extends StatefulWidget {
  const LeadScreen({super.key});

  @override
  State<LeadScreen> createState() => _LeadScreenState();
}

class _LeadScreenState extends State<LeadScreen> {

  final List<String> filters = ['All', 'Pending', 'Accepted', 'Completed', 'Cancel'];
  String selectedFilter = 'All';
  String searchQuery = '';


  String? lastUserId;
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userSession = Provider.of<UserSession>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userSession.isLoggedIn && userSession.userId != lastUserId) {
        lastUserId = userSession.userId;
        context.read<LeadBloc>().add(FetchLeadsByUser(lastUserId!));
      } else if (!userSession.isLoggedIn) {
        lastUserId = null;
        context.read<LeadBloc>().add(ClearLeadData());
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    Dimensions dimensions = Dimensions(context);

    final userSession = Provider.of<UserSession>(context);

    if (!userSession.isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Leads',),
        body: const Center(child: NoUserSignWidget()),
      );
    }

    return NetworkWrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFF5F8FF),
          toolbarHeight: 10,
        ),
        // appBar: CustomAppBar(title:'Leads'),
      
        body:  BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              if (userState is UserInitial || userState is UserLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (userState is UserError) {
                debugPrint('Error: ${userState.massage}');
              }
            if(userState is UserLoaded){

              final user = userState.user;
              return BlocBuilder<LeadBloc, LeadState>(
                builder: (context, state) {
                  if (state is LeadLoading) {
                    return _buildShimmer();
                  }
                  else if (state is LeadLoaded) {

                    final leads = state.filteredLeads.where((lead) {
                      if (searchQuery.isEmpty) return true;

                      final leadId = lead.bookingId?.toLowerCase() ?? '';
                      final serviceName =
                          lead.service?.serviceName?.toLowerCase() ?? '';

                      return leadId.contains(searchQuery) ||
                          serviceName.contains(searchQuery);
                    }).toList();


                    return RefreshIndicator(
                      color: CustomColor.appColor,
                      onRefresh: () async {
                        final userId = user.id.toString();
                        context.read<LeadBloc>().add(FetchLeadsByUser(userId));
                        await Future.delayed(const Duration(seconds: 1)); // optional
                      },
                      child: CustomScrollView(
                        slivers: [
                      
                          SliverAppBar(
                            pinned: true,
                            floating: true,
                            toolbarHeight: dimensions.screenHeight * 0.12,
                            backgroundColor: CustomColor.whiteColor,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                color: Color(0xFFF5F8FF),
                                child: Column(
                                  children: [
                      
                      
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Leads', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: CustomColor.appColor),),
                                          Text('All Leads - ${state.allLeads.length}', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: CustomColor.blackColor),),
                                        ],
                                      ),
                                    ),
                                    10.height,
                      
                                    Container(
                                      height: 44,
                                      margin: const EdgeInsets.all(16),
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.08),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                      
                                        ],
                                      ),
                                      child: TextField(
                                        textAlignVertical: TextAlignVertical.center,
                                        onChanged: (value) {
                                          setState(() {
                                            searchQuery = value.toLowerCase().trim();
                                          });
                                        },
                                        decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          hintText: 'Search by Lead ID or Service',
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Image.asset(
                                              CustomIcon.searchIcon,
                                              width: 18,
                                              height: 18,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      
                      
                          SliverToBoxAdapter(child: Column(
                            children: [
                              20.height,
                              SizedBox(
                                height: dimensions.screenHeight * 0.035,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: filters
                                      .map((filter) => _buildFilterChip(context, filter, state))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),),
                      
                          SliverToBoxAdapter(child: SizedBox(height: dimensions.screenHeight*0.010,),),
                      
                      
                          SliverToBoxAdapter(
                            child:  leads.isEmpty
                                ? Padding(
                                padding: EdgeInsetsGeometry.only(top: 280),
                                child:  Center(child: Column(
                                  children: [
                                    Image.asset(CustomImage.emptyCart, height: 80,),
                                    Text('No leads.'),
                                  ],
                                )))
                                : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              // itemCount: state.filteredLeads.length,
                              itemCount: leads.length,
                              padding: EdgeInsetsGeometry.symmetric(horizontal: dimensions.screenHeight*0.010),
                              itemBuilder: (context, index) {
                                // final lead = state.filteredLeads[index];
                      
                                final lead = leads[index];
                      
                                return CustomContainer(
                                  border: true,
                                  color: Colors.white,
                                  margin: EdgeInsets.only(top: dimensions.screenHeight*0.010),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            spacing: 5,
                                            children: [
                                              Text('Lead Id:', style: textStyle12(context, color: CustomColor.descriptionColor,fontWeight: FontWeight.w500)),
                                              Text('${lead.bookingId}', style: textStyle12(context, color: CustomColor.blackColor,fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF6F9FF),
                                              borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: Row(
                                              spacing: 5,
                                              children: [
                                                BlocProvider(create: (context) =>
                                                  ShareOneCommissionBloc(ShareOneCommissionRepository())..add(FetchShareOneCommission(lead.id!)),
                                                  child: BlocBuilder<ShareOneCommissionBloc, ShareOneCommissionState>(
                                                    builder: (context, state) {
                                                      if (state is ShareOneCommissionLoading) {
                                                        return const CircularProgressIndicator();
                                                      } else if (state is ShareOneCommissionLoaded) {
                                                        return Text('+ ${state.commission.share1}', style: textStyle12(context, color: CustomColor.appColor,fontWeight: FontWeight.w500));
                                                      } else if (state is ShareOneCommissionError) {
                                                        debugPrint('Commission error: ${state.message}');
                                                        return Text('+ ${0}', style: textStyle12(context, color: CustomColor.appColor,fontWeight: FontWeight.w500));
                                                      }
                                                      return const SizedBox();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                      
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text( lead.service?.serviceName ?? 'No Service Name', style: TextStyle(color: CustomColor.appColor, fontWeight: FontWeight.w600))),
                      
                                        ],
                                      ),
                                      5.height,
                                      Row(
                                        spacing: 5,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 3),
                                            decoration: BoxDecoration(
                                              color: getStatusColor(lead),
                                              borderRadius: BorderRadius.circular(8)
                                            ),
                                            child: Text(
                                              '${getLeadStatus(lead)}',
                                              style: TextStyle(fontSize: 10, color:getLeadStatus(lead) == 'Pending'? Colors.black: Colors.white,fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Row(
                                            spacing: 10,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              CustomAmountText(amount: '${lead.listingPrice!.toStringAsFixed(0)}',isLineThrough: true, color: Colors.grey.shade700, fontSize: 10),
                                              CustomAmountText(amount: '${lead.totalAmount!.toStringAsFixed(0)}',fontSize: 14),
                                              Text('${lead.serviceDiscount!.toStringAsFixed(0)}% OFF', style: TextStyle(fontSize: 14,color: Colors.green),)
                                            ],
                                          ),
                                        ],
                                      ),
                                      5.height,
                                      Divider(color: Colors.grey.shade200,),
                                      5.height,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('${formatDateTime(lead.createdAt)}', style: TextStyle(fontSize: 10, color: CustomColor.blackColor, fontWeight: FontWeight.w500)),
                                              Row(
                                                spacing: 5,
                                                children: [
                                                  Icon(Icons.calendar_month, size: 12,color: Colors.grey.shade700,),
                                                  Text('Booking Date', style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('${formatDateTime(lead.acceptedDate)}', style: TextStyle(fontSize: 10, color: CustomColor.blackColor, fontWeight: FontWeight.w500)),
                                              Row(
                                                spacing: 5,
                                                children: [
                                                  Icon(Icons.calendar_month, size: 12,color: Colors.grey.shade700,),
                                                  Text('Schedule Date', style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                            ],
                                          ),
                      
                                        ],
                                      ),
                                    ],
                                  ),
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LeadsDetailsScreen(
                                    leadName: lead.service!.serviceName,
                                    leadId: lead.id.toString(),
                                    user: user,
                                  ),)),
                                );
                              },
                            ),
                          ),
                      
                          SliverToBoxAdapter(child: SizedBox(height: dimensions.screenHeight*0.020,),)
                        ],
                      ),
                    );

                  }
                  else if (state is LeadError) {
                    print("❌ ${state.message}");
                    return Padding(
                        padding: EdgeInsetsGeometry.only(top: dimensions.screenHeight*0.25),
                        child:  Center(child: Column(
                          children: [
                            Image.asset(CustomImage.emptyCart, height: dimensions.screenHeight*0.1,),
                            Text('No leads.'),
                          ],
                        )));
                  }
                  return Padding(
                      padding: EdgeInsetsGeometry.only(top: dimensions.screenHeight*0.25),
                      child:  Center(child: Column(
                        children: [
                          Image.asset(CustomImage.emptyCart, height: dimensions.screenHeight*0.1,),
                          Text('No leads.'),
                        ],
                      )));
                },
              );
            }

              return SizedBox.shrink();

          }
        ),
      ),
    );
  }


  Widget _buildFilterChip(BuildContext context, String label, LeadLoaded state) {
    final isSelected = label == state.selectedFilter;
    int count;
    switch (label) {
      case 'Pending':
        count = state.allLeads
            .where((e) =>
        !(e.isAccepted ?? false) &&
            !(e.isCompleted ?? false) &&
            !(e.isCanceled ?? false))
            .length;
        break;
      case 'Accepted':
        count = state.allLeads
            .where((e) =>
        (e.isAccepted ?? false) &&
            !(e.isCompleted ?? false) &&
            !(e.isCanceled ?? false))
            .length;
        break;
      case 'Completed':
        count =
            state.allLeads.where((e) => (e.isCompleted ?? false)).length;
        break;
      case 'Cancel':
        count = state.allLeads.where((e) => (e.isCanceled ?? false)).length;
        break;
      default:
        count = state.allLeads.length;
    }

    return InkWell(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTap: () =>
          context.read<LeadBloc>().add(FilterLeads(label)),
      child: Container(
        margin: EdgeInsets.only(left: 16),
        padding: EdgeInsets.symmetric(horizontal:16,vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isSelected ? CustomColor.appColor : CustomColor.whiteColor,
          border: Border.all(color: isSelected ? CustomColor.appColor : CustomColor.blackColor, width: 0.5)
        ),
        child: Center(
          child: Text(
            '$label ${label == 'All' ? '':' ($count)'}',
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? CustomColor.whiteColor : CustomColor.blackColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}



Widget _buildShimmer() {
  return Column(
    children: [
      Container(
        color: CustomColor.whiteColor,
        padding: EdgeInsetsGeometry.only(bottom: 10),
        child: Row(children: List.generate(4, (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: ShimmerBox(height: 14,width: 80,)),
        ),),),
      ),
      Expanded(
        child: ListView(
          children: List.generate(
            6, (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomContainer(
              color: CustomColor.whiteColor,
              margin: EdgeInsetsGeometry.only(top: 10),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        ShimmerBox(height: 14, width: 120),
                        ShimmerBox(height: 14, width: 60),
                      ],
                    ),
                    5.height,
                    const ShimmerBox(height: 12, width: 180),
                    5.height,
                    const Divider(),
                    10.height,
                    // Dates & Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(height: 12, width: 140),
                            5.height,
                            ShimmerBox(height: 12, width: 140),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ShimmerBox(height: 12, width: 60),
                            5.height,
                            ShimmerBox(height: 14, width: 70),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ),
        ),
      ),
    ],
  );
}
