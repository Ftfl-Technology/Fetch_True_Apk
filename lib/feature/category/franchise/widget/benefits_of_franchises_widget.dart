import 'dart:math';

import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_state.dart';


class BenefitsOfFranchisesWidget extends StatelessWidget {
  final String moduleId;
  const BenefitsOfFranchisesWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WhyJustOurServiceBloc, WhyJustOurServiceState>(
      builder: (context, state) {
        if (state is WhyJustOurServiceLoading) {
          return SizedBox.shrink();
        }

        if (state is WhyJustOurServiceLoaded) {

          final moduleData = state.model.data.firstWhere(
                (e) => e.module.id == moduleId,
            orElse: () => state.model.data.first,
          );

          final items = moduleData.items;

          if (items.isEmpty) {
            return const SizedBox();
          }

          return Column(
            children: [
              30.height,
              /// 🔹 Heading
              const Text(
                "Benefits of Franchises",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "What you get from us",
                style: TextStyle(
                  fontSize: 16,
                  color: CustomColor.descriptionColor,
                ),
              ),

              /// 🔹 White Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      final data = items[index];
                      return _BenefitItem(
                        icon: data.icon,
                        title: data.title,
                        description: data.description,
                      );
                    },),
              ),
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
}

/// 🔹 Benefit Card Widget
class _BenefitItem extends StatelessWidget {
  final String title;
  final String description;
  final String icon;

  const _BenefitItem({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: RegularOctagonClipper(),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xffF6F8FF),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Check Icon
            CircleAvatar(
              backgroundColor: CustomColor.whiteColor,
              backgroundImage: NetworkImage(icon),
            ),
            10.height,
            /// Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),

            /// Description
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class RegularOctagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;

    // radius = half of shortest side
    final double radius = min(size.width, size.height) / 2;

    final Path path = Path();

    for (int i = 0; i < 8; i++) {
      final double angle = (pi / 4) * i - pi / 8; // rotate for flat top
      final double x = cx + radius * cos(angle);
      final double y = cy + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
