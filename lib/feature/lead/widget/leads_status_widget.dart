import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/lead/lead_bloc.dart';
import '../bloc/lead/lead_state.dart';
import '../bloc/leads_status/lead_status_bloc.dart';
import '../bloc/leads_status/lead_status_event.dart';
import '../bloc/leads_status/lead_status_state.dart';
import '../repository/lead_status_repository.dart';

class LeadsStatusWidget extends StatefulWidget {
  final String checkoutId;
  const LeadsStatusWidget({super.key, required this.checkoutId});

  @override
  State<LeadsStatusWidget> createState() => _LeadsStatusWidgetState();
}

class _LeadsStatusWidgetState extends State<LeadsStatusWidget> {


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeadBloc, LeadState>(
      builder: (context, state) {
        if (state is LeadLoading) {
          return  LinearProgressIndicator(color: CustomColor.appColor,minHeight: 0.3,);
        } else if (state is LeadLoaded) {
          final lead = state.allLeads.firstWhere((l) => l.id == widget.checkoutId,);

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
                        Text(
                          '[ ${getLeadStatus(lead)} ]',
                          style: textStyle12(
                            context,
                            fontWeight: FontWeight.w400,
                            color: getStatusColor(lead),
                          ),
                        ),
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
                    bloc.add(FetchLeadStatusEvent(widget.checkoutId));
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
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Could not open Zoom link')),
                                                );
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

class PaymentWebViewScreen extends StatelessWidget {
  final String url;
  const PaymentWebViewScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Payment Now',
        showBackButton: true,
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(url),
        ),
        onLoadError: (controller, url, code, message) {
          if (ScaffoldMessenger.maybeOf(context) != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load payment page')),
            );
          }
        },
      ),
    );
  }
}


/// Lead Status
String getLeadStatus(dynamic lead) {
  if (lead == null) return 'Pending';
  if (lead.isCanceled == true) return 'Cancel';
  if (lead.isCompleted == true) return 'Completed';
  if (lead.isAccepted == true) return 'Accepted';
  return 'Pending';
}

/// Status Color
Color getStatusColor(dynamic lead) {
  if (lead == null) return Colors.grey;
  if (lead.isCanceled == true) return Colors.red;
  if (lead.isCompleted == true) return Colors.green;
  if (lead.isAccepted == true) return Colors.orange;
  return Colors.grey;
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
