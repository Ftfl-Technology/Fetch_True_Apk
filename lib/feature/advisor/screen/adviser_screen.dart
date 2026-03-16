import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/helper/Contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/adviser/advisor_bloc.dart';
import '../bloc/adviser/advisor_event.dart';
import '../bloc/adviser/advisor_state.dart';
import '../repojetory/advisor_repository.dart';



class AdviserScreen extends StatefulWidget {
  const AdviserScreen({super.key});

  @override
  State<AdviserScreen> createState() => _AdviserScreenState();
}

class _AdviserScreenState extends State<AdviserScreen> {

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
        create: (_) => AdvisorBloc(repository: AdvisorRepository())..add(const FetchAdvisors()),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Advisers', showBackButton: true),
        body: BlocBuilder<AdvisorBloc, AdvisorState>(
          builder: (context, state) {
            if (state is AdvisorLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AdvisorLoaded) {
              return ListView.builder(
                itemCount: state.advisors.length,
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  final adviser = state.advisors[index];
                  return AdviserCard(
                    name: adviser.name,
                    imageUrl: adviser.imageUrl,
                    rating: adviser.rating,
                    phoneNumber: adviser.phoneNumber.toString(),
                    description: adviser.chat,
                    language: adviser.language,
                    tags: adviser.tags,
                  );                },
              );
            } else if (state is AdvisorEmpty) {
              return const Center(child: Text('No advisors found'));
            } else if (state is AdvisorError) {
              print('---------------Advisors Error: ${state.message}');
              return Center(child: Text('----------Error: ${state.message}'));
            }
            // initial
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class AdviserCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final double rating;
  final String phoneNumber;
  final String language;
  final String description;
  final List<String> tags;
  const AdviserCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.phoneNumber,
    required this.language,
    required this.description,
    required this.tags,
  });


  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: Colors.white,
      margin:  EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Profile
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[100],
                backgroundImage: NetworkImage(imageUrl),
              ),

              15.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: textStyle14(context,)),
                    Text(language, style: textStyle14(context,fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => ContactHelper.call(phoneNumber),
                      child: Image.asset(
                        CustomIcon.phoneIcon,
                        height: 25,
                        color: CustomColor.appColor,
                      ),
                    ),
                   50.width,
                    InkWell(
                      onTap: () => ContactHelper.whatsapp(phoneNumber, 'Hello!'),
                      child: Image.asset(
                        CustomIcon.whatsappIcon,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          5.height,

          if (tags.isNotEmpty)
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: tags.map((tag) {
                  return CustomContainer(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: Text(
                      tag,
                      style: textStyle12(context, color: CustomColor.blackColor),
                    ),
                  );
                }).toList(),
              ),
            ),

          Divider(color: Colors.grey.shade300),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('$description',style: textStyle14(context, fontWeight: FontWeight.w400),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
