import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_state.dart';

class WhyChooseUsWidget extends StatelessWidget {
  final String moduleId;
  const WhyChooseUsWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WhyJustOurServiceBloc, WhyJustOurServiceState>(
      builder: (context, state) {
        if (state is WhyJustOurServiceLoading) {
          return const SizedBox.shrink();
        }

        if (state is WhyJustOurServiceLoaded) {
          final items = state.model.data.first.items;

          if (items.isEmpty) return const SizedBox();

          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Why Choose Us",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "we are providing service that no other providers can give you with benefits",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7A7A7A),
                  ),
                ),
                const SizedBox(height: 16),

                /// Large card
                WhyChooseCard(
                  title: items[0].title,
                  description: items[0].description,
                  icon: items[0].icon,
                  isLarge: true,
                ),

                const SizedBox(height: 12),

                /// Bottom cards (NOW WITH DESCRIPTION)
                if (items.length > 2)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: WhyChooseCard(
                          title: items[1].title,
                          description: items[1].description,
                          icon: items[1].icon,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: WhyChooseCard(
                          title: items[2].title,
                          description: items[2].description,
                          icon: items[2].icon,
                        ),
                      ),
                    ],
                  ),
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

class WhyChooseCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? icon;
  final bool isLarge;

  const WhyChooseCard({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F9FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment:
        isLarge ? CrossAxisAlignment.start : CrossAxisAlignment.start,
        children: [
          /// Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:  TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (description != null && description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    description!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7A7A7A),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),

          /// Network Icon
          if (icon != null && icon!.isNotEmpty) ...[
            const SizedBox(width: 12),
            SizedBox(
              height: isLarge ? 42 : 36,
              width: isLarge ? 42 : 36,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  icon!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
