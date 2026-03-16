import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/why_just_our_service/why_just_our_service_bloc.dart';
import '../../bloc/why_just_our_service/why_just_our_service_state.dart';


class WjoFranchiseServicesWidget extends StatelessWidget {
  final String moduleId;
  const WjoFranchiseServicesWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
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
            children: [
              20.height,
              /// 🔹 Heading
              const Text(
                "Why Just Our Franchise Services",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),


              /// 🔹 White Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                 child: Column(
                   spacing: 10,
                   children: List.generate(items.length, (index) {
                     final data = items[index];
                     return Container(
                       decoration: BoxDecoration(
                         color: Color(0xFFFBFBFB),
                         borderRadius: BorderRadiusGeometry.circular(10),
                       ),
                       child: ListTile(
                         // dense: true,
                         // contentPadding: EdgeInsets.zero,
                         // minVerticalPadding: 0,
                         shape: BeveledRectangleBorder(
                           borderRadius: BorderRadiusGeometry.circular(10),
                           // side: BorderSide(color: CustomColor.greyColor ,width: 0.1)
                         ),
                         leading: CircleAvatar(
                           backgroundColor: CustomColor.franchise,
                           backgroundImage: NetworkImage(data.icon),
                         ),
                         title: Text(data.title.toString(), style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                         subtitle: Text(data.description.toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                       ),
                     );
                   },),
                 ),
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
