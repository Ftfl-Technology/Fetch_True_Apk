import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/helper/Contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/formate_price.dart';
import '../../checkout/bloc/payu_gateway/payu_gateway_bloc.dart';
import '../../checkout/model/payu_gateway_model.dart';
import '../../checkout/repository/payu_gateway_repository.dart';
import '../../checkout/screen/payu_open_in_app_view_screen.dart';
import '../../customer/bloc/customer/customer_bloc.dart';
import '../../customer/bloc/customer/customer_event.dart';
import '../../customer/repository/customer_repository.dart';
import '../../profile/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/lead/lead_bloc.dart';
import '../bloc/lead/lead_event.dart';
import '../bloc/lead/lead_state.dart';
import '../bloc/leads_status/lead_status_bloc.dart';
import '../bloc/leads_status/lead_status_event.dart';
import '../bloc/leads_status/lead_status_state.dart';
import '../bloc/share_one_commission/share_one_commission_bloc.dart';
import '../bloc/share_one_commission/share_one_commission_event.dart';
import '../bloc/share_one_commission/share_one_commission_state.dart';
import '../model/lead_model.dart';
import '../repository/lead_status_repository.dart';
import '../repository/share_one_commission_repository.dart';
import 'package:intl/intl.dart';
import '../widget/leads_status_widget.dart' hide getLeadStatus, getStatusColor;
import '../widget/provider_card_widget.dart';


class LeadsDetailsScreen extends StatelessWidget {
  final String? leadName;
  final String leadId;
  final UserModel user;
  const LeadsDetailsScreen({super.key, this.leadName, required this.leadId, required this.user});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CustomerBloc(CustomerRepository())..add(GetCustomers())),
        BlocProvider(create: (_) => PayUGatewayBloc(PayUGatewayRepository())),
      ],
      child: BlocBuilder<LeadBloc, LeadState>(
        builder: (context, state) {
          if (state is LeadLoading) {
            return Scaffold(
              appBar: CustomAppBar(
                bColor: Color(0xFFF5F8FF),
                title: 'Details',
                showBackButton: true,
              ),
              backgroundColor: CustomColor.whiteColor,
              body: Column(
                children: [
                  LinearProgressIndicator(
                    color: CustomColor.appColor,
                    minHeight: 2,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            );
          }

          else if (state is LeadLoaded) {
            final lead = state.allLeads.firstWhere((l) => l.id == leadId,);

            if (lead == null) {
              return const Center(child: Text("Lead not found"));
            }
            return Scaffold(
              appBar: CustomAppBar(
                bColor: Color(0xFFF5F8FF),
                title: 'Details', showBackButton: true,),

              backgroundColor: CustomColor.whiteColor,
              body: DefaultTabController(
                length: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                    TabBar(
                      dividerColor: Colors.grey.shade300,
                      indicatorColor: CustomColor.appColor,

                      labelColor: CustomColor.appColor,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),

                      unselectedLabelColor: Colors.grey.shade600,
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),

                      tabs: const [
                        Tab(text: "Lead Details"),
                        Tab(text: "Status"),
                      ],
                    ),


                    Expanded(child: TabBarView(
                      children: [
                        LeadDetailsSection(lead: lead,user: user,),

                        LeadStatusSection(checkoutId: lead.id.toString(),),

                      ],
                    ))
                  ],
                ),
              ),
            );

          } else if (state is LeadError) {
            print("❌ ${state.message}");
            return const Center(child: Text("No data"));
          }
          return const Center(child: Text("No data"));
        },
      ),
    );

  }
}


class LeadDetailsSection extends StatelessWidget {
  final LeadModel lead;
  final UserModel user;
  const LeadDetailsSection({super.key, required this.lead, required this.user});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: CustomColor.appColor,
      onRefresh: () async {
        context.read<LeadBloc>().add(FetchLeadsByUser(user.id));
        await Future.delayed(const Duration(seconds: 1)); // opt
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.height,
            CustomContainer(
              border: true,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${lead.service!.serviceName}', style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                          Text('Lead ID: ${lead.bookingId}', style: TextStyle(color: Colors.grey.shade700,fontSize: 14,fontWeight: FontWeight.w500),),

                        ],
                      ),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                        decoration: BoxDecoration(
                          color: getStatusColor(lead),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text('${getLeadStatus(lead)}', style: TextStyle(color:getLeadStatus(lead) == 'Pending'? Colors.black: Colors.white,fontSize: 10, fontWeight: FontWeight.w600),),
                      )
                    ],
                  ),
                  10.height,

                  Divider(color: Colors.grey.shade200,),
                  10.height,

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

                  15.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisAlignment: lead.isCompleted == true ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                    children: [
                      if(lead.isAccepted == true)
                      Text('OTP: ${lead.otp}', style:  textStyle14(context,color: CustomColor.descriptionColor,fontWeight: FontWeight.w400),),
                      InkWell(
                        onTap: () async {
                          final url = Uri.parse('https://biz-booster.vercel.app/api/invoice/${lead.id}');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Row(
                          spacing: 5,
                          children: [
                            Text(
                              'Invoice Download',
                              style: TextStyle(fontSize: 10, color: CustomColor.appColor),
                            ),
                            Icon(Icons.save_alt,size: 12,color: CustomColor.appColor,),
                          ],
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),

            CustomContainer(
              color: Color(0xFFF5F8FF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('You will Earn Commission Up To', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: CustomColor.appColor),),
                  BlocProvider(create: (context) =>
                  ShareOneCommissionBloc(ShareOneCommissionRepository())..add(FetchShareOneCommission(lead.id!)),
                    child: BlocBuilder<ShareOneCommissionBloc, ShareOneCommissionState>(
                      builder: (context, state) {
                        if (state is ShareOneCommissionLoading) {
                          return const CircularProgressIndicator();
                        } else if (state is ShareOneCommissionLoaded) {
                          return Text('+ ${state.commission.share1}', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: CustomColor.appColor));
                        } else if (state is ShareOneCommissionError) {
                          print(state.message);
                          return Text('+ ${0}', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: CustomColor.appColor));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (_) =>  RatingReviewScreen(
              //         userId: user.id,
              //         serviceId: lead.service!.id!,
              //         serviceName: lead.service!.serviceName!,
              //         providerId: lead.provider!,
              //         checkoutId: lead.id!,
              //       ),
              //     ),
              //   );
              // },
            ),
            10.height,

            CustomContainer(
              border: true,
               color: Colors.white,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   if(lead.serviceCustomer != null)
                   Column(
                     children: [
                       Column(
                         spacing: 10,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text('Customer Details', style: TextStyle(fontWeight: FontWeight.w500),),

                               Row(
                                 spacing: 20,
                                 children: [
                                   InkWell(
                                       onTap: () {
                                         ContactHelper.whatsapp(lead.serviceCustomer!.phone.toString(), 'Hello, ${lead.serviceCustomer!.fullName}');
                                       },
                                       child: Image.asset(CustomIcon.whatsappIcon, height: 30,)),
                                   InkWell(
                                       onTap: () {
                                         ContactHelper.call(lead.serviceCustomer!.phone.toString());
                                       },
                                       child: Image.asset(CustomIcon.phoneIcon, height: 30,)),
                                 ],
                               )
                             ],
                           ),
                           Row(
                             children: [
                               Text('Name: ${lead.serviceCustomer!.fullName} ', style: TextStyle(fontSize: 12,color: Colors.grey.shade700),),
                               Text('', style: TextStyle(fontSize: 12,),)
                             ],
                           ),
                           Row(
                             spacing: 15,
                             children: [
                               Row(
                                 spacing: 5,
                                 children: [
                                   Image.asset(CustomIcon.phoneIcon,height: 12,color: CustomColor.appColor,),
                                   Text('${lead.serviceCustomer!.phone}', style: TextStyle(fontSize: 12,),)
                                 ],
                               ),
                               Row(
                                 spacing: 5,
                                 children: [
                                   Icon(Icons.email_outlined,size: 12,color: CustomColor.appColor,),
                                   Text('Email: ${lead.serviceCustomer!.email}', style: TextStyle(fontSize: 12,),)
                                 ],
                               ),
                             ],
                           ),

                           if(lead.notes!.isNotEmpty)
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Note', style: TextStyle(fontSize: 12,color: Colors.grey.shade700),),
                               Text('${lead.notes}', style: TextStyle(fontSize: 12,),)
                             ],
                           ),
                         ],
                       ),
                       10.height,
                       Divider(color: Colors.grey.shade200,),
                     ],
                   ),
                   10.height,

                   Text('Transaction Details', style: TextStyle(fontWeight: FontWeight.w500),),
                   10.height,

                   Column(
                     spacing: 5,
                     children: [
                       _buildRow(
                         context,
                         title: 'Listing Price',
                         amount: '₹ ${lead.listingPrice?.toStringAsFixed(2)}',
                       ),
                       _buildRow(
                         context,
                         title: 'Service Discount (${lead.serviceDiscount}%)',
                         amount: '- ₹ ${lead.serviceDiscountPrice?.toStringAsFixed(2)}',
                       ),
                       _buildRow(
                         context,
                         title: 'Price After Discount',
                         amount: '₹ ${lead.priceAfterDiscount!.toStringAsFixed(2)}',
                       ),

                       if(lead.couponDiscount!=0)
                         _buildRow(
                           context,
                           title: 'Coupon Discount (${lead.couponDiscount}${lead.couponDiscountType})',
                           amount: '- ₹ ${lead.couponDiscountPrice?.toStringAsFixed(2)}',
                         ),
                       _buildRow(
                         context,
                         title: 'Service GST (${lead.gst}%)',
                         amount: '+ ₹ ${lead.serviceGSTPrice?.toStringAsFixed(2)}',
                       ),
                       _buildRow(
                         context,
                         title: 'Platform Fee (₹ ${lead.platformFee})',
                         amount: '+ ₹ ${lead.platformFeePrice?.toStringAsFixed(2)}',
                       ),
                       _buildRow(
                         context,
                         title: 'Fetch True Assurity Charges (${lead.assurityfee} %)',
                         amount: '+ ₹ ${lead.assurityChargesPrice?.toStringAsFixed(2)}',
                       ),

                       10.height,
                       CustomContainer(
                         color: Color(0xFFF5F8FF),
                         margin: EdgeInsets.zero,
                         child:  Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Grand Total', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500, color: CustomColor.appColor),),
                             Text('₹ ${lead.totalAmount?.toStringAsFixed(2)}', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: CustomColor.appColor),),
                           ],
                         )
                       ),
                     ],
                   )
                 ],
               ),
            ),
           20.height,

           if(lead.paymentStatus != null)
           Column(
             children: [
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text('Payment Status', style: TextStyle(fontWeight: FontWeight.w500),),
                     Row(
                       spacing: 5,
                       children: [
                         Icon(Icons.circle,size: 12,color: Colors.orange,),
                         // Text('${lead.paymentStatus}', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),

                         Text(
                           (lead.paymentStatus ?? '').isNotEmpty
                               ? (lead.paymentStatus ?? '')[0].toUpperCase() +
                               (lead.paymentStatus ?? '').substring(1)
                               : '',
                           style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                         ),

                       ],
                     ),
                   ],
                 ),
               ),

               CustomContainer(
                 color: Color(0xFFFEF5EC),
                 child: Column(
                   children: [
                     _buildRow(
                       context,
                       title: 'Service Amount',
                       amount: '₹ ${lead.totalAmount!.toStringAsFixed(2)}',
                     ),
                     _buildRow(
                       context,
                       title: 'Paid Amount',
                       amount: '₹ ${lead.paidAmount!.toStringAsFixed(2)}',
                     ),

                     if(lead.isPartialPayment == true)
                     _buildRow(
                       context,
                       title: 'Remaing Amount',
                       amount: '₹ ${lead.remainingAmount!.toStringAsFixed(2)}',
                     ),
                     10.height,

                     if(lead.paymentStatus != 'paid')
                       BlocConsumer<PayUGatewayBloc, PayUGatewayState>(
                         listener: (context, payuState) {
                           if (payuState is PayUGatewaySuccess) {
                             final paymentUrl = payuState.response.result?.paymentLink ?? "";
                             if (paymentUrl.isNotEmpty) {
                               openInAppWebView(
                                 context,
                                 paymentUrl,
                                     () {
                                   context.read<LeadBloc>().add(FetchLeadsByUser(lead.user.toString()),);
                                 },
                               );                           }
                             else {
                               showCustomToast("Payment link not found");
                             }
                           } else if (payuState is PayUGatewayFailure) {
                             showCustomToast(payuState.message);
                           }
                         },
                         builder: (context, payuState) {
                           final isLoading = payuState is PayUGatewayLoading;

                           return  SizedBox(
                             child: CustomButton(
                               isLoading: isLoading,
                               label: 'Pay Now',
                               onPressed: () {
                                 final timestamp = DateTime.now().millisecondsSinceEpoch;
                                 final orderId = "checkout_$timestamp";
                                 final amountToPay = lead.isPartialPayment == true
                                     ? lead.remainingAmount!
                                     : lead.totalAmount!;

                                 final payuModel = PayUGatewayModel(
                                   subAmount: amountToPay,
                                   // subAmount: double.parse(lead.totalAmount!.toStringAsFixed(0)),
                                   isPartialPaymentAllowed: false,
                                   description: "Service Payment",
                                   orderId: orderId,
                                   customer: PayUCustomer(
                                     customerId:user.id,
                                     customerName: user.fullName,
                                     customerEmail: user.email,
                                     customerPhone: user.mobileNumber,
                                   ),
                                   udf: PayUUdf(
                                     udf1: orderId,
                                     udf2: lead.id.toString(),
                                     udf3: user.id,
                                   ),
                                 );
                                 context.read<PayUGatewayBloc>().add(CreatePayULinkEvent(payuModel));
                               },
                             ),
                           );
                         },
                       ),
                   ],
                 ),
               ),

                if(lead.provider != null)
                 ProviderCardWidget(providerId: lead.provider),

               20.height,
             ],
           ),
            20.height,


          ],
        ),
      ),
    );
  }
}

class LeadStatusSection extends StatelessWidget {
  final String checkoutId;
  const LeadStatusSection({super.key, required this.checkoutId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeadBloc, LeadState>(
      builder: (context, state) {
        if (state is LeadLoading) {
          return  LinearProgressIndicator(color: CustomColor.appColor,minHeight: 0.3,);
        } else if (state is LeadLoaded) {
          final lead = state.allLeads.firstWhere((l) => l.id == checkoutId,);

          if (lead == null) {
            return const Center(child: Text("Lead not found"));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Booking Status :',
                          style: textStyle12(context),
                        ),
                        10.width,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                          decoration: BoxDecoration(
                              color: getStatusColor(lead),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text('${getLeadStatus(lead)}', style: TextStyle(color:getLeadStatus(lead) == 'Pending'? Colors.black: Colors.white,fontSize: 10, fontWeight: FontWeight.w600),),
                        )
                      ],
                    ),
                    5.height,
                    _iconText(
                      context,
                      icon: Icons.calendar_month,
                      text: 'Booking Date : ${formatDateTime(lead.createdAt)}',
                    ),
                    _iconText(
                      context,
                      icon: Icons.calendar_month,
                      text: 'Schedule Date: ${formatDateTime(lead.acceptedDate)}',
                    ),
                  ],
                ),
              ),

              Expanded(
                child: BlocProvider(
                  create: (_) {
                    final bloc = LeadStatusBloc(LeadStatusRepository());
                    bloc.add(FetchLeadStatusEvent(checkoutId));
                    return bloc;
                  },
                  child: BlocBuilder<LeadStatusBloc, LeadStatusState>(
                    builder: (context, state) {
                      if (state is LeadStatusLoading) {
                        return  Align(
                            alignment: Alignment.topCenter,
                            child: LinearProgressIndicator(color: CustomColor.appColor,minHeight: 2,));
                      } else if (state is LeadStatusLoaded) {
                        final leadData = state.leadStatus;


                        if (leadData.leads.isEmpty) {
                          return SizedBox.shrink();
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: leadData.leads.length,
                          itemBuilder: (context, index) {
                            final lead = leadData.leads[index];
                            final isLast = index == leadData.leads.length - 1;

                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Status Icon + Line
                                  Column(
                                    children: [
                                      const Icon(Icons.check_circle,
                                          color: Colors.green, size: 18),
                                      if (lead.statusType != 'Lead completed' && !isLast)
                                        Expanded(
                                          child: Container(
                                            width: 3,
                                            decoration: BoxDecoration(
                                              color: CustomColor.appColor.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  10.width,
                                  /// Status Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(lead.statusType, style: textStyle12(context)),

                                        Row(
                                          children: [
                                            Text(
                                              "Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(lead.createdAt.toLocal())}",
                                              style: textStyle12(
                                                context,
                                                color: CustomColor.descriptionColor,
                                              ),
                                            ),
                                            10.width,
                                            Text(
                                              '( Provider )',
                                              style: textStyle12(
                                                context,
                                                color: CustomColor.descriptionColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        5.height,

                                        if (lead.description.isNotEmpty)
                                          Text(lead.description,
                                              style: const TextStyle(fontSize: 14)),

                                        if (lead.zoomLink != null && lead.zoomLink!.isNotEmpty)
                                          InkWell(
                                            onTap: () async {
                                              final url = lead.zoomLink!;
                                              if (await canLaunchUrl(Uri.parse(url))) {
                                                await launchUrl(Uri.parse(url));
                                              } else {
                                                showCustomToast('Could not open Zoom link');
                                              }
                                            },
                                            child: CustomContainer(
                                              width: 300,
                                              child: Row(
                                                children: [
                                                  Icon(Icons.videocam,
                                                      color: CustomColor.appColor),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      "Zoom: ${lead.zoomLink}",
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        5.height,

                                        if (lead.document != null && lead.document!.isNotEmpty)
                                          InkWell(
                                            onTap: () async {
                                              final url = lead.document!;
                                              if (await canLaunchUrl(Uri.parse(url))) {
                                                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Could not open document')),
                                                );
                                              }
                                            },
                                            child: CustomContainer(
                                              width: 300,
                                              child: Row(
                                                children: [
                                                  Icon(Icons.insert_drive_file, color: CustomColor.appColor),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      "Document: ${lead.document!.split('/').last}",
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontSize: 13),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        5.height,


                                        if (lead.paymentLink != null && lead.paymentLink!.isNotEmpty)
                                          CustomContainer(
                                            width: 300,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.payment,
                                                        color: Colors.green),
                                                    10.width,
                                                    Text("Payment: ${lead.paymentType ?? ''}"),
                                                  ],
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PaymentWebViewScreen(
                                                              url: lead.paymentLink!,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "Pay Now",
                                                    style: textStyle14(
                                                      context,
                                                      color: CustomColor.appColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                        15.height,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (state is LeadStatusError) {
                        // return Center(child: Text("Error: ${state.message}"));
                        print(state.message);
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          );

        } else if (state is LeadError) {
          // return Center(child: Text("❌ ${state.message}"));
          print(state.message);
        }
        return const Center(child: Text("No data"));
      },
    );
  }
}


Widget _buildRow(BuildContext context, {required String title, required String amount,}){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400, color: Colors.grey.shade700),),
      Text(amount, style: textStyle12(context,fontWeight: FontWeight.w400),),
    ],
  );
}

Widget _iconText(
    BuildContext context, {
      IconData? icon,
      double? iconSize,
      Color? iconColor,
      String? text,
      Color? textColor,
      FontWeight? fontWeight,
    }) {
  if (icon == null || text == null) return const SizedBox();
  return Row(
    spacing: 10,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Icon(icon, size: iconSize ?? 16, color: iconColor ?? Colors.grey),
      Expanded(
        child: Text(
          text,
          style: textStyle12(
            context,
            color: textColor ?? CustomColor.descriptionColor,
            fontWeight: fontWeight ?? FontWeight.w400,
          ),
        ),
      )
    ],
  );
}

/// Lead Status
String getLeadStatus(lead) {
  if (lead.isCanceled == true) return 'Cancel';
  if (lead.isCompleted == true) return 'Completed';
  if (lead.isAccepted == true) return 'Accepted';
  return 'Pending';
}

/// Status Color
Color getStatusColor(lead) {
  if (lead.isCanceled == true) return Color(0xFFCE281C);
  if (lead.isCompleted == true) return Color(0xFF2F965C);
  if (lead.isAccepted == true) return Color(0xFFF48A21);
  return Color(0xFFEFEFEF);
}