import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_image.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/provider_review/provider_review_bloc.dart';
import '../bloc/provider_review/provider_review_event.dart';
import '../bloc/provider_review/provider_review_state.dart';
import '../repository/provider_review_repository.dart';

class ProviderReviewScreen extends StatelessWidget {
  final String providerId;

  const ProviderReviewScreen({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocProvider(
      create: (_) => ProviderReviewBloc(ProviderReviewRepository())..add(FetchProviderReviews(providerId)),
      child: BlocBuilder<ProviderReviewBloc, ProviderReviewState>(
        builder: (context, state) {
          if (state is ProviderReviewLoading) {
            return Column(
              children: [
                200.height,
                CircularProgressIndicator(color: CustomColor.appColor,),
              ],
            );
          } else if (state is ProviderReviewLoaded) {
            final reviewModel = state.reviews;
            final reviews = reviewModel.reviews;

            if (reviews.isEmpty) {
              return Padding(
                  padding: EdgeInsets.only(
                    top: dimensions.screenHeight * 0.25,
                  ),
                  child:  Center(child: Column(
                    children: [
                      Image.asset(CustomImage.emptyCart, height: dimensions.screenHeight*0.1,),
                      Text('No Reviews.'),
                    ],
                  )));
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        reviewModel.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                                  (i) => Icon(
                                i < reviewModel.averageRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              ),
                            ),
                          ),
                          Text("${reviewModel.totalReviews} reviews"),
                        ],
                      )
                    ],
                  ),

                  Column(
                    children: reviewModel.ratingDistribution.entries.map((e) {
                      final star = e.key;
                      final count = e.value;
                      final percent = reviewModel.totalReviews > 0
                          ? count / reviewModel.totalReviews
                          : 0.0;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text("$star ⭐"),
                            const SizedBox(width: 6),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percent,
                                minHeight: 8,
                                backgroundColor: Colors.grey[300],
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text("$count"),
                          ],
                        ),
                      );
                    }).toList(),
                  ),


                  Divider(color: Colors.grey,),

                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: reviews.length,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return CustomContainer(
                        color: CustomColor.whiteColor,
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: CustomColor.whiteColor,
                                  backgroundImage: AssetImage(CustomImage.nullImage),),
                                10.width,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(review.user.email ?? 'User'),
                                      Row(
                                        children: List.generate(5,
                                              (i) => Icon(
                                            i < review.rating
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                  
                                      Text(
                                        review.comment.isNotEmpty
                                            ? review.comment
                                            : "No comment",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                review.createdAt
                                    .toLocal()
                                    .toString()
                                    .split(" ")
                                    .first,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),


                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is ProviderReviewError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const Center(child: Text("No reviews yet"));
        },
      ),
    );
  }
}
