import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/costants/dimension.dart';
import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_state.dart';

class WhyJustOurServicesWidget extends StatelessWidget {
  final String moduleId;
  const WhyJustOurServicesWidget({super.key, required this.moduleId});

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

          return Container(
            decoration: BoxDecoration(
                color: CustomColor.marketing.withOpacity(1),
              image: DecorationImage(image: AssetImage(
                  'assets/marketing/marketying_app_banner.png',
              ),fit: BoxFit.fill,opacity:0.15)
            ),
            child: Column(
              children: [
                const SizedBox(height: 30),
                 Text(
                  'Why Just Our Services',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: CustomColor.whiteColor,
                  ),
                ),
                20.height,

                /// ✅ SAME UI – ONLY DATA DYNAMIC
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(items.length, (index) {
                    final item = items[index];

                    return CustomContainer(
                      color: CustomColor.whiteColor,
                      margin: index == 0
                          ? const EdgeInsets.all(15)
                          : const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: CustomColor.marketing,
                          child: Image.network(
                            item.icon,
                            width: 18,
                            height: 18,
                            errorBuilder: (_, __, ___) =>  Icon(
                              Icons.check_circle_outline_outlined,
                              color: CustomColor.whiteColor,
                            ),
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(item.description),
                      ),
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

