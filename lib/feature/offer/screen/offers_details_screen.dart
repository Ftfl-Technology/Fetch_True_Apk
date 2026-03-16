import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/feature/offer/model/offer_model.dart';

class OffersDetailsScreen extends StatelessWidget {
  final OfferModel offersFuture;
  const OffersDetailsScreen({super.key, required this.offersFuture});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: const CustomAppBar(
        showBackButton: true,
        title: "Offer Details",
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomContainer(
                      height: 450,
                      networkImg: offersFuture.bannerImage,
                      margin: EdgeInsets.zero,
                      borderRadius: false,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(offersFuture.serviceName, style: textStyle14(context)),
                          5.height,
                          Text('Valid From: ${dateFormat.format(offersFuture.offerStartTime)}', style: textStyle12(context)),
                          Text('Valid Till: ${dateFormat.format(offersFuture.offerEndTime)}', style: textStyle12(context)),
                          const Divider(),
                          10.height,

                          Text('(⭐) Grand prizes for top 50 Agents', style: textStyle14(context)),
                          10.height,
                          _buildGalleryImages(offersFuture.galleryImages),
                          10.height,
              
                          Row(
                            children: [
                              Icon(Icons.check_circle, size: 16, color: CustomColor.appColor,),10.width,
                              Text('Eligibility Criteria', style: textStyle14(context)),
                            ],
                          ),
                          Html(
                            data: offersFuture.eligibilityCriteria,
                            style: {
                              "body": Style(fontSize: FontSize(14.0), color: Colors.black87),
                            },
                          ),
                          10.height,
              
                          Row(
                            children: [
                              Icon(Icons.check_circle, size: 16, color: CustomColor.appColor,),10.width,
                              Text('How to Participate', style: textStyle14(context)),
                            ],
                          ),
                          Html(
                            data: offersFuture.howToParticipate,
                            style: {
                              "body": Style(fontSize: FontSize(14.0), color: Colors.black87),
                            },
                          ),
                          10.height,

                          Row(
                            children: [
                              Icon(Icons.check_circle, size: 16, color: CustomColor.appColor,),10.width,
                              Text('Terms & Conditions', style: textStyle14(context)),
                            ],
                          ),
                          Html(
                            data: offersFuture.termsAndConditions,
                            style: {
                              "body": Style(fontSize: FontSize(14.0), color: Colors.black87),
                            },
                          ),

                          Row(
                            children: [
                              Icon(Icons.check_circle, size: 16, color: CustomColor.appColor,),10.width,
                              Text('FAQs', style: textStyle14(context)),
                            ],
                          ),
                          ...offersFuture.faq.map((e) => Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,    // disables ripple
                              highlightColor: Colors.transparent, // disables highlight
                            ),
                            child: ExpansionTile(
                              backgroundColor: CustomColor.whiteColor,
                              iconColor: CustomColor.appColor,
                              shape: InputBorder.none,
                              childrenPadding: EdgeInsets.zero,
                              collapsedShape: InputBorder.none,
                              tilePadding: EdgeInsets.zero,
                              minTileHeight: 0,
                              title: Text(e.question, style: textStyle14(context)),
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Html(
                                        data: e.answer,
                                        style: {
                                          "body": Style(fontSize: FontSize(14.0), color: Colors.black87),
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                          10.height,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // CustomContainer(color: CustomColor.appColor,
            //   borderRadius: false,
            //   child: Center(child: Text("Share Referral Link", style: TextStyle(color: Colors.white))),
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryImages(List<String> images) {
    if (images.isEmpty) {
      return const Text("No gallery images found.", style: TextStyle(color: Colors.grey));
    }
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return CustomContainer(
            border: true,
            height: 100,width: 100,
            networkImg: images[index],
          );
        },
      ),
    );
  }
}
