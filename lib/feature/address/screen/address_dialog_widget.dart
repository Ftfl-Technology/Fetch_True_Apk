import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'address_picker_screen.dart';

class AddressDialogWidget extends StatelessWidget {

  const AddressDialogWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, color: Colors.green, size: 40),
            const SizedBox(height: 10),
            const Text(
              "Your Current Address",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),
             CustomContainer(
               width: double.infinity,
               color: CustomColor.appColor,
               child: Center(child: Text('Get Address', style: textStyle14(context, color: CustomColor.whiteColor),)),
               onTap: () {
                 Navigator.pop(context);

                 GoRouter.of(context).push('/address');
               },
             )
          ],
        ),
      ),
    );
  }
}
