import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/servicereview/servicereview_bloc.dart';
import '../bloc/servicereview/servicereview_event.dart';
import '../bloc/servicereview/servicereview_state.dart';
import '../model/service_review_model.dart';
import '../../service/repository/service_review_service.dart';

class ReviewRatingCardWidget extends StatelessWidget {
  final Color? color;
  final Color? cardColor;

  const ReviewRatingCardWidget({
    super.key,
    this.color,
    this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<ServiceReviewBloc, ServiceReviewState>(
        builder: (context, state) {
          if (state is ServiceReviewLoading ||
              state is ServiceReviewInitial) {
            return const SizedBox.shrink();
          }

          if (state is ServiceReviewError) {
            return const SizedBox.shrink();
          }

          if (state is ServiceReviewLoaded) {
            final data = state.data;
            final ratingDist = data.ratingDistribution;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reviews & Rating",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                10.height,

                _buildCard(cardColor,data, ratingDist),

              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCard(
      Color? cardColor,
      ServiceReviewResponse data,
      Map<int, int> ratingDist,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor ?? Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Complete overview of franchise requirements and benefits.",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RatingSummary(
                averageRating: data.averageRating,
                totalReviews: data.totalReviews,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _RatingProgress(
                  ratingDistribution: ratingDist,
                  totalReviews: data.totalReviews,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "Rating by",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              RatingCircle(title: "Monthly\nBusiness", rating: "0/0"),
              RatingCircle(title: "ROI", rating: "0/0"),
              RatingCircle(title: "Marketing", rating: "0/0"),
              RatingCircle(title: "Franchise\nService", rating: "0/0"),
            ],
          ),
        ],
      ),
    );
  }
}


class _RatingSummary extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  const _RatingSummary({
    required this.averageRating,
    required this.totalReviews,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children:  [
            Text(averageRating.toStringAsFixed(1),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 4),
            Icon(Icons.star, color: Colors.amber, size: 20),
          ],
        ),
        const SizedBox(height: 4),
        Column(
          children: [
             Text(
              "${totalReviews}",
              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),
            ),
             Text(
              "Ratings",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ],
    );
  }
}

class _RatingProgress extends StatelessWidget {
  final Map<int, int> ratingDistribution;
  final int totalReviews;

  const _RatingProgress({
    required this.ratingDistribution,
    required this.totalReviews,
  });

  @override
  Widget build(BuildContext context) {
    List<int> ratings = [5, 4, 3, 2, 1];

    return Column(
      children: ratings.map((star) {
        final count = ratingDistribution[star] ?? 0;
        final value = totalReviews == 0 ? 0 : count / totalReviews;

        return RatingBarRow(
          title: "$star Star",
          value: value.toDouble(),
          count: count.toString(),
          color: star >= 4
              ? Colors.green
              : star == 3
              ? Colors.orange
              : Colors.red,
        );
      }).toList(),
    );
  }
}

class RatingBarRow extends StatelessWidget {
  final String title;
  final double value;
  final String count;
  final Color color;

  const RatingBarRow({
    super.key,
    required this.title,
    required this.value,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(title, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(width: 8),
          Text(count, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class RatingCircle extends StatelessWidget {
  final String title;
  final String rating;

  const RatingCircle({
    super.key,
    required this.title,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: double.parse(rating[0]) / 5,
                strokeWidth: 5,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation(Colors.blue),
              ),
              Text(
                rating,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}
