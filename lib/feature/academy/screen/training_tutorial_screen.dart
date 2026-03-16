import 'package:fetchtrue/feature/academy/screen/play_video_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../model/training_tutorial_model.dart';
import '../repository/training_tutorial_service.dart';

class TrainingTutorialScreen extends StatefulWidget {
  const TrainingTutorialScreen({super.key});

  @override
  State<TrainingTutorialScreen> createState() => _TrainingTutorialScreenState();
}

class _TrainingTutorialScreenState extends State<TrainingTutorialScreen> {

  late Future<List<TrainingTutorialModel>> _futureTutorial;

  @override
  void initState() {
    super.initState();
    _futureTutorial = TrainingTutorialService().fetchTrainingTutorial();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Training Tutorial', showBackButton: true,),

      body:FutureBuilder(
          future: _futureTutorial,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSmearEffect(dimensions);
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No certifications found"));
            }

            final tutorialCard = snapshot.data!;

            return SafeArea(
              child: ListView.builder(
                itemCount: tutorialCard.length,
                padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
                itemBuilder: (context, index) {
                  final tutorial = tutorialCard[index];

                  return CustomContainer(
                    color: CustomColor.whiteColor,
                    padding: EdgeInsets.zero,
                    margin: EdgeInsets.only(top: dimensions.screenHeight*0.015),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomContainer(
                          networkImg: tutorial.imageUrl,
                          height: dimensions.screenHeight*0.18,
                          margin: EdgeInsets.zero,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayVideoScreen(
                                name: tutorial.name,
                                videoList: tutorial.videoList,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${tutorial.name}', style: textStyle12(context),),
                                    Text('${tutorial.description}', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),maxLines: 2, overflow: TextOverflow.ellipsis,),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          },
      )
    );
  }
}



Widget _buildSmearEffect(Dimensions dimensions) {
  return ListView(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    children: List.generate(4, (index) =>
        CustomContainer(
          color: CustomColor.whiteColor,
          padding: EdgeInsets.zero,
          margin: EdgeInsets.only(top: dimensions.screenHeight * 0.015),
          // Shimmer effect
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!, // Use null-safe bang
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image placeholder
                CustomContainer(
                  height: dimensions.screenHeight * 0.18,
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  color: Colors.grey[300]!, // Match baseColor
                ),
                const SizedBox(height: 8),
                // Text rows
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomContainer(
                            width: 100,
                            height: 10,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            color: Colors.grey[300]!,
                          ),
                          const SizedBox(height: 10),
                          CustomContainer(
                            width: 150,
                            height: 10,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            color: Colors.grey[300]!,
                          ),
                        ],
                      ),
                      // Right Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomContainer(
                            width: 80,
                            height: 10,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            color: Colors.grey[300]!,
                          ),
                          const SizedBox(height: 10),
                          CustomContainer(
                            width: 100,
                            height: 10,
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            color: Colors.grey[300]!,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    ),
  );
}
