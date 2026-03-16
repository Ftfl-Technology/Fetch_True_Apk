import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../bloc/live_webinar/live_webinar_bloc.dart';
import '../model/live_webinar_model.dart';
import '../repository/live_webinar_repository.dart';
import 'enroll_now_screen.dart';

class LiveWebinarScreen extends StatelessWidget {
  const LiveWebinarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    return BlocProvider(
      create: (_) => LiveWebinarBloc(LiveWebinarRepository())..add(FetchLiveWebinarsEvent()),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Live Webinar', showBackButton: true),
        body: BlocBuilder<LiveWebinarBloc, LiveWebinarState>(
          builder: (context, state) {
            if (state is LiveWebinarLoading) {
              return _buildLiveWebinarShimmer(context);
            }

            if (state is LiveWebinarError) {
              return Center(child: Text(state.message));
            }

            if (state is LiveWebinarLoaded) {
              final dimensions = Dimensions(context);
              final webinars = state.liveWebinarModel.data;




              if (webinars.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: dimensions.screenHeight * 0.3),
                    child: const Text('No Webinars available'),
                  ),
                );
              }

              final userJoinedWebinars = webinars.where((webinar) {
                return webinar.user.any(
                      (u) => u.user == userSession.userId.toString() && u.status == true,
                );
              }).toList();

              return SingleChildScrollView(
                child: Column(
                  children: [
                    /// 🔹 Webinar List
                    ListView.builder(
                      itemCount: webinars.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 0.03),
                      itemBuilder: (context, index) {
                        final webinar = webinars[index];
                        return _buildWebinarCard(context, webinar, dimensions,userSession.userId.toString() );
                      },
                    ),
                    30.height,

                    if (userJoinedWebinars.length >= 1)
                    Text('-: Attend at least 3 live webinars to move forward :-', style: textStyle14(context)),

                    /// 🔹 Recent Webinars (Top 3)
                    ListView.builder(
                      itemCount: userJoinedWebinars.length < 3
                          ? userJoinedWebinars.length
                          : 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 0.03),
                      itemBuilder: (context, index) {
                        final data = userJoinedWebinars[index];
                        return _buildMiniCard(context, data, dimensions);
                      },
                    ),
                    20.height,
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  // ✅ Webinar Main Card
  Widget _buildWebinarCard(BuildContext context, LiveWebinar webinar, Dimensions dimensions, String userId) {
    final bool alreadyJoined = webinar.user.any(
          (u) => u.user == userId && u.status == true,
    );
    return CustomContainer(
      color: CustomColor.whiteColor,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(top: dimensions.screenHeight * 0.015),
      child: Column(
        children: [
          CustomContainer(
            margin: EdgeInsets.zero,
            networkImg: webinar.imageUrl,
            height: dimensions.screenHeight * 0.18,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(webinar.name, style: textStyle12(context)),
                Text(webinar.description,
                    style: textStyle12(context,
                        color: CustomColor.descriptionColor,
                        fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Start: ${webinar.startTime}', style: textStyle12(context)),
                        10.width,
                        Text('End: ${webinar.endTime}', style: textStyle12(context)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {

                        if (userId.isEmpty || userId == "null") {
                          showCustomToast('Please sign in first!');
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EnrollNowScreen(webinarId: webinar.id,),
                          ),
                        );
                      },
                      child: CustomContainer(
                        color: CustomColor.appColor,
                        margin: EdgeInsets.zero,
                        padding:  EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        child: Text(alreadyJoined?'Enrolled':'Enroll Now',
                            style: textStyle12(context, color: CustomColor.whiteColor)),
                      ),
                    ),
                  ],
                ),
                Text('Date: ${webinar.date}', style: textStyle12(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Mini Card for bottom section
  Widget _buildMiniCard(BuildContext context, LiveWebinar data, Dimensions dimensions) {
    return CustomContainer(
      border: false,
      color: CustomColor.whiteColor,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(top: dimensions.screenHeight * 0.015),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            width: dimensions.screenWidth * 0.4,
            height: dimensions.screenHeight * 0.1,
            margin: EdgeInsets.zero,
            networkImg: data.imageUrl,
            child: Align(
              alignment: Alignment.topRight,
              child: Icon(Icons.library_add_check_outlined, color: CustomColor.whiteColor),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.name, style: textStyle12(context)),
                  Text(data.description,
                      style: textStyle12(context,
                          color: CustomColor.greyColor, fontWeight: FontWeight.w400),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


Widget _buildLiveWebinarShimmer(BuildContext context) {
  Dimensions dimensions = Dimensions(context);
  return ListView.builder(
    itemCount: 3,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.symmetric(horizontal: dimensions.screenWidth * 0.03),
    itemBuilder: (context, index) {
      return CustomContainer(
        color: CustomColor.whiteColor,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.only(top: dimensions.screenHeight * 0.015),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              CustomContainer(
                height: dimensions.screenHeight * 0.16,
                width: double.infinity,
                margin: EdgeInsets.zero,
                color: Colors.grey[300],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomContainer(height: 10, width: 100, color: Colors.grey[300], margin: EdgeInsets.zero),
                        CustomContainer(height: 10, width: 80, color: Colors.grey[300], margin: EdgeInsets.zero),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomContainer(height: 10, width: double.infinity, color: Colors.grey[300], margin: EdgeInsets.zero),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomContainer(height: 10, width: 60, color: Colors.grey[300], margin: EdgeInsets.zero),
                            const SizedBox(width: 10),
                            CustomContainer(height: 10, width: 60, color: Colors.grey[300], margin: EdgeInsets.zero),
                          ],
                        ),
                        CustomContainer(height: 25, width: 90, color: Colors.grey[300], margin: EdgeInsets.zero),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
