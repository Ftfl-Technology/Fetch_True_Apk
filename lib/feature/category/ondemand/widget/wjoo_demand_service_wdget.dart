import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_state.dart';

class WjooDemandServiceWdget extends StatelessWidget {
  final String moduleId;
  const WjooDemandServiceWdget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WhyJustOurServiceBloc, WhyJustOurServiceState>(
      builder: (context, state) {
        if (state is WhyJustOurServiceLoading) {
          return SizedBox.shrink();
        }

        if (state is WhyJustOurServiceLoaded) {

          final moduleData = state.model.data
              .where((e) => e.module.id == moduleId)
              .toList();

          if (moduleData.isEmpty) {
            return const SizedBox();
          }

          final items = moduleData.first.items;


          return Column(
            children:  [
              40.height,
              Text('Why Just Our On Demand Service',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
              20.height,

              Column(
                children: List.generate(items.length, (index) {
                  final data = items[index];
                  return    _InfoCard(
                    iconUrl: data.icon,
                    title: data.title,
                    description:data.description,
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
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconUrl;

  const _InfoCard({
    required this.title,
    required this.description,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1C6),
              shape: BoxShape.circle,
              image: DecorationImage(image: NetworkImage('$iconUrl'))
            ),
          ),

          const SizedBox(width: 14),

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
                  description,
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
