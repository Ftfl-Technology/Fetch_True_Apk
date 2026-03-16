import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/costants/dimension.dart';
import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_state.dart';

class AiWhyJustOurServicesWidget extends StatelessWidget {
  final String moduleId;
  const AiWhyJustOurServicesWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return BlocBuilder<WhyJustOurServiceBloc, WhyJustOurServiceState>(
      builder: (context, state) {
        if (state is WhyJustOurServiceLoading) {
          return SizedBox.shrink();
        }

        if (state is WhyJustOurServiceLoaded) {


          if (state.model.data.isEmpty) {
            return const SizedBox();
          }

          final items = state.model.data.first.items;

          if (items.isEmpty) {
            return const SizedBox();
          }

          return Container(
            decoration: BoxDecoration(
              color: CustomColor.aiHub.withOpacity(0.1),
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text('Why Just Our AI Services',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                const SizedBox(height: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(items.length, (index) {
                    final item = items[index];

                    return _FeatureCard(
                      icon:  item.icon,
                      title: "${item.title}",
                      subtitle:'${item.description}',
                    );
                  }),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        }

        if (state is WhyJustOurServiceError) {
          return Text(state.message);
        }

        return const SizedBox();
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Blue icon circle
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF0099C6),
              shape: BoxShape.circle,
            ),
            child: Image.network(
              icon,
              height: 20,
            ),
          ),

          const SizedBox(width: 14),

          /// Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A7A7A),
                    height: 1.4,
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


