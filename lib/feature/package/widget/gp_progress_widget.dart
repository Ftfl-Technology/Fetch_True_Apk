import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/team_build/screen/team_build_screen.dart';
import 'package:flutter/material.dart';

import '../../team_build/model/my_team_model.dart';
import '../model/referral_user_model.dart';

class GpProgressWidget extends StatelessWidget {
  final List<ReferralUser> referral;
  final List<MyTeamModel> team;
  const GpProgressWidget({
    super.key,
    required this.referral,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    final targetCount = 10;
    final currentCount = team.where((gpMember) {
      final status = gpMember.user?.packageStatus ?? "";
      return status == "GP" || status == "SGP" || status == "PGP";
    }).length;

    final displayCount = currentCount > targetCount ? targetCount : currentCount;

    final progress = (currentCount / targetCount).clamp(0.0, 1.0);
    final remaining = (targetCount - currentCount).clamp(0, targetCount);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if(remaining <= 10)
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(CustomColor.greenColor),
                ),
              ),
              10.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _labelBox(context, "$displayCount", CustomColor.greyColor),
                  _labelBox(context, "$targetCount", CustomColor.greenColor),
                ],
              ),
            ],
          ),
          15.height,
          Text(
            remaining > 0
                ? 'Almost there! Build your team with just $remaining more partners, you’ll become a SGP.'
                : '🎉 Congratulations! You have completed your team and become a SGP!',
            style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
          ),
          10.height,

          if(remaining <= 10 )
          CustomContainer(
            border: false,
            color: CustomColor.whiteColor,
            child: Center(child: Text('Build Team And Grow Your Level', style: textStyle12(context, color: CustomColor.appColor),)),
           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamBuildScreen(),)),
          )
        ],
      ),
    );
  }
}

Widget _labelBox(BuildContext context, String text, Color activeColor) {
  return Container(
    height: 22,
    width: 22,
    decoration: BoxDecoration(
      color: activeColor,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ),
  );
}