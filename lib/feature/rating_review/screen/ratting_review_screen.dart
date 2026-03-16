import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_button.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/give_provider_review/give_provider_review_bloc.dart';
import '../bloc/give_provider_review/give_provider_review_event.dart';
import '../bloc/give_provider_review/give_provider_review_state.dart';

import '../bloc/give_service_review/give_service_review_bloc.dart';
import '../bloc/give_service_review/give_service_review_event.dart';
import '../bloc/give_service_review/give_service_review_state.dart';

import '../model/give_provider_review_model.dart';
import '../model/give_service_review_model.dart';

class RatingReviewScreen extends StatefulWidget {
  final String userId;
  final String serviceId;
  final String serviceName;
  final String providerId;
  final String checkoutId;

  const RatingReviewScreen({
    super.key,
    required this.userId,
    required this.serviceId,
    required this.serviceName,
    required this.providerId,
    required this.checkoutId,
  });

  @override
  State<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  int serviceRating = 0;
  int providerRating = 0;

  String serviceReview = '';
  String providerReview = '';

  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Ratings and Reviews',
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: MultiBlocListener(
          listeners: [
            BlocListener<GiveServiceReviewBloc, GiveServiceReviewState>(
              listener: (context, state) {
                if (state is GiveServiceReviewSuccess) {
                  _showSuccessDialog();
                }
                if (state is GiveServiceReviewFailure) {
                  print(state.error);
                  showCustomToast("Please Tray Again");
                }
              },
            ),
            BlocListener<GiveProviderReviewBloc, GiveProviderReviewState>(
              listener: (context, state) {
                if (state is GiveProviderReviewSuccess) {
                  _showSuccessDialog();
                }
                if (state is GiveProviderReviewFailure) {
                  print(state.error);
                  showCustomToast("Please Tray Again");
                }
              },
            ),
          ],
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomContainer(
                        border: true,
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Please tell us about service in your order",
                              style: TextStyle(
                                fontSize: 16,
                                color: CustomColor.descriptionColor,
                              ),
                            ),
                            12.height,
                            Row(
                              children: [
                                // Expanded(
                                //   child: CustomContainer(
                                //     margin: EdgeInsets.zero,
                                //     // assetsImg: CustomImage.thumbnailImage,
                                //     height: 90,
                                //   ),
                                // ),
                                // 12.width,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.serviceName??'Service Name', style: textStyle16(context)),
                                      8.height,
                                      Row(
                                        children: List.generate(
                                          5,
                                              (index) => GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                serviceRating = index + 1;
                                              });
                                            },
                                            child: Icon(
                                              Icons.star,
                                              size: 22,
                                              color: index < serviceRating
                                                  ? Colors.amber
                                                  : Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            12.height,
                            TextField(
                              minLines: 2,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              onChanged: (v) => serviceReview = v,
                              decoration: InputDecoration(
                                hintText: "Tell us about your experience",
                                contentPadding: const EdgeInsets.all(12),
                  
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                  
                          ],
                        ),
                      ),
                  
                      20.height,
                  
                      CustomContainer(
                        border: true,
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "How was your service provider experience?",
                              style: textStyle16(context),
                            ),
                            8.height,
                            Row(
                              children: List.generate(
                                5,
                                    (index) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      providerRating = index + 1;
                                    });
                                  },
                                  child: Icon(
                                    Icons.star,
                                    size: 22,
                                    color: index < providerRating
                                        ? Colors.amber
                                        : Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ),
                            12.height,
                            TextField(
                              maxLines: 2,
                              onChanged: (v) => providerReview = v,
                              decoration: InputDecoration(
                                hintText: "Tell us about your experience",
                                contentPadding: const EdgeInsets.all(12),
                  
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  
                    ],
                  ),
                ),
              ),

              BlocBuilder<GiveServiceReviewBloc, GiveServiceReviewState>(
                builder: (context, serviceState) {
                  return BlocBuilder<GiveProviderReviewBloc,
                      GiveProviderReviewState>(
                    builder: (context, providerState) {
                      final isLoading =
                          serviceState is GiveServiceReviewLoading ||
                              providerState is GiveProviderReviewLoading;

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomButton(
                          label: 'Submit',
                          isLoading: isLoading,
                          onPressed: isLoading
                              ? null
                              : () {
                            if (serviceRating == 0 &&
                                providerRating == 0) {
                              showCustomToast(
                                  "Please give at least one rating");
                              return;
                            }

                            /// FIRE SERVICE REVIEW
                            if (serviceRating > 0) {
                              context
                                  .read<GiveServiceReviewBloc>()
                                  .add(
                                GiveSubmitServiceReviewEvent(
                                  reviewModel:
                                  GiveServiceReviewModel(
                                    userId: widget.userId,
                                    serviceId: widget.serviceId,
                                    checkoutId: widget.checkoutId,
                                    isSkip: false,
                                    rating:
                                    serviceRating.toDouble(),
                                    comment: serviceReview,
                                  ),
                                ),
                              );
                            }

                            /// FIRE PROVIDER REVIEW
                            if (providerRating > 0) {
                              context
                                  .read<GiveProviderReviewBloc>()
                                  .add(
                                GiveSubmitProviderReviewEvent(
                                  reviewModel:
                                  GiveProviderReviewModel(
                                    userId: widget.userId,
                                    providerId:
                                    widget.providerId,
                                    checkoutId:
                                    widget.checkoutId,
                                    isSkip: false,
                                    rating:
                                    providerRating.toDouble(),
                                    comment: providerReview,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    if (_dialogShown) return;
    _dialogShown = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              16.height,
              Text(
                "Thank you!",
                style: textStyle16(context)
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              8.height,
              const Text(
                "Your review has been submitted successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              20.height,
              CustomButton(
                label: "Continue",
                onPressed: () {
                  Navigator.pop(context); // dialog
                  Navigator.pop(context); // screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
