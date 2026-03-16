import 'package:flutter/material.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_state.dart';

class LegalServiceSpotlightWidget extends StatelessWidget {
  const LegalServiceSpotlightWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<WhyJustOurServiceBloc, WhyJustOurServiceState>(
      builder: (context, state) {
        if (state is WhyJustOurServiceLoading) {
          return SizedBox.shrink();
        }

        if (state is WhyJustOurServiceLoaded) {

          final items = state.model.data.first.items;

          if (items.isEmpty) {
            return const SizedBox();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              30.height,
              const Text(
                'Legal Service Spotlight',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'we are providing you the best and useful legal services',
                style: TextStyle(fontSize: 14,),
              ),

              SizedBox(height: dimensions.screenHeight * 0.02),

              Column(
                children: List.generate(items.length, (index) {
                  final data = items[index];
                  return      _legalCard(
                    icon: data.icon,
                    title: data.title,
                    subTitle: data.description,
                    tagText: data.list.toString(),
                  );
                },),
              )
            ],
          );
        }

        if (state is WhyJustOurServiceError) {
          return Text(state.message);
        }

        return const SizedBox();
      },
    );
  }

  /// 🔹 Reusable Card
  Widget _legalCard({
    required String icon,
    required String title,
    required String subTitle,
    required String tagText,
    IconData? tagIcon,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF8A4826),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Image.network(
            icon,
            height: 50,
            width: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.image_not_supported_outlined,
                size: 40,
                color: Colors.white70,
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subTitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tagIcon != null) ...[
                  Icon(tagIcon, size: 14, color: Colors.black),
                  const SizedBox(width: 6),
                ],
                Text(
                  tagText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
